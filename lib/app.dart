import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'core/base/base_singleton.dart';
import 'core/init/size/size_widget.dart';
import 'core/init/theme/theme.dart';

class App extends StatelessWidget with BaseSingleton {
  const App({super.key});
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: appConstants.providers,
      child: Sizer(
        builder: (context, orientation, deviceType) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            localizationsDelegates: context.localizationDelegates,
            supportedLocales: context.supportedLocales,
            locale: context.locale,
            title: strCons.appName,
            theme: AppTheme.instance.themeApp,
            onGenerateRoute: appConstants.navigatorRoute,
            navigatorKey: appConstants.navigatorKey,
          );
        },
      ),
    );
  }
}
