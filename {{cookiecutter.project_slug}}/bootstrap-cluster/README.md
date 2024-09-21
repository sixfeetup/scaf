# Bootstrap Talos and ArgoCD

After deploying infrastructure using Terraform, we can proceed with configuring
Talos and bootstrapping ArgoCD.

Terraform is solely utilized for deploying infrastructure. Any subsequent
configuration of Talos or ArgoCD is done using Taskfile tasks.

To view a list of tasks and their descriptions, navigate to the
`bootstrap-cluster` directory and execute `task`.

Note that there is a directory for each environment: sandbox, staging, and
cluster.

We recommend opening the AWS serial console for each ec2 instance to monitor the
bootstrap process.

### Bootstrapping Talos

1. Navigate to the directory corresponding to the environment being set up and
   run:

   ```shell
   export ENV=sandbox
   cd $ENV
   ```

2. Review the `.env` file for the given environment:

   ```shell
   CONTROL_PLANE_ENDPOINT: "https://k8s.sandbox.{{ cookiecutter.domain_name }}:6443"
   CLUSTER_NAME: "{{ cookiecutter.project_dash }}-sandbox"
   ```

   Note that we use a Talos factory image. This image contains a system
   extension that provides the ECR credential provider.

   ```
   siderolabs/ecr-credential-provider (v1.28.1)

       This system extension provides a binary which implements Kubelet's
       CredentialProvider API to authenticate against AWS' Elastic Container
       Registry and pull images.
   ```

3. Bootstrap Talos with the following command:

   ```
   task talos:bootstrap
   ```

   To understand what this task will do, examine the Taskfile configuration:

   ```
   bootstrap:
       desc: |
           Run all tasks required to bootstrap the Talos and Kubernetes cluster.
       requires:
           vars: [ENV]
       cmds:
         - task: generate_configs
         - task: set_node_ips
         - task: store_controlplane_config
         - task: store_talosconfig
         - task: apply_talos_config
         - sleep 30
         - task: bootstrap_kubernetes
         - sleep 30
         - task: generate_kubeconfig
         - task: store_kubeconfig
         - task: upgrade_talos
         - task: enable_ecr_credential_helper
   ```

4. Verify the health of your cluster with:

   ```shell
   task talos:health
   ```

5. Test kubectl access:

   ```shell
   eval $(task talos:kubeconfig)
   kubectl cluster-info
   ```

   This should return output similar to the following:

   ```shell
   $ kubectl cluster-info
   Kubernetes control plane is running at https://k8s.sandbox.{{ cookiecutter.domain_name }}:6443
   CoreDNS is running at https://k8s.sandbox.{{ cookiecutter.domain_name }}:6443/api/v1/namespaces/kube-system/services/kube-dns:dns/proxy

   To further debug and diagnose cluster problems, use 'kubectl cluster-info dump'.
   ```

### Bootstrapping ArgoCD

1. First, we need to create a GitHub deploy key to allow ArgoCD to monitor the
   repo:

   ```shell
   task argocd:generate_github_deploy_key
   ```

2. Proceed with installing ArgoCD by executing:

   ```shell
   task argocd:bootstrap
   ```

The `argocd:bootstrap` task configuration is as follows:

```
  bootstrap:
      desc: Setup ArgoCD
      cmds:
        - task: install
        - task: create_repo_credentials_secret
        - task: bootstrap_root_app
```

3. ArgoCD will install the Sealed Secrets operator in the cluster. Once it is
   installed, we can generate secrets for the given environment.

   ```shell
   cd ..
   make debug-$ENV-secrets
   make $ENV-secrets
   ```

4. Commit the `secrets.yaml` file for the given environment and push it to the
   repo.
