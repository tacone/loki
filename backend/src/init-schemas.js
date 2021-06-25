import { runQueryWithErrorInstrumentation } from "graphile-migrate/dist/instrumentation.js";
import { withClient } from "graphile-migrate/dist/pgReal.js";

/**
 * Check whether migrations have been executed at least once.
 */

const connectionString = process.env.ROOT_DATABASE_URL;

if (!connectionString) {
  throw new Error("Could not determine connection string to use.");
}

// const databases = ["postgres", "postgres_shadow"];
const schemas = ["app", "protected"];

// for (const db of databases) {

for (const s of schemas) {
  console.log(`initializing schema ${s}`);

  const sql = `
      create schema if not exists ${s};
    `;

  await withClient(connectionString, {}, (pgClient) =>
    runQueryWithErrorInstrumentation(pgClient, sql)
  );
}
// }
