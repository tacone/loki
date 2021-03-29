export default {
  type: "postgres",
  url: process.env.DATABASE_URL,
  synchronize: false,
  entities: [
    __dirname + "/src/models/*.ts",
    // for some reason even in production __dirname
    // is `/app` and not `/app/dist`
    __dirname + "/dist/src/models/*.js",
  ],
  migrations: ["src/migrations/*.ts"],
  cli: {
    migrationsDir: "src/migrations",
  },
};
