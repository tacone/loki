import simplifyInflector from "@graphile-contrib/pg-simplify-inflector";
import { NodePlugin } from "graphile-build";
import http from "http";
import { postgraphile } from "postgraphile";
import connectionFilterPlugin from "postgraphile-plugin-connection-filter";
import { allowCors } from "./middleware/cors.js";
import { ping } from "./plugins/ping.js";
import { nullListsToEmptyLists } from "./plugins/tweaks.js";

const isProduction = process.env.NODE_ENV == "production";

const options = {
  watchPg: !isProduction,
  graphiql: !isProduction,
  enhanceGraphiql: !isProduction,
  disableQueryLog: isProduction,
  exportGqlSchemaPath: !isProduction && "./generated/schema.graphql",
  appendPlugins: [
    connectionFilterPlugin,
    simplifyInflector,
    nullListsToEmptyLists,
    ping,
  ],
  simpleCollections: "only",
  graphileBuildOptions: { pgOmitListSuffix: true },
  skipPlugins: [NodePlugin],
};

// ====================== HTTP Server ======================
//
// Uncomment whatever option fits you best.
//
// - Node native HTTP Server is slightly faster
// - PolkaJs allows for routing and middleware
//
// ---------------------------------------------------------
// --- Polka (see: https://github.com/lukeed/polka )
// ---------------------------------------------------------

// import polka from "polka";
//
// polka()
//   .use(allowCors)
//   .use(postgraphile(process.env.DATABASE_URL, "public", options))
//   .listen(process.env.PORT ?? 3000, (err) => {
//     if (err) throw err;
//     console.log(`> Running on localhost:3000`);
//   });

// ---------------------------------------------------------
// --- Node native HTTP Server
// ---------------------------------------------------------

const handler = postgraphile(process.env.DATABASE_URL, "public", options);

http
  .createServer((req, res) => {
    allowCors(req, res, () => handler(req, res));
  })
  .listen(process.env.PORT ?? 3000);
