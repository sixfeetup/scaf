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

## Python Libraries

As an optionated template, we choose as dependencies some Python libraries and frameworks that
are configured and made available to be used during the project development. Some of them
will be installed only if requested when answering the questions in the project creation.

- [argon2-cffi](https://github.com/hynek/argon2_cffi) - it allows to use Argon2 as password hasher in Django, as [recommended](https://docs.djangoproject.com/en/4.1/topics/auth/passwords/#using-argon2-with-django) by Django docs.
- [celery](https://github.com/celery/celery) - Distributed Task Queue
- [crispy-bootstrap5](https://pypi.org/project/crispy-bootstrap5/) - Bootstrap5 template pack for django-crispy-forms.
- [django](https://www.djangoproject.com/) - The web framework for perfectionists with deadlines.
- [django-allauth](https://github.com/pennersr/django-allauth) - set of Django applications addressing authentication, registration, account management as well as 3rd party (social) account authentication. It considers that you are using regular Django Templates.
- [django-anymail](https://pypi.org/project/django-anymail/) - Django email backends for different providers (as Amazon SES, Mailgun, SMTP, etc).
- [django-celery-beat](https://github.com/celery/django-celery-beat) - Celery Periodic Tasks backed by the Django ORM.
- [django-compressor](https://github.com/django-compressor/django-compressor) - Compresses linked and inline javascript or CSS into a single cached file.
- [django-cors-headers](https://github.com/adamchainz/django-cors-headers) - Django app for handling the server headers required for Cross-Origin Resource Sharing (CORS). Needs to be configured for [REST framework](https://www.django-rest-framework.org/topics/ajax-csrf-cors/#cors).
- [django-crispy-forms](https://github.com/django-crispy-forms/django-crispy-forms) - improve rendering of Django forms. It considers that you are using regular Django Templates.
- [django-environ](https://django-environ.readthedocs.io/en/stable/) -  allows you to utilize 12-factor inspired environment variables to configure your Django application. It is being used in all project settings files.
- [django-model-utils](https://django-model-utils.readthedocs.io/en/stable/) - mixins and utilities for your project. It is not explicitly used in our generated project but available if wanted to be used.
- [django-redis](https://github.com/jazzband/django-redis) - Full featured redis cache backend for Django.
- [django-storages](https://pypi.org/project/django-storages/) - Support for many storage backends in Django.
- [djangorestframework](https://github.com/encode/django-rest-framework) - Django REST framework is a powerful and flexible toolkit for building Web APIs.
- [drf-spectacular](https://github.com/tfranzel/drf-spectacular) - Sane and flexible OpenAPI 3 schema generation for Django REST framework. Useful when testing and developing APIs.
- [flower](https://github.com/mher/flower) - Real-time monitor and web admin for Celery distributed task queue.
- [redis](https://github.com/redis/redis-py) - Redis Python Client. Required by Celery as we use Redis as [broker](https://docs.celeryq.dev/en/stable/getting-started/backends-and-brokers/redis.html#using-redis)
- [Pillow](https://pypi.org/project/Pillow/) - Python Imaging Library. Required if we have `models.ImageField` fields in our project.