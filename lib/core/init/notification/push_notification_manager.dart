import 'package:flutter/foundation.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';

class PushNotificationManager {
  static Future<void> initializePushNotification() async {
    final String deviceLang = PlatformDispatcher.instance.locale.languageCode;

    OneSignal.Debug.setLogLevel(OSLogLevel.verbose);
    OneSignal.Debug.setAlertLevel(OSLogLevel.none);
    OneSignal.initialize("123123123-123-123-132-12312312312");

    OneSignal.User.setLanguage(deviceLang);
    OneSignal.Notifications.requestPermission(true);
  }

  static Future<void> pushService({
    required int id,
    Map<String, String>? tags,
  }) async {
    try {
      OneSignal.login(id.toString());
      OneSignal.User.addTags(tags ?? {});
    } catch (e) {
      debugPrint("***************OneSignal exeption:****************\n $e");
    }
  }
}
