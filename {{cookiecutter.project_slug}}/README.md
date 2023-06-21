# {{ cookiecutter.project_name }} 

## Requirements

We recommend you install `kind` or `minikube` to run a local Kubernetes cluster.

The installation of `kubectl,` `kind,` and `minikube` is described in the
[Kubernetes Tools installation docs](https://kubernetes.io/docs/tasks/tools/).

Additionally, you need to install [Tilt](https://tilt.dev) to rebuild container
images and perform live updates while developing.

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
