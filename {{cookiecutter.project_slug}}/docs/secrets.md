# :shushing_face: How to manage passwords and sensitive values

## Using SealedSecrets

SealedSecrets can be used to encrypt passwords for the values to be safely checked in.
Creating a new secret involves encrypting the secret using kubeseal. [Installing kubeseal](https://github.com/bitnami-labs/sealed-secrets#kubeseal).

Configure kubernetes to your current project config and context, making sure you are in the correct prod/sandbox environment

    $ export KUBECONFIG=~/.kube/config:~/.kube/{{ cookiecutter.project_slug }}.ec2.config
    $ kubectl config use-context {{ cookiecutter.project_slug }}-ec2-cluster

Add the secrets to your manifest using the secrets template file, and run kubeseal on the unencrypted values. The makefile target `sandbox-secrets` will replace the variables in `./k8s/templates/secrets.yaml.template` with the encoded variables from the environment, and copy the manifest with the encrypted values to `.k8s/overlays/sandbox/secrets.yaml`. The same can be done for the prod environment using the `prod-secrets` target

    $ make sandbox-secrets

    $ make prod-secrets

The `k8s/*/secrets.yaml` file can now be safely checked in. The passwords will be unencrypted by SealedSecrets in the cluster.
When a secret is added/removed update the `k8s/templates` files, update the environment variables in .envrc and rerun the make commands.

The decrypted values can be retrieved running:

    $ kubectl get secret secrets-config -n {{ cookiecutter.project_dash }} -o yaml > unsealed_secrets.yaml

## Using .envrc file

To ease managing your passwords and secrets you can store the values in 1Password.
You will need to install and configure [1Password cli](https://developer.1password.com/docs/cli/get-started/)

You can automatically source from the `.envrc` file using [direnv](https://direnv.net/docs/installation.html)

You can also manually export the variables to your environment using `source .envrc`
