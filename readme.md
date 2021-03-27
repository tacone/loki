# Survey

A sample survey system.

## Installation

Clone the project, then run:

```shell
scripts/dev run
```

When everything is up (it will take some time for the first run) these ports
will be exposed on your localhost:

- frontend: [7000](http://localhost:7000)
- backend: [7001](http://localhost:7001)
- postgres: 7010

To connect with postgres use:

- user: `postgres`
- password: `postgrespassword`
- host: `localhost`
- port: `7010`

The `scripts/dev` script wraps `docker-compose` so you can use it in the same
way (i.e. `scripts/dev build`, `scripts/dev down`, `scripts/dev ps`).

There is an additional command, `scripts/dev ports` that shows the configured ports.

The database files will be written in `data/`, so you can start from scratch by deleting `data/` along with `frontend/node_modules` and `backend/node_modules`.

## Stack

The stack consists of a few docker containers.

**Frontend:**

- Node
- NextJS
- React
- Alpine Linux

**Backend:**

- Node
- Typescript
- Apollo Server
- TypeORM + TypeGraphQL

**Database:**

- Postgres
- Alpine Linux

### Frontend

The frontend is build in React + NextJS in order to make it easy to generate a
static website. The forms use Final Forms. All the communication with the
backend is done using GraphQL.

### Backend

The backend is an Apollo Server instance. We use TypeORM for the DB and
TypeGraphQL to reduce the boilerplate.

At the first-run, db migrations are automatically run.

The port 7001 exposes a [GraphQL Console](http://localhost:7001).

### Database

The good old postgres.

## Filesystem Layout

- `data/` : the db data, and npm cache is saved here
- `docker/` : the docker-compose files for the various containers
- `frontend/` : the frontend application code
- `backend/` : the backend application code
- `scripts/` : the starting scripts (`dev`) and everything needed to make it work

## Caveats

TypeORM is very nice but some parts of it are prone to SQL Injection so
additional care is needed.

There is no production environment.

The referrer URL is read at the first landing on the /quiz page. After
that is stored in a query variable. This makes it more solid than using
the referrer directly, but makes the URL prone to manual editing.

While the GraphQL server validates pretty much everything, the email
validation is currently performed on the client, while it would be better to also validate the mail on the server as well.
