const withPreact = require("next-plugin-preact");

module.exports = withPreact({
  /* regular next.js config options here */
  future: {
    webpack5: true, // needed until it becomes the default for everyone
  },
});
