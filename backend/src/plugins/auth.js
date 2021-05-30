import { gql, makeExtendSchemaPlugin } from "graphile-utils";
import { GraphQLJSONObject } from "graphql-type-json";
import fetch from "node-fetch";

/**
 * Wrap needed parts of GoTrue API
 */

const url = process.env.AUTH_URL;
const audience = "postgraphql";

const post = (endpoint, data) => {
  return fetch(`${url}/${endpoint}`, {
    method: "POST",
    headers: {
      "Content-Type": "application/json",
      "X-JWT-AUD": audience,
    },
    body: JSON.stringify(data),
  });
};

GraphQLJSONObject.name = "JSONObject";

const auth = makeExtendSchemaPlugin((build) => {
  return {
    typeDefs: gql`
      scalar JSONObject

      type PasswordGrant {
        email: String!
        password: String!
      }
      type RegistrationPayload {
        id: String!
        aud: String!
        role: String!
        email: String!
        confirmed_at: String!
        app_metadata: JSONObject!
        user_metadata: JSONObject!
        created_at: Date!
        updated_at: Date!
      }
      type AuthenticationToken {
        access_token: String!
        token_type: String!
        expires_in: Int!
        refresh_token: String!
      }

      extend type Mutation {
        registerUser(email: String!, password: String!): RegistrationPayload!
        authenticate(email: String!, password: String!): AuthenticationToken!
      }
    `,

    resolvers: {
      JSONObject: GraphQLJSONObject,
      Mutation: {
        authenticate: async (_query, args, context, resolveInfo) => {
          let query = `grant_type=password`;
          query += `&username=${escape(args.email)}`;
          query += `&password=${escape(args.password)}`;

          const response = await post(`token?${query}`, {
            email: "email@example.com",
            password: "secret",
          });

          const data = await response.json();

          if (!response.ok) {
            console.error(data);
            throw new Error(data?.msg || "Unknown error");
          }
          console.log(data);

          return data;
        },
        registerUser: async (_query, args, context, resolveInfo) => {
          const response = await post("signup", {
            email: args.email,
            password: args.password,
            aud: "postgraphql",
          });
          const data = await response.json();

          if (!response.ok) {
            console.error(data);
            throw new Error(data?.msg || "Unknown error");
          }
          console.log(data);

          return data;
        },
      },
    },
  };
});

export default auth;
