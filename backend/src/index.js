import polka from "polka";
import { postgraphile } from "postgraphile";
import connectionFilterPlugin from "postgraphile-plugin-connection-filter";
import simplifyInflector from "@graphile-contrib/pg-simplify-inflector";

const options = {
  watchPg: true,
  graphiql: true,
  enhanceGraphiql: true,
  appendPlugins: [connectionFilterPlugin, simplifyInflector],
  simpleCollections: "only",
  graphileBuildOptions: { pgOmitListSuffix: true },
};

// here we use polka (see: https://github.com/lukeed/polka )

polka()
  .use(postgraphile(process.env.DATABASE_URL, "public", options))
  .listen(process.env.PORT ?? 3000, (err) => {
    if (err) throw err;
    console.log(`> Running on localhost:3000`);
  });

// --- This is the default approach of postgraphile, which is *slightly* faster
//
// const http = require("http");
// const { postgraphile } = require("postgraphile");
//
// http
//   .createServer(postgraphile(process.env.DATABASE_URL, "public", options))
//   .listen(process.env.PORT ?? 3000);
