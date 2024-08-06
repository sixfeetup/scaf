import sys

TERMINATOR = "\x1b[0m"
WARNING = "\x1b[1;33m [WARNING]: "
INFO = "\x1b[1;33m [INFO]: "
HINT = "\x1b[3;33m"
SUCCESS = "\x1b[1;32m [SUCCESS]: "

pv = sys.version_info
assert (
    pv.major == 3 and pv.minor in [8,9,10,11,12]
), "Django 4.1 only supports Python 3.8, 3.9, 3.10, 3.11, or 3.12."

project_slug = "{{ cookiecutter.project_slug }}"
if hasattr(project_slug, "isidentifier"):
    assert (
        project_slug.isidentifier()
    ), "'{}' project slug is not a valid Python identifier.".format(project_slug)

assert (
    project_slug == project_slug.lower()
), "'{}' project slug should be all lowercase".format(project_slug)

assert (
    "\\" not in "{{ cookiecutter.author_name }}"
), "Don't include backslashes in author name."
