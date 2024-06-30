locals {
  common_machine_config_patch = {
    machine = {
      install = {
        image : "factory.talos.dev/installer/10e276a06c1f86b182757a962258ac00655d3425e5957f617bdc82f06894e39b:v1.7.4"
      }
      kubelet = {
        # The registerWithFQDN field is used to force kubelet to use the node
        # FQDN for registration. This is required in clouds like AWS.
        registerWithFQDN = true

        # # Required for Metrics Server
        extraArgs = {
          rotate-server-certificates : true
        }

        credentialProviderConfig : {
          apiVersion : "kubelet.config.k8s.io/v1",
          kind : "CredentialProviderConfig",
          providers : [
            {
              name : "ecr-credential-provider",
              matchImages : [
                "*.dkr.ecr.*.amazonaws.com",
                "*.dkr.ecr.*.amazonaws.com.cn",
                "*.dkr.ecr-fips.*.amazonaws.com",
                "*.dkr.ecr.us-iso-east-1.c2s.ic.gov",
                "*.dkr.ecr.us-isob-east-1.sc2s.sgov.gov"
              ],
              defaultCacheDuration : "12h",
              apiVersion : "credentialprovider.kubelet.k8s.io/v1"
            }
          ]
        }
      }
    }
  }

  cluster_patches_cp = {
    cluster = {
      # Allow scheduling work loads on the control plane since we don't have a
      # separate control plane
      allowSchedulingOnControlPlanes = true

      # Install Kubelet Serving Certificate Approver and metrics-server during
      # bootstrap
      extraManifests = [
        "https://raw.githubusercontent.com/alex1989hu/kubelet-serving-cert-approver/main/deploy/standalone-install.yaml",
        "https://github.com/kubernetes-sigs/metrics-server/releases/latest/download/components.yaml"
      ]
    }
  }

  config_patches_common = [
    for path in var.config_patch_files : file(path)
  ]

  config_patches_controlplane = [yamlencode(local.cluster_patches_cp)]

  cluster_required_tags = {
    "kubernetes.io/cluster/${var.cluster_name}" = "owned"
  }
}

resource "talos_machine_secrets" "this" {}

data "aws_ami" "talos" {
  owners      = ["540036508848"] # Sidero Labs
  most_recent = true
  name_regex  = "^talos-v\\d+\\.\\d+\\.\\d+-${data.aws_availability_zones.available.id}-amd64$"
}

data "talos_machine_configuration" "controlplane" {
  cluster_name       = var.cluster_name
  cluster_endpoint   = "https://${module.elb_k8s_elb.elb_dns_name}:6443"
  machine_type       = "controlplane"
  machine_secrets    = talos_machine_secrets.this.machine_secrets
  kubernetes_version = var.kubernetes_version
  talos_version      = "v1.7.4"
  docs               = false
  examples           = false
  config_patches = concat(
    local.config_patches_common,
    local.config_patches_controlplane,
    [yamlencode(local.common_machine_config_patch)],
    [for path in var.control_plane.config_patch_files : file(path)]
  )
}

resource "talos_machine_configuration_apply" "controlplane" {
  count = var.control_plane.num_instances

  client_configuration        = talos_machine_secrets.this.client_configuration
  machine_configuration_input = data.talos_machine_configuration.controlplane.machine_configuration
  endpoint                    = module.control_plane_nodes[count.index].public_ip
  node                        = module.control_plane_nodes[count.index].private_ip
}

resource "talos_machine_bootstrap" "this" {
  depends_on = [talos_machine_configuration_apply.controlplane]

  client_configuration = talos_machine_secrets.this.client_configuration
  endpoint             = module.control_plane_nodes.0.public_ip
  node                 = module.control_plane_nodes.0.private_ip
}

resource "null_resource" "check_talosconfig_exists" {
  provisioner "local-exec" {
    command = "test -f ./talosconfig"
  }
}

data "talos_client_configuration" "this" {
  cluster_name         = var.cluster_name
  client_configuration = talos_machine_secrets.this.client_configuration
  endpoints            = module.control_plane_nodes.*.public_ip
}

data "talos_cluster_kubeconfig" "this" {
  depends_on = [talos_machine_bootstrap.this]

  client_configuration = talos_machine_secrets.this.client_configuration
  endpoint             = module.control_plane_nodes.0.public_ip
  node                 = module.control_plane_nodes.0.private_ip
}

# disable this check by running `make remove-talos-state`
data "talos_cluster_health" "this" {
  count = fileexists("./talosconfig") ? 1 : 0

  depends_on = [
    data.talos_client_configuration.this,
    data.talos_cluster_kubeconfig.this,
    null_resource.check_talosconfig_exists
  ]

  client_configuration = talos_machine_secrets.this.client_configuration
  endpoints            = module.control_plane_nodes.*.public_ip
  control_plane_nodes  = module.control_plane_nodes.*.private_ip
}

resource "null_resource" "talosconfig_file" {
  depends_on = [data.talos_client_configuration.this]

  provisioner "local-exec" {
    command = "echo '${data.talos_client_configuration.this.talos_config}' > ./talosconfig"
  }
}

resource "null_resource" "kubeconfig_file" {
  depends_on = [talos_machine_bootstrap.this]

  provisioner "local-exec" {
    command = "echo '${data.talos_cluster_kubeconfig.this.kubeconfig_raw}' > ./kubeconfig"
  }
}
