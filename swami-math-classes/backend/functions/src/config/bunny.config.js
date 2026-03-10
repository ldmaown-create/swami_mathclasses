const env = require("./env.config");

module.exports = {
  libraryId: env.bunnyLibraryId,
  apiKey: env.bunnyApiKey,
  pullZoneUrl: env.bunnyPullZoneUrl,
  signedUrlTtlSeconds: 300
};
