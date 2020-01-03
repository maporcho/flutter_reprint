import 'dart:async';

import 'package:flutter/services.dart';
import 'package:flutter_reprint/authentication_failure_reason.dart';
import 'package:flutter_reprint/authentication_result.dart';

const MethodChannel _channel = MethodChannel('flutter_reprint');

class FlutterReprint {
  /// Starts biometrics authentication.
  ///
  /// Returns the [AuthenticationResult]
  @override
  static Future<AuthenticationResult> authenticateWithBiometrics() async {
    try {
      bool result =
          await _channel.invokeMethod<bool>('authenticateWithBiometrics', null);
      return Future.value(AuthenticationResult(success: result));
    } on PlatformException catch (e) {
      await stopAuthentication();

      AuthenticationFailureReason failureReason;
      switch (e.code) {
        case "locked_out":
          failureReason = AuthenticationFailureReason.LOCKED_OUT;
          break;
        case "no_fingerprints_registered":
          failureReason =
              AuthenticationFailureReason.NO_FINGERPRINTS_REGISTERED;
          break;
        case "authentication_failed":
          failureReason = AuthenticationFailureReason.AUTHENTICATION_FAILED;
          break;
        case "sensor_failed":
          failureReason = AuthenticationFailureReason.SENSOR_FAILED;
          break;
        default:
          failureReason = AuthenticationFailureReason.OTHER;
          break;
      }
      return Future.value(
          AuthenticationResult(success: false, failureReason: failureReason));
    }
  }

  /// Stops biometrics authentication.
  ///
  /// Returns true if the authentication was stopped successfully, false otherwise.
  ///
  @override
  static Future<bool> stopAuthentication() async {
    return await _channel.invokeMethod<bool>('cancelAuthentication');
  }

  /// Checks if the device supports fingerprint authentication.
  ///
  /// Returns true if the device supports fingerprint authentication, false if it doesn't.
  @override
  static Future<bool> get canCheckFingerprint async =>
      (await _channel.invokeMethod<bool>('isFingerprintHardwareAvailable'));

  static Future<String> get platformVersion async {
    final String version = await _channel.invokeMethod('getPlatformVersion');
    return version;
  }
}
