const express = require("express");
const controller = require("../controllers/admin.controller");

const router = express.Router();

router.get("/dashboard", controller.dashboard);

module.exports = router;
