{%- if cookiecutter.operating_system == "talos" %}# Bootstrap Talos and ArgoCD

After deploying infrastructure using Terraform, we can proceed with configuring
Talos and bootstrapping ArgoCD.

Terraform is solely utilized for deploying infrastructure. Any subsequent
configuration of Talos or ArgoCD is done using Taskfile tasks.
{%- elif cookiecutter.operating_system == "k3s" %}# Bootstrap k3s and ArgoCD

After deploying infrastructure using Terraform, we can proceed with configuring
k3s and bootstrapping ArgoCD.

Terraform is solely utilized for deploying infrastructure. Any subsequent
configuration of k3s or ArgoCD is done using Taskfile tasks.
{%- endif %}

To view a list of tasks and their descriptions, navigate to the
`bootstrap-cluster` directory and execute `task`.

Note that there is a directory for each environment: sandbox, staging, and
cluster.

We recommend opening the AWS serial console for each ec2 instance to monitor the
bootstrap process.

{%- if cookiecutter.operating_system == "talos" %}

### Bootstrapping Talos

{%- elif cookiecutter.operating_system == "k3s" %}

### Bootstrapping k3s

{%- endif %}

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

{%- if cookiecutter.operating_system == "talos" %}
   Note that we use a Talos factory image. This image contains a system
   extension that provides the ECR credential provider.

   ```
   siderolabs/ecr-credential-provider (v1.28.1)

       This system extension provides a binary which implements Kubelet's
       CredentialProvider API to authenticate against AWS' Elastic Container
       Registry and pull images.
   ```
{%- endif %}
{%- if cookiecutter.operating_system == "talos" %}
3. Bootstrap Talos with the following command:

   ```
   task talos:bootstrap
   ```

   To understand what this task will do, examine the Taskfile configuration:

   ```yaml
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

   It takes a few minutes for the cluster nodes to register as etcd
   members and synchronize.

{%- elif cookiecutter.operating_system == "k3s" %}
3. Bootstrap k3s with the following command:

   ```
   task k3s:bootstrap
   ```

   To understand what this task will do, examine the Taskfile configuration:

   ```yaml
   bootstrap:
     desc: |
       Run all tasks required to bootstrap k3s and Kubernetes cluster.
     requires:
       vars: [ENV]
     cmds:
       - task: save-node-ips
       - task: setup-ssh-key
       - task: install-k3s
       - task: fetch-kubeconfig
       - task: store-kubeconfig
       - task: enable-ecr-credential-helper
   ```

   It takes a few minutes for the cluster nodes to register as etcd
   members and synchronize.

{%- endif %}

   If the cluster fails to bootstrap, refer to the Troubleshooting section
   below.

{%- if cookiecutter.operating_system == "talos" %}
4. Verify the health of your cluster with:

    ```shell
    task talos:health
    ```

    5. Test kubectl access:

       ```shell
       eval $(task talos:kubeconfig)
       kubectl cluster-info
       ```
{%- elif cookiecutter.operating_system == "k3s" %}

4. Test kubectl access:

   ```shell
   eval $(task k3s:kubeconfig)
   kubectl cluster-info
   ```
{%- endif %}

   This should return output similar to the following:

   ```shell
   $ kubectl cluster-info
   Kubernetes control plane is running at https://k8s.sandbox.{{ cookiecutter.domain_name }}:6443
   CoreDNS is running at https://k8s.sandbox.{{ cookiecutter.domain_name }}:6443/api/v1/namespaces/kube-system/services/kube-dns:dns/proxy

   To further debug and diagnose cluster problems, use 'kubectl cluster-info dump'.
   ```

### Bootstrapping ArgoCD

1. Review the branches used for deployment to the sandbox, staging and
   production environments. The default configuration will release the `develop`
   branch to the Sandbox and the `main` branch to the Production environment.
   Make sure to make the `develop` branch the default branch for PRs on a newly
   created Git repository.

   Review the branch rule in `bootstrap_root_app` job in
   `bootstrap-cluster/argocd.yaml`:

   ```
   vars:
     BRANCH:
       sh: ([ "$ENV" = "production" ] && echo "main" || echo "develop")
   ```

   Review the `targetRevision` in the `kustomization.yaml` files shown below:

   `argocd/sandbox/apps/kustomization.yaml`:

   ```
   patches:
   - patch: |-
       - op: replace
         path: /spec/source/targetRevision
         value: develop
     target:
       kind: Application
       name: ingress
   ...
   - patch: |-
       - op: replace
         path: /spec/source/targetRevision
         value: develop
     target:
       kind: Application
       name: {{ cookiecutter.project_slug }}-prod
   ```

   `argocd/prod/apps/kustomization.yaml`:

   ```
   patches:
   - patch: |-
       - op: replace
         path: /spec/source/targetRevision
         value: main
     target:
       kind: Application
       name: ingress
   ```

2. Next, we need to create a GitHub deploy key to allow ArgoCD to monitor the
   repo. This step requires access to the 1password vault for your project.

   Review the vault name in the `op` cli command in
   `bootstrap-cluster/argocd.yaml`:

   ```
      - op item create
          ...
          --vault='{{ cookiecutter.project_name }}'
   ```

   Sign into 1password with `op signin` and generate the deploy key:

   ```shell
   task argocd:generate_github_deploy_key
   ```

3. Add the deploy key to your Git repository

4. Proceed with installing ArgoCD by executing:

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

5. ArgoCD will install the Sealed Secrets operator in the cluster. Once it is
   installed, we can generate secrets for the given environment.

   ```shell
   cd ..
   make debug-$ENV-secrets
   make $ENV-secrets
   ```

6. Commit the `secrets.yaml` file for the given environment and push it to the
   repo.

## Troubleshooting

{%- if cookiecutter.operating_system == "talos" %}
If bootstrapping Talos fails, we recommend resetting the config files and
recreating ec2 instances before trying again.

1. Reset config and state with `task talos:reset_config` for the given
   environment.

2. Destroy and recreate ec2 instances:

   cd ../terraform/$ENV/
   terraform destroy \
    -target "module.cluster.module.control_plane_nodes[0].aws_instance.this[0]" \
    -target "module.c luster.module.control_plane_nodes[1].aws_instance.this[0]" \
    -target "module.c luster.module.control_plane_nodes[1].aws_instance.this[0]"
   terraform plan -out="tfplan.out"
   terraform apply tfplan.out
{%- elif cookiecutter.operating_system == "k3s" %}
If bootstrapping k3s fails, we recommend uninstalling k3s from each node and
boostrapping from scratch.

```shell
task k3s:uninstall-k3s
```
{%- endif %}
