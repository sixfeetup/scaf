# Build all of the dependanices then we will build the actual application image
FROM python:3.8-slim-buster as build

ENV PYTHONUNBUFFERED 1
ENV PYTHONDONTWRITEBYTECODE 1
ENV BOGUS 1

ARG DEVEL=no

RUN apt-get update \
  && apt-get install --no-install-recommends -y \
    build-essential \
    python3-dev default-libmysqlclient-dev \
    libpq-dev \
    gettext

# We create an /app directory with a virtual environment in it to store our
# application in.
RUN set -x \
    && python3 -m venv /app

# Now that we've created our virtual environment, we'll go ahead and update
# our $PATH to refer to it first.
ENV PATH="/app/bin:${PATH}"

# Next, we want to update pip, setuptools, and wheel inside of this virtual
# environment to ensure that we have the latest versions of them.
RUN pip --no-cache-dir --disable-pip-version-check install --upgrade pip setuptools wheel pip-tools

COPY requirements /tmp/requirements

RUN set -x \
    && pip-sync \
        /tmp/requirements/production.txt \
        /tmp/requirements/base.txt \
        $(if [ "$DEVEL" = "yes" ]; then for group in local tests; do echo "/tmp/requirements/${group}.txt"; done; fi)


# Now we can build the application image
FROM python:3.8-slim-buster

ENV PYTHONUNBUFFERED 1
ENV PYTHONDONTWRITEBYTECACHE 1
ENV PYTHONPATH /app
ENV PATH="/app/bin:${PATH}"
ENV BOGUS 1

WORKDIR /app/src

ARG DEVEL=no

# This is a work around because otherwise postgresql-client bombs out trying
# to create symlinks to these directories.
RUN set -x \
    && mkdir -p /usr/share/man/man1 \
    && mkdir -p /usr/share/man/man7

RUN apt-get update \
  # psycopg2 dependencies
  && apt-get install --no-install-recommends -y \
 {%- if cookiecutter.database == 'PostgreSQL' %}
    libpq-dev \
 {%- elif cookiecutter.database == 'MySQL' %}
    default-libmysqlclient-dev \
 {% endif %}
    gettext \
    $(if [ "$DEVEL" = "yes" ]; then echo 'bash'; \
 {%- if cookiecutter.database == 'PostgreSQL' %}
     echo 'postgresql-client' \
 {%- elif cookiecutter.database == 'MySQL' %}
    echo 'default-mysql-client' \
 {% endif %}
 ; fi) \
# cleaning up unused files
  && apt-get purge -y --auto-remove -o APT::AutoRemove::RecommendsImportant=false \
  && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

COPY --from=build /app/ /app/
COPY config/ /app/src/config/
COPY manage.py /app/src/
COPY {{ cookiecutter.project_slug }}/ /app/src/{{ cookiecutter.project_slug }}/
