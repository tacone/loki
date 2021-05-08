import simplifyInflector from "@graphile-contrib/pg-simplify-inflector";
import { makeWrapResolversPlugin } from "graphile-utils";
import polka from "polka";
import { postgraphile } from "postgraphile";
import connectionFilterPlugin from "postgraphile-plugin-connection-filter";

// --- example: log before and after each mutation runs
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
  exportGqlSchemaPath: './generated/schema.graphql',
  appendPlugins: [
    connectionFilterPlugin,
    simplifyInflector,
    // mutationWrapper
  ],
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
