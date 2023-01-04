import os
import random
import shutil
import string
import zipfile
import subprocess
import shlex

try:
    # Inspired by
    # https://github.com/django/django/blob/master/django/utils/crypto.py
    random = random.SystemRandom()
    using_sysrandom = True
except NotImplementedError:
    using_sysrandom = False

TERMINATOR = "\x1b[0m"
WARNING = "\x1b[1;33m [WARNING]: "
INFO = "\x1b[1;33m [INFO]: "
HINT = "\x1b[3;33m"
SUCCESS = "\x1b[1;32m [SUCCESS]: "

DEBUG_VALUE = "debug"


def remove_celery_files():
    file_names = [
        os.path.join("backend", "{{ cookiecutter.project_slug }}", "celery.py"),
        os.path.join("backend", "{{ cookiecutter.project_slug }}", "users", "tasks.py"),
        os.path.join(
            "backend", "{{ cookiecutter.project_slug }}", "users", "tests", "test_tasks.py"
        ),
        "django_celery_beat.zip",
    ]
    for file_name in file_names:
        os.remove(file_name)

def expand_django_celery_beat():
    zipfile.ZipFile("django_celery_beat.zip").extractall()
    os.unlink("django_celery_beat.zip")

def append_to_project_gitignore(path):
    gitignore_file_path = ".gitignore"
    with open(gitignore_file_path, "a") as gitignore_file:
        gitignore_file.write(path)
        gitignore_file.write(os.linesep)


def generate_random_string(
    length, using_digits=False, using_ascii_letters=False, using_punctuation=False
):
    """
    Example:
        opting out for 50 symbol-long, [a-z][A-Z][0-9] string
        would yield log_2((26+26+50)^50) ~= 334 bit strength.
    """
    if not using_sysrandom:
        return None

    symbols = []
    if using_digits:
        symbols += string.digits
    if using_ascii_letters:
        symbols += string.ascii_letters
    if using_punctuation:
        all_punctuation = set(string.punctuation)
        # These symbols can cause issues in environment variables
        unsuitable = {"'", '"', "\\", "$"}
        suitable = all_punctuation.difference(unsuitable)
        symbols += "".join(suitable)
    return "".join([random.choice(symbols) for _ in range(length)])


def set_flag(file_path, flag, value=None, formatted=None, *args, **kwargs):
    if value is None:
        random_string = generate_random_string(*args, **kwargs)
        if random_string is None:
            print(
                "We couldn't find a secure pseudo-random number generator on your system. "
                "Please, make sure to manually {} later.".format(flag)
            )
            random_string = flag
        if formatted is not None:
            random_string = formatted.format(random_string)
        value = random_string

    with open(file_path, "r+") as f:
        file_contents = f.read().replace(flag, value)
        f.seek(0)
        f.write(file_contents)
        f.truncate()

    return value


def set_django_secret_key(file_path):
    django_secret_key = set_flag(
        file_path,
        "!!!SET DJANGO_SECRET_KEY!!!",
        length=64,
        using_digits=True,
        using_ascii_letters=True,
    )
    return django_secret_key


def set_django_admin_url(file_path):
    django_admin_url = set_flag(
        file_path,
        "!!!SET DJANGO_ADMIN_URL!!!",
        formatted="{}/",
        length=32,
        using_digits=True,
        using_ascii_letters=True,
    )
    return django_admin_url


def generate_random_user():
    return generate_random_string(length=32, using_ascii_letters=True)


def generate_postgres_user(debug=False):
    return DEBUG_VALUE if debug else generate_random_user()


def set_postgres_user(file_path, value):
    postgres_user = set_flag(file_path, "!!!SET POSTGRES_USER!!!", value=value)
    return postgres_user


def set_postgres_password(file_path, value=None):
    postgres_password = set_flag(
        file_path,
        "!!!SET POSTGRES_PASSWORD!!!",
        value=value,
        length=64,
        using_digits=True,
        using_ascii_letters=True,
    )
    return postgres_password


def set_celery_flower_user(file_path, value):
    celery_flower_user = set_flag(
        file_path, "!!!SET CELERY_FLOWER_USER!!!", value=value
    )
    return celery_flower_user


def set_celery_flower_password(file_path, value=None):
    celery_flower_password = set_flag(
        file_path,
        "!!!SET CELERY_FLOWER_PASSWORD!!!",
        value=value,
        length=64,
        using_digits=True,
        using_ascii_letters=True,
    )
    return celery_flower_password


def append_to_gitignore_file(s):
    with open(".gitignore", "a") as gitignore_file:
        gitignore_file.write(s)
        gitignore_file.write(os.linesep)


def set_flags_in_envs(postgres_user, celery_flower_user, debug=False):
    local_env_path = os.path.join("backend", "local", "environment")

    set_postgres_user(local_env_path, value=postgres_user)
    set_postgres_password(
        local_env_path, value=DEBUG_VALUE if debug else None
    )

    set_celery_flower_user(local_env_path, value=celery_flower_user)
    set_celery_flower_password(
        local_env_path, value=DEBUG_VALUE if debug else None
    )


def set_flags_in_settings_files():
    set_django_secret_key(os.path.join("backend", "config", "settings", "local.py"))
    set_django_secret_key(os.path.join("backend", "config", "settings", "test.py"))


def remove_drf_starter_files():
    os.remove(os.path.join("backend", "config", "api_router.py"))
    shutil.rmtree(os.path.join("backend", "{{cookiecutter.project_slug}}", "users", "api"))
    os.remove(
        os.path.join(
            "backend", "{{cookiecutter.project_slug}}", "users", "tests", "test_drf_urls.py"
        )
    )
    os.remove(
        os.path.join(
            "backend", "{{cookiecutter.project_slug}}", "users", "tests", "test_drf_views.py"
        )
    )


def main():
    debug = "{{ cookiecutter.debug }}".lower() == "y"

    set_flags_in_envs(
        DEBUG_VALUE if debug else generate_random_user(),
        DEBUG_VALUE if debug else generate_random_user(),
        debug=debug,
    )
    set_flags_in_settings_files()

    if "{{ cookiecutter.use_celery }}".lower() == "n":
        remove_celery_files()
    else:
        expand_django_celery_beat()

    if "{{ cookiecutter.use_drf }}".lower() == "n":
        remove_drf_starter_files()

    subprocess.run(shlex.split("black ./backend"))
    subprocess.run(shlex.split("isort --profile=black ./backend"))

    print(SUCCESS + "Project initialized, keep up the good work!" + TERMINATOR)


if __name__ == "__main__":
    main()
