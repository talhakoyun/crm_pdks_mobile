import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

import 'app.dart';
import 'core/constants/device_constants.dart';
import 'core/constants/service_locator.dart';
import 'core/init/cache/locale_manager.dart';
import 'core/translations/translation_manager.dart';

void main() async {
  await SentryFlutter.init(
    (options) {
      options
        ..dsn =
            "https://7a919953b09362912e341a6ee90d5257@o4509829783683072.ingest.de.sentry.io/4509829786959952"
        ..sendDefaultPii = true
        ..tracesSampleRate = 1.0
        ..environment = kDebugMode ? "development" : "production";
    },
    appRunner: () async {
      ServiceLocator.instance.registerCoreServices();
      await ServiceLocator.instance.get<DeviceInfoManager>().initialize();
      await LocaleManager.prefrencesInit();
      await Future.wait([EasyLocalization.ensureInitialized()]);
      HttpOverrides.global = MyHttpOverrides();
      SystemChrome.setPreferredOrientations([
        DeviceOrientation.portraitUp,
        DeviceOrientation.portraitDown,
      ]);
      runApp(TranslationManager(child: const App()));
    },
  );
}

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}
