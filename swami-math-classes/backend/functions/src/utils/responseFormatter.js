function ok(res, data = {}, message = "success") {
  return res.status(200).json({ success: true, message, data });
}

function created(res, data = {}, message = "created") {
  return res.status(201).json({ success: true, message, data });
}

function fail(res, status = 500, message = "internal_error", details = null) {
  return res.status(status).json({ success: false, message, details });
}

module.exports = { ok, created, fail };
