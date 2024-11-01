FROM python:3.12-alpine

RUN set -eux; \
  apk add git shadow su-exec; \
  PIP_ROOT_USER_ACTION=ignore pip install uv; \
  uv pip install --system black isort cookiecutter

COPY ./entrypoint.sh /usr/local/bin/entrypoint.sh
RUN chmod +x /usr/local/bin/entrypoint.sh

RUN addgroup -S scaf && adduser -s /bin/ash -S scaf -G scaf
WORKDIR /home/scaf/out

ENTRYPOINT [ "entrypoint.sh" ]
