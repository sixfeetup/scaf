FROM python:3.10-alpine

RUN apk add git && \
  pip install --upgrade pip && \
  pip install black isort cookiecutter

ENTRYPOINT [ "cookiecutter" ]
