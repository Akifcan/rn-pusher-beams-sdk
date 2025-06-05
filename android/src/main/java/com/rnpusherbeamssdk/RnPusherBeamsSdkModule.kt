package com.rnpusherbeamssdk

import com.facebook.react.module.annotations.ReactModule
import android.content.Context
import android.content.SharedPreferences
import com.facebook.react.bridge.ReactApplicationContext
import com.facebook.react.bridge.WritableArray
import com.facebook.react.bridge.Arguments
import com.pusher.pushnotifications.PushNotifications;
import com.pusher.pushnotifications.auth.BeamsTokenProvider
import com.pusher.pushnotifications.auth.AuthData
import com.pusher.pushnotifications.auth.AuthDataGetter
import com.pusher.pushnotifications.BeamsCallback
import com.pusher.pushnotifications.PusherCallbackError
import android.util.Log
import com.google.firebase.messaging.RemoteMessage;
import com.pusher.pushnotifications.fcm.MessagingService;

@ReactModule(name = RnPusherBeamsSdkModule.NAME)
class RnPusherBeamsSdkModule(reactContext: ReactApplicationContext) :
  NativeRnPusherBeamsSdkSpec(reactContext) {

  override fun getName(): String {
    return NAME
  }

  // Example method
  // See https://reactnative.dev/docs/native-modules-android
  override fun multiply(a: Double, b: Double): Double {
    return a * b
  }

  override fun start(instanceId: String): Boolean {
    PushNotifications.start(getReactApplicationContext(), instanceId);
    return true;
  }

  override fun registerForRemoteNotifications(): Boolean {
    return false;
  }

  override fun stop(): Boolean {
    PushNotifications.stop();
    return true;
  }

  override fun addDeviceInterest(interest: String): Boolean {
    PushNotifications.addDeviceInterest(interest);
    return true;
  }

  override fun clearDeviceInterests(): Boolean {
    PushNotifications.clearDeviceInterests();
    return true;
  }

  override fun clearAllState(): Boolean {
    PushNotifications.clearAllState();
    return true;
  }

  override fun getInterests(): WritableArray {
    val interests = PushNotifications.getDeviceInterests();
    val writableArray = Arguments.createArray()
    for (interest in interests) {
        writableArray.pushString(interest)
    }
    return writableArray  
  }

  override fun setUserId(userId: String, url: String, token: String): Boolean {
    val tokenProvider = BeamsTokenProvider(
      url,
      object : AuthDataGetter {
          override fun getAuthData(): AuthData {
              return AuthData(
                  headers = hashMapOf(
                      "Authorization" to "Bearer "+token
                  ),
                  queryParams = hashMapOf()
              )
          }
      }
  )

  PushNotifications.setUserId(
      userId,
      tokenProvider,
      object : BeamsCallback<Void, PusherCallbackError> {
          override fun onFailure(error: PusherCallbackError) {
              Log.e("BeamsAuth", "Could not login to Beams: ${error.message}")
          }

          override fun onSuccess(vararg values: Void) {
              Log.i("BeamsAuth", "Beams login success")
          }
      }
  )
    return true
  }


  companion object {
    const val NAME = "RnPusherBeamsSdk"
  }
}
