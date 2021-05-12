import { runQueryWithErrorInstrumentation } from "graphile-migrate/dist/instrumentation.js";
import { withClient } from "graphile-migrate/dist/pgReal.js";

/**
 * Check whether migrations have been executed at least once.
 */

const connectionString = process.env.DATABASE_URL;

if (!connectionString) {
  throw new Error("Could not determine connection string to use.");
}

const url = new URL(process.env.ROOT_DATABASE_URL);
const dbName = url.pathname.replace(/^\//, "");

const sql = `
    CREATE DATABASE ${dbName};
`;

try {
  const result = await withClient(connectionString, {}, (pgClient) =>
    runQueryWithErrorInstrumentation(pgClient, sql)
  );
} catch (error) {

  // it sucks, but the easiest and less patchy way to achieve IF EXISTS
  // functionality in postgres is to simply handle the error.
  //
  // | Error Code | Meaning             | Constant           |
  // |------------|---------------------|--------------------|
  // |      42P04 | DUPLICATE DATABASE  | duplicate_database |
  //
  // see also: https://www.postgresql.org/docs/8.2/errcodes-appendix.html

  if (error.code !== "42P04") {
    throw error;
  }
}
