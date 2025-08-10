import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:crm_pdks_mobile/app.dart';
import 'package:crm_pdks_mobile/core/init/cache/locale_manager.dart';
import 'package:crm_pdks_mobile/core/translations/translation_manager.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize SharedPreferences first
  await LocaleManager.prefrencesInit();

  await Future.wait([EasyLocalization.ensureInitialized()]);
  HttpOverrides.global = MyHttpOverrides();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  await SentryFlutter.init(
    (options) {
      options
        ..dsn =
            "https://345e62a0b9b4ba4edcfd34cdf837f23f@o4509412197400576.ingest.us.sentry.io/4509412205330432"
        ..tracesSampleRate = 1.0
        ..environment = kDebugMode ? "development" : "production";
    },
    appRunner: () {
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
