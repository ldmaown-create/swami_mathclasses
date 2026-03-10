const admin = require("firebase-admin");

let initialized = false;

function initializeFirebase() {
  if (!initialized) {
    // Placeholder initialization. Wire service account / runtime config per environment.
    admin.initializeApp();
    initialized = true;
  }
  return admin;
}

module.exports = { initializeFirebase };
