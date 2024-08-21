# Build all of the dependencies then we will build the actual application image
FROM python:3.12-slim as build

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
    && echo "deb http://apt.postgresql.org/pub/repos/apt bookworm-pgdg main" > /etc/apt/sources.list.d/pgdg.list \
    && apt-get update \
    && apt-get install --no-install-recommends -y \
    libffi-dev \
    libpq-dev \
    libssl-dev \
    postgresql-client-16 \
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
RUN pip --no-cache-dir install --upgrade uv
RUN uv pip --no-cache install --upgrade setuptools wheel

COPY requirements /tmp/requirements

RUN set -x \
    && if [ "$DEVEL" = "yes" ]; then uv pip --no-cache install -r /tmp/requirements/local.txt; fi

RUN set -x \
    && uv pip --no-cache install --no-deps \
    -r /tmp/requirements/production.txt \
    -r /tmp/requirements/base.txt

RUN set -x \
    && if [ "$TEST" = "yes" ]; then uv pip --no-cache install --no-deps \
    -r /tmp/requirements/tests.txt; fi

# Now we can build the application image
FROM python:3.12-slim

ENV PYTHONUNBUFFERED 1
ENV PYTHONPATH /app
ENV PATH="/app/bin:${PATH}"
ENV BOGUS 1

WORKDIR /app/src

ARG DEVEL=no
# this is used by Sentry to associate errors with releases
ARG RELEASE="dev"

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
    && echo "deb http://apt.postgresql.org/pub/repos/apt bookworm-pgdg main" > /etc/apt/sources.list.d/pgdg.list \
    && apt-get update \
    && apt-get install --no-install-recommends -y \
    libpq5 \
    $(if [ "$DEVEL" = "yes" ]; then echo 'bash postgresql-client-16'; fi) \
    # awscli
    && apt-get install -y \
    awscli \
    # cleaning up unused files
    && apt-get remove -y \
    curl \
    gnupg \
    && apt-get purge -y --auto-remove -o APT::AutoRemove::RecommendsImportant=false \
    && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

RUN adduser --system --no-create-home django
COPY --chown=django:django --from=build /app/ /app/
COPY --chown=django:django config/ /app/src/config/
COPY --chown=django:django manage.py /app/src/
COPY --chown=django:django {{ cookiecutter.project_slug }}/ /app/src/{{ cookiecutter.project_slug }}/

USER django
