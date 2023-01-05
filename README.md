# The Sixie Opinionated Django Cookiecutter

This is a work in progress project for jumpstarting production-ready Django projects. It is heavily inspired by the work
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

Answer the prompts with your own desired options and you'll have your new project!

# Development on the Cookie Cutter

When making changes to the Cookie Cutter, keep the following in mind:

* update pins in requirements/*.in files but *don't* commit the compiled requirements.txt
  files to the repo.
* update to latest Python supported by Django. For Django 4.1 this is 3.8, 3.9, and 3.10.
