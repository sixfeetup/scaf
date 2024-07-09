FROM node:16-bullseye-slim as base
FROM base AS build

WORKDIR /app
COPY package*.json ./
RUN npm install

# copy node_modules from the build image
FROM base

{% if cookiecutter.use_sentry == 'y' %}
# this is used by Sentry to associate errors with releases
ARG RELEASE="dev"
{% endif %}

WORKDIR /app
RUN chown node:node /app
COPY --from=build --chown=node:node /app/node_modules node_modules
COPY --chown=node:node . /app
USER node

CMD ["npm", "run", "dev"]
