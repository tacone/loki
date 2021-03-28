FROM node:12-alpine

# we need it to brotli compress the static export
RUN apk add brotli

# copy the deps files, download and cache dependencies
COPY ./frontend/package.json ./frontend/yarn.lock /deps/

WORKDIR /deps

ARG BUILD_COMMAND
ENV BUILD_COMMAND ${BUILD_COMMAND}
RUN echo 'BUILD_COMMAND set to '${BUILD_COMMAND}

ARG NODE_ENV
ENV NODE_ENV ${NODE_ENV}
RUN echo 'NODE_ENV set to '${NODE_ENV}

ARG NEXT_PUBLIC_GRAPHQL_ENDPOINT
ENV NEXT_PUBLIC_GRAPHQL_ENDPOINT ${NEXT_PUBLIC_GRAPHQL_ENDPOINT}
RUN echo 'NEXT_PUBLIC_GRAPHQL_ENDPOINT set to '${NEXT_PUBLIC_GRAPHQL_ENDPOINT}


RUN [ "$NODE_ENV" = 'production' ] && yarn --frozen-lockfile || yarn

# copy the application code
COPY ./frontend /app

# copy deps files back into the source tree
RUN [ "$NODE_ENV" = 'production' ] &&  mv -f package.json /app && mv -f yarn.lock /app && rm /app/node_modules -rf  && mv node_modules /app/ && rmdir /deps

WORKDIR /app

RUN if [ "$NODE_ENV" = 'production' ]; then $BUILD_COMMAND || echo 'Skipping export'; fi
