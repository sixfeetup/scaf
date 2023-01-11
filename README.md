# The Sixie Opinionated Django Cookiecutter

This is a work in progress, but it is heavily inspired by the work
of [cookiecutter-django](https://github.com/pydanny/cookiecutter-django)
and Daniel Roy Greenfeld. It also borrows heavily from the ideas in the
PyPA [warehouse](https://github.com/pypa/warehouse) as I feel they have
made an amazing developer onboarding experience for a very complicated
project.

## Installing cookiecutter

To use this template, you need to install
[cookiecutter](https://cookiecutter.readthedocs.io/en/stable/) first. You can follow the
[instructions](https://cookiecutter.readthedocs.io/en/stable/installation.html) for your operating system.

The quickest way is performing a [user install](https://pip-python3.readthedocs.io/en/stable/user_guide.html#user-installs)
using the following command:

  $ python3 -m pip install --user cookiecutter

To verify if your install worked, you can use the following command (the versions may be
different for you):

  $ cookiecutter --version
  Cookiecutter 2.1.1 from /home/user/.local/lib/python3.10/site-packages (Python 3.10.6 (main, Nov 14 2022, 16:10:14) [GCC 11.3.0])

You will also need [black](https://pypi.org/project/black/) and [isort](https://pypi.org/project/isort/). You can install them using the commands:

  $ python3 -m pip install --user black
  $ python3 -m pip install --user isort

## Creating a new project using this repo

With [cookiecutter](https://cookiecutter.readthedocs.io/en/stable/) installed
in your environment you can create a new project with the command:

  $ cookiecutter https://github.com/sixfeetup/cookiecutter-sixiedjango/ -o [project_destination_directory]

Answer all the questions, and you'll have your new project!

Inside `[project_destination_directory]/[project_slug]/README.md` you will have more
documentation explaining how to use and configure your newly created project.

## Development on the Cookie Cutter

When making changes to the Cookie Cutter, keep the following in mind:

* update pins in requirements/*.in files but *don't* commit the compiled requirements.txt
  files to the repo.
* update to latest Python supported by Django. For Django 4.1 this is 3.8, 3.9, and 3.10.
