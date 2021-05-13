import simplifyInflector from "@graphile-contrib/pg-simplify-inflector";
import { postgraphile } from "postgraphile";
import connectionFilterPlugin from "postgraphile-plugin-connection-filter";

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

// --- example: log before and after each mutation runs
//
// import { makeWrapResolversPlugin } from "graphile-utils";
//
// const mutationWrapper = makeWrapResolversPlugin(
//   (context) => {
//     if (context.scope.isRootMutation) {
//       return { scope: context.scope };
//     }
//     return null;
//   },
//   ({ scope }) => async (resolver, user, args, context, _resolveInfo) => {
//     console.log(`Mutation '${scope.fieldName}' starting with arguments:`, args);
//     const result = await resolver();
//     console.log(`Mutation '${scope.fieldName}' result:`, result);
//     return result;
//   }
// );

const options = {
  watchPg: true,
  graphiql: true,
  enhanceGraphiql: true,
  exportGqlSchemaPath: "./generated/schema.graphql",
  appendPlugins: [
    connectionFilterPlugin,
    simplifyInflector,
    // mutationWrapper
  ],
  simpleCollections: "only",
  graphileBuildOptions: { pgOmitListSuffix: true },
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
//
// import polka from "polka";
//
// polka()
//   .use(allowCors)
//   .use(postgraphile(process.env.DATABASE_URL, "public", options))
//   .listen(process.env.PORT ?? 3000, (err) => {
//     if (err) throw err;
//     console.log(`> Running on localhost:3000`);
//   });
//
// ---------------------------------------------------------
// --- Node native HTTP Server
// ---------------------------------------------------------

import http from "http";

const handler = postgraphile(process.env.DATABASE_URL, "public", options);

http
  .createServer((req, res) => {
    allowCors(req, res, () => handler(req, res));
  })
  .listen(process.env.PORT ?? 3000);
