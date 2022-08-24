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
    # checkout a branch if you need to
    $ python3 -m venv
    $ venv/bin/pip install -r requirements.txt
    $ venv/bin/activate
    $ cookiecutter .

Answer the questions, and you'll have your new project!

# Development on the Cookie Cutter

When making changes to the Cookie Cutter, keep the following in mind:

* update pins in requirements/*.in files
* update to latest Python supported by Django