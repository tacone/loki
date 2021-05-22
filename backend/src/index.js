import simplifyInflector from "@graphile-contrib/pg-simplify-inflector";
import { postgraphile } from "postgraphile";
import connectionFilterPlugin from "postgraphile-plugin-connection-filter";
import { isListType } from "graphql";
import {NodePlugin} from "graphile-build";

function allowCors(req, res, next) {
  res.setHeader("Access-Control-Allow-Origin", "*");
  res.setHeader("Access-Control-Allow-Headers", "*");
  // chr
  res.setHeader("Access-Control-Max-Age", 86400);

  if (req.method === "OPTIONS") {
    res.writeHead(200);
    res.end();
    return;
  }
  next && next();
}

import { makeWrapResolversPlugin } from "graphile-utils";

// Convert every null list to an empty list (`[]`)
const nullListsToEmptyLists = makeWrapResolversPlugin(
  (context) => {
    return { scope: context.scope };
  },
  ({ scope }) =>
    async (resolver, user, args, context, _resolveInfo) => {
      const result = await resolver();
      if (result === null && isListType(_resolveInfo.returnType)) {
        return [];
      }

      return result;
    }
);

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
  ],
  simpleCollections: "only",
  graphileBuildOptions: { pgOmitListSuffix: true },
  skipPlugins: [NodePlugin],
  jwtSecret: process.env.JWT_SECRET,
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

import http from "http";

const handler = postgraphile(process.env.DATABASE_URL, "forum_example", options);

http
  .createServer((req, res) => {
    allowCors(req, res, () => handler(req, res));
  })
  .listen(process.env.PORT ?? 3000);
