# Build all of the dependencies then we will build the actual application image
FROM python:3.10-slim-bullseye as build

ENV PYTHONUNBUFFERED 1
ENV PYTHONDONTWRITEBYTECODE 1
ENV BOGUS 1

ARG DEVEL=no
ARG TEST=no

RUN apt-get update \
  && apt-get install --no-install-recommends -y \
    build-essential \
    ca-certificates \
    curl \
    gettext \
    gnupg \
  && curl https://www.postgresql.org/media/keys/ACCC4CF8.asc | apt-key add - \
  && echo "deb http://apt.postgresql.org/pub/repos/apt bullseye-pgdg main" > /etc/apt/sources.list.d/pgdg.list \
  && apt-get update \
  && apt-get install --no-install-recommends -y \
    libffi-dev \
    libpq-dev \
    libssl-dev \
    postgresql-client-14 \
    postgresql-client-common


# We create an /app directory with a virtual environment in it to store our
# application in.
RUN set -x \
    && python3 -m venv /app

# Now that we've created our virtual environment, we'll go ahead and update
# our $PATH to refer to it first.
ENV PATH="/app/bin:${PATH}"

# Next, we want to update pip, setuptools, and wheel inside of this virtual
# environment to ensure that we have the latest versions of them.
RUN pip --no-cache-dir --disable-pip-version-check install --upgrade pip setuptools wheel

RUN set -x \
    && if [ "$DEVEL" = "yes" ]; then pip --no-cache-dir --disable-pip-version-check install pydevd-pycharm~=203.5981.165 ; fi

COPY requirements /tmp/requirements

RUN set -x \
    && if [ "$DEVEL" = "yes" ]; then pip --no-cache-dir --disable-pip-version-check install --upgrade pip-tools; fi

RUN set -x \
    && if [ "$DEVEL" = "yes" ]; then pip --no-cache-dir --disable-pip-version-check install -r /tmp/requirements/local.txt; fi

RUN set -x \
    && pip --no-cache-dir --disable-pip-version-check install --no-deps \
        -r /tmp/requirements/production.txt \
        -r /tmp/requirements/base.txt

RUN set -x \
    && if [ "$TEST" = "yes" ]; then pip --no-cache-dir --disable-pip-version-check install --no-deps \
        -r /tmp/requirements/tests.txt; fi

# Next build front-end
FROM node:16-bullseye-slim as front-end

WORKDIR /app

COPY front-end /app

RUN npm install
RUN npm run build


# Now we can build the application image
FROM python:3.10-slim-bullseye

ENV PYTHONUNBUFFERED 1
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
    ca-certificates \
    curl \
    gettext \
    gnupg \
  && curl https://www.postgresql.org/media/keys/ACCC4CF8.asc | apt-key add - \
  && echo "deb http://apt.postgresql.org/pub/repos/apt bullseye-pgdg main" > /etc/apt/sources.list.d/pgdg.list \
  && apt-get update \
  && apt-get install --no-install-recommends -y \
    libpq5 \
    $(if [ "$DEVEL" = "yes" ]; then echo 'bash postgresql-client-14'; fi) \
  # awscli
  && apt-get install -y \
    awscli \
  # cleaning up unused files
  && apt-get remove -y \
    curl \
    gnupg \
  && apt-get purge -y --auto-remove -o APT::AutoRemove::RecommendsImportant=false \
  && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

COPY --from=build /app/ /app/
# COPY --from=front-end /app/build /app/build
COPY config/ /app/src/config/
COPY manage.py /app/src/
COPY {{ cookiecutter.project_slug }}/ /app/src/{{ cookiecutter.project_slug }}/
