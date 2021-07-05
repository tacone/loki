# Backend

Sample GraphQL backend.

This backend is very fast and can return simple results with 1-3 ms of latency.

## Stack

- NodeJs 🚀
- [Polka](https://github.com/lukeed/polka) (optional)
- [Postgraphile](https://github.com/graphile/postgraphile/)
- [Graphile Migrate](https://github.com/graphile/migrate)

## Features

- [x]  Simple queries
- [x]  Working migrations
- [ ]  Simple mutations

At the moment the default CRUD mutations of Postgraphile are in use. I'd much
prefer to use mutations with a simpler signature, but it turns out not to be that
easy.

## Usage

I encorage you to read the docs of the various componebnts of the stack.
### Migrations

Under the hood we use **Graphile Migrate**, you can access its features running
`scripts/dev run backend yarn migrations`.

The first development run will execute all the migrations. From then, executing
migrations is up to you using `scripts/dev run backend yarn migrations migrate`.

In production migrations are always run.

When in development you can watch migrations file with
`scripts/dev run backend yarn migrations watch`.

Make sure you read the docs: https://github.com/graphile/migrate

### GraphQL

The GraphQL engine uses **Postgraphile**.

Make sure you read the docs: https://github.com/graphile/postgraphile/
