package br.com.marcoporcho.flutter_reprint

import android.os.Build
import androidx.annotation.NonNull
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result
import io.flutter.plugin.common.PluginRegistry.Registrar
import com.github.ajalt.reprint.core.AuthenticationFailureReason
import com.github.ajalt.reprint.core.AuthenticationListener
import com.github.ajalt.reprint.core.Reprint
import java.util.ArrayList
import java.util.concurrent.atomic.AtomicBoolean

/** FlutterReprintPlugin */
class FlutterReprintPlugin: FlutterPlugin, MethodCallHandler {
  override fun onAttachedToEngine(@NonNull flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
    val channel = MethodChannel(flutterPluginBinding.getFlutterEngine().getDartExecutor(), "flutter_reprint")
    channel.setMethodCallHandler(FlutterReprintPlugin());
  }

  companion object {
    @JvmStatic
    fun registerWith(registrar: Registrar) {
      val channel = MethodChannel(registrar.messenger(), "flutter_reprint")
      channel.setMethodCallHandler(FlutterReprintPlugin())
      Reprint.initialize(registrar.activity())
    }
  }

  override fun onMethodCall(@NonNull call: MethodCall, @NonNull result: Result) {
    when(call.method) {
      "cancelAuthentication" -> {
        if (AuthenticationInProgress.compareAndSet(true, false)) {
          try {
            Reprint.cancelAuthentication()
            result.success(true)
            return
          } catch (e: Exception) {
            result.error("error_in_cancel_authentication", "Error while canceling authentication", null)
          }
        } else {
          result.success(false)
        }

      }
      "authenticateWithBiometrics" -> {
        if (!AuthenticationInProgress.compareAndSet(false, true)) {
          // Apps should not invoke another authentication request while one is in progress,
          // so we classify this as an error condition. If we ever find a legitimate use case for
          // this, we can try to cancel the ongoing auth and start a new one but for now, not worth
          // the complexity.
          result.error("auth_in_progress", "Authentication in progress", null)
          return
        }

        Reprint.authenticate(object : AuthenticationListener {
          override fun onSuccess(moduleTag: Int) {
            if (AuthenticationInProgress.compareAndSet(true, false)) {
              result.success(true)
            }
          }

          override fun onFailure(failureReason: AuthenticationFailureReason?, fatal: Boolean,
                                 errorMessage: CharSequence?, moduleTag: Int, errorCode: Int) {
            if (AuthenticationInProgress.compareAndSet(true, false)) {
              returnError(failureReason, errorMessage, result)
            }
          }
        })
      }
      "isFingerprintHardwareAvailable" -> {

        try {
          if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M && Reprint.isHardwarePresent()) {

            result.success(true)

          } else {

            result.success(false)

          }

        } catch (e: Exception) {
          result.error("fingerprint_hardware_verification_failed", "Could not check if the fingerprint hardware is available.", null)
        }
      }
      "getPlatformVersion" -> {
        result.success("1.0.0")
      }
    }
  }

  override fun onDetachedFromEngine(@NonNull binding: FlutterPlugin.FlutterPluginBinding) {
  }

  private fun returnError(failureReason: AuthenticationFailureReason?,
                          errorMessage: CharSequence?, result: MethodChannel.Result) {

    if (failureReason === AuthenticationFailureReason.LOCKED_OUT) {
      result.error("locked_out", errorMessage.toString(), null)
      return
    } else if (failureReason === AuthenticationFailureReason.NO_FINGERPRINTS_REGISTERED) {
      result.error("no_fingerprints_registered", errorMessage.toString(), null)
      return
    } else if (failureReason === AuthenticationFailureReason.AUTHENTICATION_FAILED) {
      result.error("authentication_failed", errorMessage.toString(), null)
      return
    } else if (failureReason === AuthenticationFailureReason.SENSOR_FAILED) {
      result.error("sensor_failed", errorMessage.toString(), null)
      return
    }

    result.error("unknown_error", errorMessage.toString(), null)

  }
}

object AuthenticationInProgress {
  private val authInProgress = AtomicBoolean(false)

  fun compareAndSet(expect: Boolean, update: Boolean): Boolean {
    return authInProgress.compareAndSet(expect, update)
  }

}
