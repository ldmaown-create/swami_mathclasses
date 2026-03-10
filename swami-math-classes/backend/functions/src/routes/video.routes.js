const express = require("express");
const controller = require("../controllers/video.controller");

const router = express.Router();

router.get("/:videoId/signed-url", controller.getSignedUrl);

module.exports = router;
