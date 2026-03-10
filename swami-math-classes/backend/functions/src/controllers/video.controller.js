const videoService = require("../services/video.service");
const { ok, fail } = require("../utils/responseFormatter");

async function getSignedUrl(req, res) {
  try {
    const data = await videoService.generateStreamUrl(req.params.videoId, req.user);
    return ok(res, data, "video_url_generated");
  } catch (err) {
    return fail(res, 501, err.message);
  }
}

module.exports = { getSignedUrl };
