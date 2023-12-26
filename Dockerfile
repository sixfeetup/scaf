FROM python:3.10-alpine

RUN apk add git shadow su-exec && \
  pip install --upgrade pip && \
  pip install black isort cookiecutter

COPY ./entrypoint.sh /usr/local/bin/entrypoint.sh

RUN addgroup -S scaf && adduser -s /bin/ash -S scaf -G scaf
WORKDIR /home/scaf/out
RUN chown scaf:scaf /home/scaf/out

ENTRYPOINT [ "entrypoint.sh" ]
