enum AuthenticationFailureReason {
  /// Too many failed attempts have been made, and the user cannot make another attempt for an
  /// unspecified amount of time.
  LOCKED_OUT,

  /// The user has not registered any fingerprints with the system.
  NO_FINGERPRINTS_REGISTERED,

  /// A fingerprint was read successfully, but that fingerprint was not registered on the device.
  AUTHENTICATION_FAILED,

  /// The sensor was unable to read the fingerprint, perhaps because the finger was moved too
  /// quickly, or the sensor was dirty.
  SENSOR_FAILED,

  /// The authentication failed for an unknown reason.
  OTHER
}
