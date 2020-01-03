import 'package:flutter_reprint/authentication_failure_reason.dart';

/// The result of a biometric authentication
class AuthenticationResult {
  /// Whether or not authentication was successful
  bool success;

  /// The [AuthenticationFailureReason], if the authentication didn't succeed.
  AuthenticationFailureReason failureReason;

  AuthenticationResult({this.success, this.failureReason});
}
