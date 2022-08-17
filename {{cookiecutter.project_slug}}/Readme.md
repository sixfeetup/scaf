# {{ cookiecutter.project_name }} in Django 

    $ git clone [repo]
    $ cd {{ cookiecutter.project_slug }}
    $ make compile
    $ make build-dev
    $ make up

Access the site locally at http://localhost:8009/

Create a superuser:

    $ make shell
    $ ./manage.py createsuperuser

Update version pins for your project:

* make or add the change in the appropriate requrements/*.in file
* run `make compile`
* if you need to see what packages are out of date, run `make outdated`