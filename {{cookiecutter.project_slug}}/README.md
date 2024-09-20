# {{ cookiecutter.project_name }}
## How to set up your local environment for development

### Requirements

To work with Kubernetes, you need to install some additional software packages.
Depending on your operating system, the installation instructions may vary.

The documentation and scripts in the repo are written to work with `kubectl`, `kind` and `Tilt`.

Consult the links below if you prefer to use Minikube or Docker Desktop instead:
* [minikube](https://minikube.sigs.k8s.io/docs/start/).
* [Docker](https://docs.docker.com/get-docker/).

### Setup your environment

1. Get the repository

       $ git clone {{ cookiecutter.repo_url }}
       $ cd {{ cookiecutter.project_slug }}

2. Prepare the environment variables. Edit the `.envrc` file to work for your environment.

### Run the kubernetes cluster and the {{ cookiecutter.project_slug }} app to develop the code

First load the environment variables, then run:

      $ make setup
      $ tilt up

:information_source: It may take a little bit of time for all the services to start up, and it's possible for
the first run to fail because of timing conflicts. If you do see messages indicating there
were errors during the first run, stop all the containers using Ctrl-C, and then try it again.

You are now ready to edit the code.
The app will be automatically reloaded when its files change.

To delete resources created by Tilt once you are done working:

       $ tilt down

This will not delete persistent volumes created by Tilt, and you should be able to start Tilt again with your data intact.

To remove the cluster entirely:

       $ kind delete cluster --name {{ cookiecutter.project_slug }}

To switch between different Scaf project contexts:
      
      $ tilt down    # inside the codebase of the previous project
      $ make setup   # inside the codebase of the project you want to work on
      $ tilt up

### Update dependencies

To update the backend app dependencies, you must edit the `backend/requirements/*.in` files.
Once you have made your changes, you need to regenerate the `backend/requirements/*.txt` files using:

       $ make compile


## Next steps

Creating a superuser account in the backend is useful so you have access to
Django Admin that will be accesible at [http://localhost:8009/admin](http://localhost:8009/admin)

To create a superuser use the following commands:

    $ make shell-backend
    $ ./manage.py createsuperuser
{% if cookiecutter.create_nextjs_frontend == 'y' %}
This project has a NextJS frontend configured. You can access it at [http://localhost:3000/](http://localhost:3000/).
{% endif %}
## Infrastructure provisioning

Terraform can be used to provision AWS resources for your project deployment.
Read `terraform/README.md` for more information and steps for provisioning
resources.

## Application deployment

Use ArgoCD and Kubernetes to automate the deployment of your application to
your infrastructure. ArgoCD monitors changes within your repository, promptly
applying the relevant Kubernetes manifests. Read `bootstrap-cluster/README.md`
for more details.

## How to manage passwords and sensitive values

### Using SealedSecrets

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

### Using .envrc file

To ease managing your passwords and secrets you can store the values in 1Password.
You will need to install and configure [1Password cli](https://developer.1password.com/docs/cli/get-started/)

You can automatically source from the `.envrc` file using [direnv](https://direnv.net/docs/installation.html)

You can also manually export the variables to your environment using `source .envrc`



### Debugging

The steps below describe how to set up interactive debugging with PyCharm.

#### PyCharm Debugging Setup
Update `k8s/base/app.configmap.yaml` with `data` field `DEBUGGER_IDE: "pycharm"`

In PyCharm:

1. Go to 'Run' in the toolbar
2. Click on 'Edit Configurations'
3. Click on '+' in the top left of the dialog
4. Select 'Python Debug Server'
5. Set the host to 0.0.0.0 and the port to 6400, and the name as you see fit.
6. Click 'Ok'

#### Debugging in development
Before the code you want to debug, add the following lines:

```python
from {{ cookiecutter.project_slug }}.utils.debugger import connect_debugger
connect_debugger()
``` 
You can then set break points in your IDE and call the code as usual to hit them.

When the debugger is first connected, you will see a screen pop up about mapping - Click 'auto-detect' path mapping settings and choose the file that matches `backend/{{ cookiecutter.project_slug }}/utils/debugger.py` 

#### Troubleshooting
If the debugger is connected early on, such as in `manage.py`, standard django functionality such the admin interface may break. For that reason connecting in proximity to the code you want to test is recommended.

## How to monitor the application

{% if cookiecutter.use_sentry == 'y' %}
### How to monitor errors

Sentry can be used for error reporting at the application level. Sentry is included as a dependency in the project requirements, and the SENTRY_DSN configuration variable is included in the Django config map.
Next, one needs to add the project to Sentry by following the steps below:

Note: The values for both tokens can be empty if you don't wish to use Sentry.

1. Create two projects in your organisation's Sentry instance, e.g. https://sixfeetup.sentry.io/projects/
   1. One project for the backend 
   2. One project for the frontend 
2. Configure Slack notifications
3. Add team members in Sentry 
4. Update `k8s/base/app.configmap.yaml` `SENTRY_DSN_BACKEND`, `VITE_SENTRY_DSN_FRONTEND` with the DSNs appropriate for the relevant Sentry projects. 

For more detailed steps view `./docs/sentry.md`

{% endif %}
### How to monitor logs and the deployed application

Install Loki for log aggregation and the Kube Prometheus Stack with Grafana Dashboards for monitoring.

#### Setup AWS credentials

First export the credentials to your environment variables. Change the values accordingly:

```
export AWS_ACCESS_KEY_ID='ABC123456'
export AWS_SECRET_ACCESS_KEY='ABC123456'
```

Then create a secret in the monitoring namespace:

```
kubectl create secret generic iam-loki-s3 --from-literal=AWS_ACCESS_KEY_ID=$AWS_ACCESS_KEY_ID --from-literal=AWS_SECRET_ACCESS_KEY=$AWS_SECRET_ACCESS_KEY -n monitoring
```

#### Install monitoring

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

#### Connect to Grafana dashboard

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

#### Create a dashboard

There is a predefined django logs table dashboard that can be created with the following command:

```
make monitoring-dashboard
```
