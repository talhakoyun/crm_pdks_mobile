package com.example.pdks_mobile


import android.content.Context
import android.content.ContextWrapper
import android.content.Intent
import android.content.IntentFilter
import android.net.Uri
import android.os.BatteryManager
import android.os.Build.VERSION
import android.os.Build.VERSION_CODES
import android.provider.Settings

import androidx.annotation.NonNull
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity: FlutterActivity() {
  private val CHANNEL = "samples.mavihost/mockTime"

  override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
    super.configureFlutterEngine(flutterEngine)
    MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler {
        call, result ->
       if(call.method=="getMockStatus"){
            result.success(requestPermission())
        } else {
          result.notImplemented()
        }
      // Note: this method is invoked on the main thread.
      // TODO
    }
  }
  fun openAndroidPermissionsMenu() {
     val intent = Intent(Settings.ACTION_MANAGE_WRITE_SETTINGS)
     // val intent = ContextWrapper(applicationContext).registerReceiver(null, IntentFilter(Settings.ACTION_MANAGE_WRITE_SETTINGS))
      intent.data = Uri.parse("package:" + this.packageName)
      intent.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK);
      startActivity(intent)
  }

  fun requestPermission(): Boolean {
      var retVal = true
      var result: Boolean = false
      if (VERSION.SDK_INT >= VERSION_CODES.LOLLIPOP) {

          retVal = Settings.System.canWrite(this)
          if (retVal) {

              var data =
                  Settings.System.getString(this.contentResolver, Settings.System.AUTO_TIME)
              result = data.equals("0")


          } else {

              openAndroidPermissionsMenu()
          }
      } else {
          var data =
              Settings.System.getString(this.contentResolver, Settings.System.AUTO_TIME);
          result = data.equals("0")
      }
      if (result==false){
          var data =
              Settings.System.getString(this.contentResolver, Settings.System.AUTO_TIME)
          result = data.equals("0")
      }
      return result
  }
}