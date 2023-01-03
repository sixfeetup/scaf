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
    $ cookiecutter . -o [path to destination directory]

Answer the prompts with your own desired options and you'll have your new project! For example:

```text
project_name [My Awesome Sixie Project]: 
project_slug [my_awesome_sixie_project]: 
description [Behold My Awesome Project!]: 
author_name [Joe Sixie]: 
domain_name [sixfeetup.com]: 
email [joe-sixie@example.com]: 
version [0.1.0]: 
timezone [US/Eastern]: 
Select mail_service:
1 - Mailgun
2 - Amazon SES
3 - Other SMTP
Choose from 1, 2, 3 [1]: 
use_drf [n]: 
custom_bootstrap_compilation [n]: 
use_compressor [n]: 
use_celery [n]: 
debug [n]: 
```

# Development on the Cookie Cutter

When making changes to the Cookie Cutter, keep the following in mind:

* update pins in requirements/*.in files but *don't* commit the compiled requirements.txt
  files to the repo.
* update to latest Python supported by Django. For Django 4.1 this is 3.8, 3.9, and 3.10.
