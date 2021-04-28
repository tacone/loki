FROM node:16-alpine

# we need it to brotli compress the static export
RUN apk add brotli

# declare the NODE_ENV. This will invalidate the cache from now on if
# NODE_ENV changes.
ARG NODE_ENV
ENV NODE_ENV ${NODE_ENV}
RUN echo 'NODE_ENV set to '${NODE_ENV}

# we copy the deps files, and download the dependencies.
# the cache will only be invalidated if package.json and/or
# yarn.lock change
COPY ./svelte/package.json ./svelte/yarn.loc[k] /deps/
WORKDIR /deps
# we do not download dependencies in dev, because we do it when bootstraping
# docker-compose
# (we need to use the dev deps because of https://github.com/sveltejs/sapper/issues/592)
RUN [ "$NODE_ENV" = 'production' ] && NODE_ENV=develpment yarn --frozen-lockfile || echo "Environment != production: skipping download of dependencies"

# copy utility scripts
COPY ./scripts/bin/brotli-compress /usr/local/bin/brotli-compress

# copy the application code
COPY ./svelte /app

# move deps files back into the source tree
RUN if [ "$NODE_ENV" = 'production' ]; then mv -f package.json /app && mv -f yarn.lock /app && rm /app/node_modules -rf  && mv node_modules /app/ && rmdir /deps; else echo  "No dependencies to move"; fi

WORKDIR /app

ARG VITE_GRAPHQL_ENDPOINT
ENV VITE_GRAPHQL_ENDPOINT ${VITE_GRAPHQL_ENDPOINT}
RUN echo 'VITE_GRAPHQL_ENDPOINT set to '${VITE_GRAPHQL_ENDPOINT}

ARG BUILD_COMMAND
ENV BUILD_COMMAND ${BUILD_COMMAND}
RUN echo 'BUILD_COMMAND set to '${BUILD_COMMAND}

RUN if [ "$NODE_ENV" = 'production' ]; then sh -c "$BUILD_COMMAND"; else echo 'Skipping export'; fi
