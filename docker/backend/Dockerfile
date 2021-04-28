FROM node:16-alpine

# we need it to brotli compress the static export
RUN apk add brotli

# copy the deps files, download and cache dependencies
COPY ./backend/package.json ./backend/yarn.lock /deps/

WORKDIR /deps

ARG BUILD_COMMAND
ENV BUILD_COMMAND ${BUILD_COMMAND}
RUN echo 'BUILD_COMMAND set to '${BUILD_COMMAND}

ARG NODE_ENV
ENV NODE_ENV ${NODE_ENV}
RUN echo 'NODE_ENV set to '${NODE_ENV}

RUN [ "$NODE_ENV" = 'production' ] && yarn --frozen-lockfile || echo "Skipping dependencies download during non-production build"

# copy the application code
COPY ./backend /app

# move deps files back into the source tree
RUN [ "$NODE_ENV" = 'production' ] && mv -f package.json /app && mv -f yarn.lock /app && rm /app/node_modules -rf  && mv node_modules /app/ && rmdir /deps || echo "No dependencies to move"

WORKDIR /app

RUN if [ "$NODE_ENV" = 'production' ]; then $BUILD_COMMAND || echo 'Skipping export'; fi
