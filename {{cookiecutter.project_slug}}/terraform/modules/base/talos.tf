locals {
  common_machine_config_patch = {
    machine = {
      kubelet = {
        # The registerWithFQDN field is used to force kubelet to use the node
        # FQDN for registration. This is required in clouds like AWS.
        registerWithFQDN = true
      }
    }
  }

  cluster_patches_cp = {
    cluster = {
      # Allow scheduling work loads on the control plane since we don't have a
      # separate control plane
      allowSchedulingOnControlPlanes = true
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
  depends_on = [
    data.talos_client_configuration.this,
    data.talos_cluster_kubeconfig.this,
    null_resource.check_talosconfig_exists
  ]

  client_configuration = talos_machine_secrets.this.client_configuration
  endpoints            = module.control_plane_nodes.*.public_ip
  control_plane_nodes  = module.control_plane_nodes.*.private_ip
}
