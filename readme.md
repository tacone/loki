# Loki

A simple Docker / Frontend / Backend starter app, with a meaningless name.

- 👍 No-config first run
- 👍 Development mode with hot reloading everywhere
- 👍 Production mode with optional static file compilation
- 👍 Two alternative frontends: Svelte and NextJS
- 👍 GraphQL backend with Postgraphile + Migrations
- 👍 Unpriviledged user + readonly filesystem
- 👍 Small images + fast build

## Installation

Clone the project, then run:

```shell
scripts/dev up
```

When everything is up (it will take some time for the first run) these ports
will be exposed on your localhost:

- frontend: [7000](http://localhost:7000)
- svelte frontend: [7002](http://localhost:7002)
- backend: [7011](http://localhost:7011)
- postgres: 7040

To connect with postgres use:

- user: `postgres`
- password: `postgrespassword`
- host: `localhost`
- port: `7040`

The `scripts/dev` script wraps `docker-compose` so you can use it in the same
way (i.e. `scripts/dev build`, `scripts/dev down`, `scripts/dev ps`).

There is an additional command, `scripts/dev ports` that shows the configured ports.

The database files will be written in `data/`, so you can start from scratch by deleting `data/` along with `frontend/node_modules` and `backend/node_modules`.

## Production environment

To run the production environment, write:

```shell
scripts/production --build up
```

You should then access the frontend using [https://localhost:7443](https://localhost:7443).

> **Heads up!**
>
> You should always build when switching from dev to production mode.
>
> Also, since the application building process runs while building
> the docker container, you need to build the containers to have the
> latest changes applied.
>
> Summing up, **when you start the production environment, build**.

The production environment features:

- a container with Nginx webserver, exposing _HTTP_ (7080) and _HTTPS_ (7443) ports. HTTP/2 enabled. Capable of _gzip_ and _brotli_ compression.
- the postgres DB does not expose a public port while using the production envinroment.
- the GraphQL backend, will not expose the development console.
- the frontend is exported to a static website. All the files are pre-compressed with _brotli_ during build. All timestamped files have far future expiration headers to allow proxy caching.

Please note that, at this time, frontend and backend still keep publishing their own ports (7000, 7011).

## Stack

The stack consists of a few docker containers.

**Frontend:**

- Nginx
- Node
- NextJS / Svelte Kit
- React / Svelte
- Alpine Linux

**Backend:**

- Node
- Postgraphile

**Database:**

- Postgres
- Alpine Linux

### Frontend

The frontend is build in React + NextJS in order to make it easy to generate a
static website. The forms use Final Forms. All the communication with the
backend is done using GraphQL.

### Svelte

An alternative frontend with Svelte + SvelteKit. Page payload ridiculously small. The forms use Felte. All the communication with the backend in done using GraphQL.

### Backend

We use [Postgraphile][postgraphile] for the backend. Take a look at the [documentation](./backend/readme.md).

Postgraphile automatically generates the GraphQL schema for us by looking at the db schema.

The port 7011 exposes a [GraphQL Console](http://localhost:7011/graphiql).

Database migrations: in development mode, they are automatically run only the first time. In production mode, migrations are always run at start up.

[postgraphile]: https://github.com/graphile/postgraphile

### Database

The good old postgres.

### Security

While security is not the focus of this starter app, by default we mount the root filesystem as readonly and run the containers with an unprivileged user.

## Filesystem Layout

| Folder      |                                                                    |
| ----------- | ------------------------------------------------------------------ |
| `config/`   | use this directory to store your configs                           |
| `data/`     | the db data, and npm cache is saved here                           |
| `docker/`   | the docker-compose files for the various containers                |
| `frontend/` | the frontend application code                                      |
| `svelte/`   | alternative frontend based on Svelte Kit                           |
| `backend/`  | the backend application code                                       |
| `scripts/`  | the starting scripts (`dev`) and everything needed to make it work |

## Roadmap

Not a real roadmap, just a list of missing features I'd like to add.

### Backend

- use PM2 or any other tool to make use of all the CPU's.
- proper auth with custom `aud`
- find out how to handle uploads

### Frontend/Svelte

- image and static assets handling
- use urql to fetch from graphql
- persisted queries and typescript types

### Nginx

- read-only fs
- templating / docker-gen / env vars in the confs

## Caveats

1. While Postgraphile is incredibly cool, it may not be your piece of cake.
   Take a look to the `typeorm` branch to see how implement something more
   traditional (then do yourself a favor and use Prism instead).

1. While the GraphQL server validates pretty much everything, the email
   validation is currently performed on the client, while it would be better
   to also validate the mail on the server as well.

1. If you specify a custom `USER_ID` in development mode, you may have issues with next (see [#1](https://github.com/tacone/loki/issues/1))
