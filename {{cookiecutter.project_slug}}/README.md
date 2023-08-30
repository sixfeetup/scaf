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

If React frontend was selected during the project creation
(using our [cookiecutter](https://github.com/sixfeetup/cookiecutter-sixiedjango)), you
can access it at [http://localhost:3000/](http://localhost:3000/).

## Install Loki for log aggregation and the Kube Prometheus Stack with Grafana Dashboards

Add a node to your cluster that you want to use for monitoring and run `kubectl
get nodes` for a list of nodes. You should see output similar to the following:

```
$ kubectl get nodes
NAME               STATUS   ROLES    AGE   VERSION
pool-fc410-bivim   Ready    <none>   48d   v1.26.3
pool-fc410-lziru   Ready    <none>   48d   v1.26.3
pool-fc410-qdznj   Ready    <none>   15d   v1.26.4
```

Pick the node that you want to use for monitoring and add the
"nodetype=monitoring" label to it:

```
kubectl label nodes pool-fc410-qdznj nodetype=monitoring
```

Now install the loki-stack and kube-prometheus-stack helm charts:

```
make monitoring-up
```

### Connect to Grafana dashboard

Connect to Grafana through local port forwarding, which is the only way to connect currently (since the service Grafana dashboard does not have an ingress entry on it's own)

```
make monitoring-forward
```

And open http://localhost:8080 on your browser

Login with admin / prom-operator that are the default values. To see these values, run

```
make monitoring-login
```

Login to Grafana and select Connections. This shows the big list of Data Sources that Grafana supports. Search Loki, select it and then hit `Create a Loki data source`

The only thing needed here with the current setup is to specify the URL, as http://loki:3100. Click `Save and test`. After a few seconds, it should show the message

```
Data source connected and labels found.
```
Anything else indicates a problem with the connection!

Hit the `Explore` button and this gets you to the place with existing data sources. Select the newly added Loki data source.

By default, you are on the code view, and you can hit the 'label browser' option on the left side and make a selection based on a number of items - eg select namespace and the namespace that interests you. Hit the `Live` mode on the right side of the screen to see logs in real time - a good check that things are setup as expected!


### Next steps for Loki

1. Enable persistency in Grafana, so that data sources connections (and dashboards?) are not lost on restarts
2. Add a Loki powered dashboard, set thresholds, create alerts, monitor for messages
3. Set up ingress for Grafana and Loki
