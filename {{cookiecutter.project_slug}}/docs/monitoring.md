# :microscope: How to monitor the application
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

For more detailed steps view [Sentry specific documentation](/docs/sentry.md)

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
