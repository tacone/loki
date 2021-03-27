export default {
  type: "postgres",
  url: process.env.DATABASE_URL,
  synchronize: false,
  entities: [__dirname + "/src/models/*.ts"],
  migrations: ["src/migrations/*.ts"],
  cli: {
    migrationsDir: "src/migrations",
  },
};
