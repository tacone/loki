import utils from "daveutils";
import feedRead from "davefeedread";

const urlTestFeed = "http://feeds.wnyc.org/radiolab";
const timeOutSecs = 30;
const whenstart = new Date();

export function test(req, res) {
  feedRead.parseUrl(urlTestFeed, timeOutSecs, function (error, theFeed) {
    if (error) {
      console.log(error.message);
      res.sendStatus(500);
      res.setHeader("Content-Type", "application/json");
      res.end(JSON.stringify(error.message));
    } else {
      console.log(
        "It took " +
          utils.secondsSince(whenstart) +
          " seconds to read and parse the feed."
      );

      var item = theFeed.items[0];
      var rssguid = item["rss:guid"];
      console.log("rssguid == " + utils.jsonStringify(rssguid));

      console.log("theFeed.head == " + utils.jsonStringify(theFeed.head));
      console.log(
        "theFeed.items [0] == " + utils.jsonStringify(theFeed.items[0])
      );
      theFeed.items.forEach(function (item, i) {
        console.log(
          "Item #" + utils.padWithZeros(i, 2) + ": " + item.title + "."
        );
      });

      //   fs.writeFile("feed.xml", utils.jsonStringify(theFeed), function (err) {});
      res.setHeader("Content-Type", "application/json");
      res.end(JSON.stringify(theFeed));
    }
  });


}
