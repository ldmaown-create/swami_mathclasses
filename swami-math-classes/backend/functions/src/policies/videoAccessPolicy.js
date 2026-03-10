function canAccessVideo({ hasActiveSubscription, enrolledInCourse }) {
  return Boolean(hasActiveSubscription && enrolledInCourse);
}

module.exports = { canAccessVideo };
