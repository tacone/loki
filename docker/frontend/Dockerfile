FROM node:12-alpine

# we need it to brotli compress the static export
RUN apk add brotli

# copy the deps files, download and cache dependencies
COPY ./frontend/package.json ./frontend/yarn.lock /deps/

WORKDIR /deps

ARG BUILD_COMMAND
ENV BUILD_COMMAND ${BUILD_COMMAND}

ARG NODE_ENV
ENV NODE_ENV ${NODE_ENV}

RUN echo 'NODE_ENV set to '${NODE_ENV}''

RUN [ "$NODE_ENV" = 'production' ] && yarn --frozen-lockfile || yarn

# copy the application code
COPY ./frontend /app

# copy deps files back into the source tree
RUN mv -f package.json /app && mv -f yarn.lock /app && rm /app/node_modules -rf  && mv node_modules /app/ && rmdir /deps

WORKDIR /app

# if $BUILD_COMMAND is defined, export the app as static files
RUN if [ "$NODE_ENV" = 'production' ]; then [ "$BUILD_COMMAND" ] && $BUILD_COMMAND || echo 'Skipping export'; fi

# otherwise build the app as a node app
RUN if [ "$NODE_ENV" = 'production' ]; then [ "$BUILD_COMMAND" ] || yarn run build || echo 'Skipping build'; fi
