const courseService = require("../services/course.service");
const { ok, fail } = require("../utils/responseFormatter");

async function list(req, res) {
  try {
    const data = await courseService.listCourses(req.query);
    return ok(res, data, "courses_fetched");
  } catch (err) {
    return fail(res, 501, err.message);
  }
}

module.exports = { list };
