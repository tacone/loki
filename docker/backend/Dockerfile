FROM node:16-alpine

RUN apk add --no-cache postgresql-client su-exec

# copy the deps files, download and cache dependencies
COPY ./backend/package.json ./backend/yarn.loc[k] /deps/

WORKDIR /deps

# declare the NODE_ENV. This will invalidate the cache from now on if
# NODE_ENV changes.
ARG NODE_ENV
ENV NODE_ENV ${NODE_ENV}
RUN echo 'NODE_ENV set to '${NODE_ENV}

ENV YARN_CACHE_FOLDER /usr/local/share/.cache/yarn

RUN [ "$NODE_ENV" = 'production' ] && yarn --frozen-lockfile || echo "Skipping dependencies download during non-production build"

# copy the application code
COPY ./backend /app

# move deps files back into the source tree
RUN [ "$NODE_ENV" = 'production' ] && mv -f package.json /app && mv -f yarn.lock /app && rm /app/node_modules -rf  && mv node_modules /app/ && rmdir /deps || echo "No dependencies to move"

WORKDIR /app

ARG BUILD_COMMAND
ENV BUILD_COMMAND ${BUILD_COMMAND}
RUN echo 'BUILD_COMMAND set to '${BUILD_COMMAND}

RUN if [ "$NODE_ENV" = 'production' ]; then $BUILD_COMMAND || echo 'Skipping export'; fi

# 🔑
ARG USER_ID
RUN echo 'USER_ID set to ${USER_ID}'

RUN adduser -S app -u ${USER_ID} || echo USER ${USER_ID} already exists.
