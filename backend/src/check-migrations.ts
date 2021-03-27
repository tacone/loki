import "reflect-metadata";
import { createConnection, getManager } from "typeorm";

/**
 * This command checks if the migrations have been run at least once and
 * will return status
 * - 0  migrations have been run once
 * - 1  migrations have never run
 */

const ormConfig = require("../ormconfig").default; // typescript may fail if we use import

const migrationsTable: string =
  ormConfig["migrationsTableName"] ?? "migrations";

async function main() {
  await createConnection();

  const entityManager = getManager();
  const result = await entityManager.query(`SELECT to_regclass($1);`, [
    migrationsTable,
  ]);

  if (result[0].to_regclass) {
    console.log(`Migrations "${migrationsTable}" table exists.`)
    process.exit(0)
  }
console.log(`Migrations table "${migrationsTable}" does not exist.`)
process.exit(1)
}


main();
