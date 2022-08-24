# {{ cookiecutter.project_name }} in Django 

    $ git clone [repo]
    $ cd {{ cookiecutter.project_slug }}
    $ make build-dev
    $ make up

Access the site locally at http://localhost:8009/

Create a superuser:

    $ make shell
    $ ./manage.py createsuperuser

## Initial Project Setup

When creating a new project, you will need to compile the pinned versions
(*before* running `make build-dev`):

    $ make compile

This will generate the requirements/*.txt files, and you should check these in to the repo.

If you need to update version pins for your project:

* make or add the change in the appropriate requrements/*.in file
* run `make compile`
* if you need to see what packages are out of date, run `make outdated`