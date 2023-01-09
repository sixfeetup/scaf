# The Sixie Opinionated Django Cookiecutter

This is a work in progress, but it is heavily inspired by the work
of [cookiecutter-django](https://github.com/pydanny/cookiecutter-django)
and Daniel Roy Greenfeld. It also borrows heavily from the ideas in the
PyPA [warehouse](https://github.com/pypa/warehouse) as I feel they have 
made an amazing developer onboarding experience for a very complicated
project.

Creating a new project using this repo:

    $ git clone git@github.com:sixfeetup/cookiecutter-sixiedjango.git
    $ cd cookiecutter-sixiedjango
    ### checkout a branch if you need to
    $ python3 -m venv .venv
    $ source .venv/bin/activate
    $ pip install -r requirements.txt
    $ cookiecutter . -o [path to destination folder]
    $ cd [path to destination folder]/[project slug]
    $ git init .
    $ make compile
    $ make build-dev
    $ make up

Answer the questions, and you'll have your new project!

# Development on the Cookie Cutter

When making changes to the Cookie Cutter, keep the following in mind:

* update pins in requirements/*.in files but *don't* commit the compiled requirements.txt
  files to the repo.
* update to latest Python supported by Django. For Django 4.1 this is 3.8, 3.9, and 3.10.


## Development using Kubernetes

This section describes the local development using [Kubernetes](https://kubernetes.io).

### Requirements

To work with Kubernetes you need to install some additional software packages. Depending on your operating system, the installation instructions may vary.

The following tools are required:

- `kubectl` to manage the Kubernetes cluster
- `skaffold` for local development with Kubernetes
- `minikube`, `kind` or `Docker Desktop` to run the Kubernetes cluster

We will use [minikube](https://minikube.sigs.k8s.io/docs/start/) here, as this creates a cluster and all required configuration out of the box. It requires a container or virtual machine manager to run. For MacOS, [Docker](https://docs.docker.com/get-docker/) is a good fit with most compatibility (VirtualBox currently has some issues).

The installation of `kubectl`, `kind` and `minikube` is decribed in the [Kubernetes Tools installation docs](https://kubernetes.io/docs/tasks/tools/).

For Mac using Docker and Homebrew, it would be the following:

1. Install Docker: https://docs.docker.com/get-docker/
1. `brew install kubectl minikube skaffold`

### Starting the cluster

1. Ensure `Docker` is running:
    ```
    docker ps
    CONTAINER ID   IMAGE                                 COMMAND                  CREATED        STATUS        PORTS                                                                                                                        NAMES
    1b2ea2890f42   gcr.io/k8s-minikube/kicbase:v0.0.36   "/usr/local/bin/entr…"   23 hours ago   Up 17 hours   0.0.0.0:50683->22/tcp, 0.0.0.0:50684->2376/tcp, 0.0.0.0:50686->5000/tcp, 0.0.0.0:50687->8443/tcp, 0.0.0.0:50685->32443/tcp   minikube
    ```
1. Start `minikube`:
    ```
    minikube start
    😄  minikube v1.28.0 on Darwin 13.1
    ✨  Using the docker driver based on existing profile
    👍  Starting control plane node minikube in cluster minikube
    🚜  Pulling base image ...
    🏃  Updating the running docker "minikube" container ...
    🐳  Preparing Kubernetes v1.25.3 on Docker 20.10.20 ...
    🔎  Verifying Kubernetes components...
        ▪ Using image docker.io/kubernetesui/dashboard:v2.7.0
        ▪ Using image gcr.io/k8s-minikube/storage-provisioner:v5
        ▪ Using image docker.io/kubernetesui/metrics-scraper:v1.0.8
    💡  Some dashboard features require the metrics-server addon. To enable all features please run:

      minikube addons enable metrics-server	


    🌟  Enabled addons: storage-provisioner, default-storageclass, dashboard
    🏄  Done! kubectl is now configured to use "minikube" cluster and "default" namespace by default
    ```
1. Optional: Start the `minikube` dashboard in a second terminal:
    ```
    minikube dashboard
    🤔  Verifying dashboard health ...
    🚀  Launching proxy ...
    🤔  Verifying proxy health ...
    🎉  Opening http://127.0.0.1:60284/api/v1/namespaces/kubernetes-dashboard/services/http:kubernetes-dashboard:/proxy/ in your default browser...
    ```
1. Deploy the cluster using `skaffold`:
    ```
    skaffold dev --tail=true
    ```
    🎉 After some time you cluster should be deployed in your local Kubernetes. In the terminal output you will also find the information about the **forwarded ports**:
    ```
    Deployments stabilized in 16.132 seconds
    Port forwarding service/frontend in namespace default, remote port 80 -> http://127.0.0.1:4503
    Port forwarding service/django in namespace default, remote port 8000 -> http://127.0.0.1:8000
    Port forwarding service/mailhog in namespace default, remote port 8025 -> http://127.0.0.1:8025
    Press Ctrl+C to exit
    Watching for changes...
    ```

To stop the development cluster, terminate the process with `CTRL-C`.

### Useful commands and tips

To check the deployed applications and services, use the `kubectl` command:

```
kubectl get all
NAME                              READY   STATUS      RESTARTS   AGE
pod/django-7b884699dc-52xmc       1/1     Running     0          69s
pod/django-migrations-job-c9znx   0/1     Completed   0          69s
pod/frontend-d58bbd6b9-9pkt8      1/1     Running     0          69s
pod/mailhog-8c7c977d5-wfx4x       1/1     Running     0          69s
pod/postgres-0                    1/1     Running     0          69s
pod/redis-7fc5d74b55-64vb9        1/1     Running     0          69s

NAME                 TYPE           CLUSTER-IP       EXTERNAL-IP   PORT(S)          AGE
service/django       NodePort       10.101.225.34    <none>        8000:30958/TCP   69s
service/frontend     NodePort       10.102.229.123   <none>        3000:31285/TCP   69s
service/kubernetes   ClusterIP      10.96.0.1        <none>        443/TCP          6d2h
service/mailhog      LoadBalancer   10.102.113.11    localhost     8025:32268/TCP   69s
service/postgres     ClusterIP      10.106.30.95     <none>        5432/TCP         69s
service/redis        LoadBalancer   10.106.206.224   localhost     6379:32403/TCP   69s

NAME                       READY   UP-TO-DATE   AVAILABLE   AGE
deployment.apps/django     1/1     1            1           69s
deployment.apps/frontend   1/1     1            1           69s
deployment.apps/mailhog    1/1     1            1           69s
deployment.apps/redis      1/1     1            1           69s

NAME                                 DESIRED   CURRENT   READY   AGE
replicaset.apps/django-7b884699dc    1         1         1       69s
replicaset.apps/frontend-d58bbd6b9   1         1         1       69s
replicaset.apps/mailhog-8c7c977d5    1         1         1       69s
replicaset.apps/redis-7fc5d74b55     1         1         1       69s

NAME                        READY   AGE
statefulset.apps/postgres   1/1     69s

NAME                              COMPLETIONS   DURATION   AGE
job.batch/django-migrations-job   1/1           53s        69s
```

You can inspect the logs of deployed pods using `kubectl logs` and the `id` of the pod:

```
kubectl logs pod/django-7b884699dc-52xmc
Watching for file changes with StatReloader
INFO 2023-01-09 05:59:59,208 autoreload 7 140028007683904 Watching for file changes with StatReloader
Performing system checks...

System check identified some issues:

WARNINGS:
?: (debug_toolbar.W006) At least one DjangoTemplates TEMPLATES configuration needs to have APP_DIRS set to True.
	HINT: Use APP_DIRS=True for at least one django.template.backends.django.DjangoTemplates backend configuration.

System check identified 1 issue (0 silenced).
January 09, 2023 - 05:59:59
Django version 4.1.5, using settings 'config.settings.local'
Starting development server at http://127.0.0.1:8000/
Quit the server with CONTROL-C.
```

To run a command within one of the `pods` (e.g. creating a Django user), you can log in into the running `container` in a `pod`:

```
kubectl exec -it pod/django-7b884699dc-52xmc -- /bin/bash
root@django-7b884699dc-52xmc:/app/src# python manage.py createsuperuser
```


To remove the `skaffold` deployment from the Kubernetes cluster, run `skaffold delete`.

This will remove all services and deployments created by `skaffold`. But it will not remove the persisted storage for `postgres`. To start with a clean database, you need to remove the persisted volume in `minikube`:

```
minikube ssh
docker@minikube:~$ pwd
/home/docker
docker@minikube:~$ cd /mnt/postgres-data
docker@minikube:/mnt/postgres-data$ ls
pgdata
docker@minikube:/mnt/postgres-data$ sudo rm -rf pgdata
```

To stop `minikube`, run `minikube stop`.
