import { runQueryWithErrorInstrumentation } from "graphile-migrate/dist/instrumentation.js";
import { withClient } from "graphile-migrate/dist/pgReal.js";

/**
 * Check whether migrations have been executed at least once.
 */

const connectionString = process.env.DATABASE_URL;

if (!connectionString) {
  throw new Error("Could not determine connection string to use.");
}

const sql = `
    SELECT schema_name
    FROM information_schema.schemata
    WHERE schema_name = 'graphile_migrate';
`;

const result = await withClient(connectionString, {}, (pgClient) =>
  runQueryWithErrorInstrumentation(pgClient, sql)
);

if (result.length) {
  console.log("Migrations already set up");
  process.exit(0);
} else {
  console.log("Migrations not yet set up");
  process.exit(1);
}
