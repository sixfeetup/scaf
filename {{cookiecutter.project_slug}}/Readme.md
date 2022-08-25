# {{ cookiecutter.project_name }} 

## Initial Project Setup

For the initial setup once the project has been generated, you will need to
compile the pinned versions of the project's Python package dependencies
(*before* running `make build-dev`):

    $ make compile

This will generate the requirements/*.txt files, and you should check these in to the repo.

If you need to update version pins for your project:

* make or add the change in the appropriate requrements/*.in file
* run `make compile`
* if you need to see what packages are out of date, run `make outdated`

At this point, it's probably a good idea to commit this initial version of the project
to version control:

    $ git init
    $ git add .
    $ git commit -m 'Initial commit'

You can then use any of a number of available git repository sites such as Bitbucket,
Gitlab, or GitHub to host the project; follow their instructions to push the repo to their
systems.

## Contributor setup

For subsequent contributors (after the project has been through initial setup and
pushed to a git repo), the `make compile` step should be skipped unless the express
intention is to update the package dependencies:

    $ git clone [repo]
    $ cd {{ cookiecutter.project_slug }}
    $ make build-dev
    $ make up

It may take a little bit of time for all the services to start up, and it's possible for
the first run to fail because of timing conflicts.  If you do see messages indicating there
were errors during the first run, stop all the containers using Ctrl-C, and then try it again.

Once all the containers are running, you should be able to 
access the site locally at `http://localhost:8009/`

Create a superuser:

    $ make shell
    $ ./manage.py createsuperuser

