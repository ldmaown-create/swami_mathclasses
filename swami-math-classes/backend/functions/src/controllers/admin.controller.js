const adminService = require("../services/admin.service");
const { ok, fail } = require("../utils/responseFormatter");

async function dashboard(req, res) {
  try {
    const data = await adminService.getDashboardMetrics(req.query);
    return ok(res, data, "admin_dashboard");
  } catch (err) {
    return fail(res, 501, err.message);
  }
}

module.exports = { dashboard };
