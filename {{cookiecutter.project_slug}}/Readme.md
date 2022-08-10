# {{ cookiecutter.project_name }} in Django 

    $ git clone [repo]
    $ cd {{ cookiecutter.project_slug }}
    $ make build-dev
    $ make up

Access the site locally at http://localhost:8009/

Create a superuser:

    $ make shell
    # ./manage.py createsuperuser
