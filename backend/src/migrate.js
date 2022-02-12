import { highlight } from "cli-highlight";
import migrami from "migrami";

migrami({
  // database
  connectionString: process.env.DATABASE_URL,
  schema: "migrami",

  // goodies
  highlightSql: (sql) => {
    return highlight(sql, { language: "sql", ignoreIllegals: true });
  },
});
