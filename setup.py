#!/usr/bin/env python

import os
import sys

try:
    from setuptools import setup
except ImportError:
    from distutils.core import setup

# Our version ALWAYS matches the version of Django we support
# If Django has a new release, we branch, tag, then update this setting after the tag.
version = "4.1.0"

if sys.argv[-1] == "tag":
    os.system(f'git tag -a {version} -m "version {version}"')
    os.system("git push --tags")
    sys.exit()

with open("README.md") as readme_file:
    long_description = readme_file.read()

setup(
    name="cookiecutter-sixiedjango",
    version=version,
    description="A Cookiecutter template for creating production-ready Django projects quickly.",
    long_description=long_description,
    author="Calvin Hendryx-Parker",
    author_email="calvin@sixfeetup.com",
    url="https://github.com/sixfeetup/cookiecutter-sixiedjango",
    packages=[],
    license="BSD",
    zip_safe=False,
    classifiers=[
        "Development Status :: 4 - Beta",
        "Environment :: Console",
        "Framework :: Django :: 4.1",
        "Intended Audience :: Developers",
        "Natural Language :: English",
        "License :: OSI Approved :: BSD License",
        "Programming Language :: Python",
        "Programming Language :: Python :: 3",
        "Programming Language :: Python :: 3.8",
        "Programming Language :: Python :: 3.9",
        "Programming Language :: Python :: 3.10",
        "Programming Language :: Python :: Implementation :: CPython",
        "Topic :: Software Development",
    ],
    keywords=(
        "cookiecutter, Python, projects, project templates, django, "
        "skeleton, scaffolding, project directory, setup.py"
    ),
)
