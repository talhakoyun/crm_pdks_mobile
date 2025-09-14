import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import 'core/base/base_singleton.dart';
import 'core/init/theme/app_theme.dart';

class App extends StatelessWidget with BaseSingleton {
  const App({super.key});
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: appConstants.providers,
      child: ScreenUtilInit(
        designSize: const Size(375, 812), // iPhone X design size
        minTextAdapt: true,
        splitScreenMode: true,
        builder: (context, child) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            localizationsDelegates: context.localizationDelegates,
            supportedLocales: context.supportedLocales,
            locale: context.locale,
            title: strCons.appName,
            theme: AppTheme.lightTheme,
            darkTheme: AppTheme.darkTheme,
            themeMode: ThemeMode.system,
            onGenerateRoute: appConstants.navigatorRoute,
            navigatorKey: appConstants.navigatorKey,
          );
        },
      ),
    );
  }
}
