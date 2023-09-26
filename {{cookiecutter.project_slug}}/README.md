# {{ cookiecutter.project_name }}

## Requirements

We recommend you install `kind` or `minikube` to run a local Kubernetes cluster.

The installation of `kubectl,` `kind,` and `minikube` is described in the
[Kubernetes Tools installation docs](https://kubernetes.io/docs/tasks/tools/).

Additionally, you need to install [Tilt](https://tilt.dev) to rebuild container
images and perform live updates while developing.

If you plan to run cnpg, you need to install also cloudnative-pg to your k8s cluster:

    $ kubectl apply -f https://raw.githubusercontent.com/cloudnative-pg/cloudnative-pg/release-1.18/releases/cnpg-1.18.5.yaml

See documentation for more details: https://cloudnative-pg.io/documentation/1.18/installation_upgrade/#installation-on-kubernetes

## Initial Project Setup

For the initial setup once the project has been generated, you will need to
compile the pinned versions of the project's Python package dependencies. The
following command will generate the `requirements/*.txt` files, and you should
check these into the repo in the next step:

    $ make compile

At this point, it's probably a good idea to commit this initial version of the project
to version control:

    $ git init
    $ git add .
    $ git commit -m "Initial commit"

You can then use any of a number of available git repository sites such as Bitbucket,
Gitlab, or GitHub to host the project; follow their instructions to push the repo to their
systems.

Then you are ready to build the project for the first time. The following command
will build the project so you will be ready to start developing. First execution
of this command may take a few minutes to finish:

    $ tilt up

It may take a little bit of time for all the services to start up, and it's possible for
the first run to fail because of timing conflicts. If you do see messages indicating there
were errors during the first run, stop all the containers using Ctrl-C, and then try it again.

## Contributor setup

For subsequent contributors (after the project has been through initial setup and
pushed to a git repo), the `make compile` step should be skipped unless the express
intention is to update the package dependencies.

To prepare your development environment you can use the following commands:

    $ git clone [repo-url]
    $ cd {{ cookiecutter.project_slug }}
    $ make build-dev
    $ make up

## Next steps

Creating a superuser account in the backend is useful so you have access to
Django Admin that will be accesible at [http://localhost:8009/admin](http://localhost:8009/admin)

To create a superuser use the following commands:

    $ make shell
    $ ./manage.py createsuperuser
{% if cookiecutter.create_react_frontend == 'y' %}
This project has a React frontend configured. You can access it at [http://localhost:3000/](http://localhost:3000/).
{% endif %}
## Infrastructure provisioning

Terraform can be used to provision AWS resources for your project deployment.
terraform/ec2-cluster will create an EC2 instance running a kubernetes cluster for your project.
Check `terraform/ec2-cluster/README.md` for more information and steps for provisioning resources.

## Project deployment

ArgoCD and kubernetes can be used to automate the deployment of your project to your infrastructure.
ArgoCD will watch for changes in your repository and apply the kubernetes manifests.
Check `k8s/argocd/README.md` for more information on creating and setting up the ArgoCD application.

# SealedSecrets for passwords and sensitive values

SealedSecrets can be used to encrypt passwords for the values to be safely checked in.
Creating a new secret involves encrypting the secret using kubeseal. [Installing kubeseal](https://github.com/bitnami-labs/sealed-secrets#kubeseal).

Configure kubernetes to your current project config and context, making sure you are in the correct prod/sandbox environment

    $ export KUBECONFIG=~/.kube/config:~/.kube/{{cookiecutter.project_slug}}.ec2.config
    $ kubectl config use-context {{cookiecutter.project_slug}}-ec2-cluster

To ease managing your passwords and secrets you can store the values in 1Password. The `.envrc` file will read from 1Password and export the values to the enviroment.
You will need to install and configure [1Password cli](https://developer.1password.com/docs/cli/get-started/)
You can automatically source from the `.envrc` file using [direnv](https://direnv.net/docs/installation.html)

You can also manually export the variables to your environment.
Add the secrets to your manifest using the secrets template file, and run kubeseal on the unencrypted values. The makefile target `sandbox-secrets` will replace the variables in `./k8s/templates/secrets.yaml.template` with the encoded variables from the environment, and copy the manifest with the encrypted values to `.k8s/sandbox/secrets.yaml`. The same can be done for the prod environment using the `prod-secrets` target

    $ make sandbox-secrets

    $ make prod-secrets

The `k8s/*/secrets.yaml` file can now be safely checked in. The passwords will be unencrypted by SealedSecrets in the cluster.
When a secret is added/removed update the `k8s/templates` files, update the environment variables in .envrc and rerun the make commands.

The decrypted values can be retrieved running:

    $ kubectl get secret secrets-config -n {{cookiecutter.project_dash}} -o yaml > unsealed_secrets.yaml

## Adding Sentry to Projects

Sentry can be used for error reporting at the application level. Sentry is included as a dependency in the project requirements, and the SENTRY_DSN configuration variable is included in the Django config map.
Next, one needs to add the project to Sentry by following the steps below:

1. Create the project in your organisation's Sentry instance, e.g. https://sixfeetup.sentry.io/projects/
2. Configure Slack notifications
3. Add team members in Sentry
4. Install `sentry-sdk` from the requirements file
5. Update `django.configmap.yaml` SENTRY_DSN with the DSN provided in the Sentry project for this environment

For more detailed steps view `./docs/sentry.md`

## Install Loki for log aggregation and the Kube Prometheus Stack with Grafana Dashboards

### Setup AWS credentials

First export the credentials to your environment variables. Change the values accordingly:

```
export AWS_ACCESS_KEY_ID='ABC123456'
export AWS_SECRET_ACCESS_KEY='ABC123456'
```

Then create a secret in the monitoring namespace:

```
kubectl create secret generic iam-loki-s3 --from-literal=AWS_ACCESS_KEY_ID=$AWS_ACCESS_KEY_ID --from-literal=AWS_SECRET_ACCESS_KEY=$AWS_SECRET_ACCESS_KEY -n monitoring
```

### Install monitoring

Before installing the monitoring tools, you will need to export the GRAFANA_ADMIN_PASSWORD environment variable. This will be used to set the Grafana admin password. Change the value accordingly:

```
export GRAFANA_ADMIN_PASSWORD='ABC123456'
```

Now install the loki-stack and kube-prometheus-stack helm charts:

```
make monitoring-up
```

If you want to store the logs in an S3 bucket, you will need to include the yaml values `k8s/_monitoring/loki-stack-values.yaml` file for the `helm install loki` command in the Makefile:

```
helm install loki grafana/loki-stack --values k8s/_monitoring/loki-stack-values.yaml --namespace monitoring --create-namespace
```

### Connect to Grafana dashboard

You can connect to Grafana through local port forwarding using the steps below. Alternatively, you can set up ingress to point to Grafana.

```
make monitoring-port-forward
```

And open http://localhost:8080 on your browser

Login with admin / prom-operator that are the default values. To see these values, run

```
make monitoring-login
```

Login to Grafana. Hit the `Explore` button and this gets you to the place with existing data sources. Select the newly added Loki data source.

You are also able to change the password for the Grafana admin user. To do this, run the following command:

```
kubectl exec --namespace monitoring -c grafana -it $(kubectl get pods --namespace monitoring -l "app.kubernetes.io/name=grafana" -o jsonpath="{.items[0].metadata.name}") -- grafana-cli admin reset-admin-password newpassword
```

By default, you are on the code view, and you can hit the 'label browser' option on the left side and make a selection based on a number of items - eg select namespace and the namespace that interests you. Hit the `Live` mode on the right side of the screen to see logs in real time - a good check that things are setup as expected!

### Create a dashboard

There is a predefined django logs table dashboard that can be created with the following command:

```
make monitoring-dashboard
```
