import { gql, makeExtendSchemaPlugin } from "graphile-utils";

/**
 * Simplest example on how to extend the GraphQL schema
 *
 * Also useful as a health-check endpoint.
 */

export const ping = makeExtendSchemaPlugin((build) => {
  return {
    typeDefs: gql`
      extend type Query {
        ping: String!
      }
      extend type Mutation {
        pong: String!
      }
    `,

    resolvers: {
      Query: {
        ping: async (_query, args, context, resolveInfo) => {
          return "pong";
        },
      },
      Mutation: {
        pong: async (_query, args, context, resolveInfo) => {
          return "ping";
        },
      },
    },
  };
});
