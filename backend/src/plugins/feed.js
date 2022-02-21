import feedRead from "davefeedread";
import { gql, makeExtendSchemaPlugin } from "graphile-utils";
import { promisify } from "util";
import hostnameIsPrivate from "hostname-is-private";

// const urlTestFeed = "http://feeds.wnyc.org/radiolab";
// const urlTestFeed = "https://wordpress.com/blog/feed/";
// const urlTestFeed = "https://www.feedforall.com/sample.xml";
// const urlTestFeed = "https://news.ycombinator.com/rss";

const timeOutSecs = 30;

const isValidUrl = async (untrustedUrl, protocols = ["http", "https"]) => {
  try {
    // will throw error on malfomed url
    const url = new URL(untrustedUrl);

    // no protocol, no fun
    if (!url.protocol) return false;

    // make sure the protocol is allowed, no file://, ftp:// etc
    if (
      !protocols.filter(
        (p) => `${p.toLowerCase()}:` == url.protocol.toLowerCase()
      ).length
    ) {
      return false;
    }

    // here it gets interesting, we need to check if the hostname exists,
    // is reachable, and is not private. We need especially to be sure it
    // won't resolve to localhost :-))

    const notAllowed = await promisify(
      hostnameIsPrivate.isPrivateIncludingPublicIp
    )(url.hostname);
    if (notAllowed) {
      throw new Error(`Url "${url.hostname} is not allowed`);
    }
    return true;
  } catch (err) {
    console.error(err);
    return false;
  }
};

export const importFeed = makeExtendSchemaPlugin((build) => {
  return {
    typeDefs: gql`
      extend type Mutation {
        importFeed(url: String!): Feed!
      }
    `,

    resolvers: {
      Mutation: {
        importFeed: async (_query, { url }, context, resolveInfo) => {
          // check the url is a valid URL
          if (!(await isValidUrl(url))) {
            throw new Error("Invalid URL");
          }

          const startedAt = new Date();

          const parse = promisify(feedRead.parseUrl);
          const theFeed = await parse(url, timeOutSecs);
          console.log(
            `It took ${
              (new Date() - startedAt) / 1000
            } seconds to read and parse the feed.`
          );

          const client = context.pgClient;

          const { rows : [{id: feedId}]} = await client.query(
            `INSERT INTO "feeds" (url,name) VALUES ($1, $2)
            ON CONFLICT(url) DO UPDATE SET name=excluded.name
            RETURNING *`,
            [url, theFeed.head.title ?? ""]
          );
          console.log('feed_id:', feedId);

          const { rows : [{id: downloadId}]} = await client.query(
            `INSERT INTO "downloads" (feed_id, blob, content) VALUES ($1, $2, $3) RETURNING *`,
            [feedId, "", theFeed]
          );
          console.log('download_id:', downloadId);

          const result3 = await client.query(
            `SELECT * FROM import_items($1) LIMIT 1`,
            [downloadId]
          );

          const [row] = await resolveInfo.graphile.selectGraphQLResultFromTable(
            build.pgSql.fragment`feeds`,
            (tableAlias, queryBuilder) => {
              queryBuilder.where(
                build.pgSql.fragment`${tableAlias}.id = ${build.pgSql.value(feedId)}`
              );
            }
          );

          return row;
        },
      },
    },
  };
});
