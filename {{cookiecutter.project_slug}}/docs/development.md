# :technologist: How to set up your local environment for development

## Requirements

To work with Kubernetes, you need to install some additional software packages.
Depending on your operating system, the installation instructions may vary.

The documentation and scripts in the repo are written to work with `kubectl`, `kind` and `Tilt`.

Consult the links below if you prefer to use Minikube or Docker Desktop instead:
* [minikube](https://minikube.sigs.k8s.io/docs/start/).
* [Docker](https://docs.docker.com/get-docker/).

## Setup your environment

1. Get the repository

       $ git clone {{ cookiecutter.repo_url }}
       $ cd {{ cookiecutter.project_slug }}

2. Prepare the environment variables. Edit the `.envrc` file to work for your environment.

## Run the kubernetes cluster and the {{ cookiecutter.project_slug }} app to develop the code

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

## Next steps

Creating a superuser account in the backend is useful so you have access to
Django Admin that will be accessible at [http://localhost:8000/admin](http://localhost:8000/admin)

To create a superuser use the following commands:

    $ make shell-backend
    $ ./manage.py createsuperuser
{% if cookiecutter.create_nextjs_frontend == 'y' %}
This project has a NextJS frontend configured. You can access it at [http://localhost:3000/](http://localhost:3000/).
{% endif %}

## Update dependencies

To update the backend app dependencies, you must edit the `backend/requirements/*.in` files.
Once you have made your changes, you need to regenerate the `backend/requirements/*.txt` files using:

       $ make compile
