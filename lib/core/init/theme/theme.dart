// ignore_for_file: todo
import 'package:flutter/material.dart';

import 'theme_app.dart';
import 'theme_interface.dart';

class AppTheme extends ApplicationTheme with ThemeInterface {
  static AppTheme? _instance;
  static AppTheme get instance {
    _instance ??= AppTheme._init();
    return _instance!;
  }

  AppTheme._init();
  @override
  ThemeData get themeApp => ThemeData(
    useMaterial3: true,
    fontFamily: 'Poppins',
    scaffoldBackgroundColor: customColorScheme!.backgroundPermission,
    primarySwatch: customColorScheme!.colorSwatch,
    colorScheme: _appColorScheme,
    textTheme: _textTheme,
    primaryTextTheme: _primaryTextTheme,
    appBarTheme: _appBarTheme,
    elevatedButtonTheme: elevatedButtonTheme,
    inputDecorationTheme: inputTheme,
  );

  ColorScheme get _appColorScheme => ColorScheme(
    brightness: customColorScheme!.brightnessLight,
    primary: customColorScheme!.newPrimaryColor,
    onPrimary: customColorScheme!.newonPrimaryColor,
    primaryContainer: customColorScheme!.navbarFirstColor,
    onPrimaryContainer: customColorScheme!.newPrimaryVariantColor,
    secondary: customColorScheme!.newSecondaryColor,
    onSecondary: customColorScheme!.newOnSecondaryColor,
    secondaryContainer: customColorScheme!.navbarSecondColor,
    tertiary: customColorScheme!.containerColor,
    tertiaryContainer: customColorScheme!.navbarThirdColor,
    surface: customColorScheme!.inputBorderColor,
    onSurface: customColorScheme!.newPrimaryColor,
    error: customColorScheme!.errorColor,
    onError: customColorScheme!.whiteColor,
    errorContainer: customColorScheme!.blackColor,
    onTertiaryContainer: customColorScheme!.backgroundPermission,
    //onBackground: customColorScheme!.notApprovedColor,
    onTertiary: customColorScheme!.textColor,
    onSurfaceVariant: customColorScheme!.cardColor,
  );

  TextTheme get _textTheme => TextTheme(
    headlineSmall: customBlackTextTheme!.headlineSmall,
    headlineMedium: customBlackTextTheme!.headlineMedium,
    headlineLarge: customBlackTextTheme!.headlineLarge,
    bodySmall: customBlackTextTheme!.bodySmall,
    bodyMedium: customBlackTextTheme!.bodyMedium,
    bodyLarge: customBlackTextTheme!.bodyLarge,
    titleSmall: customBlackTextTheme!.titleSmall,
    titleMedium: customBlackTextTheme!.titleMedium,
    titleLarge: customBlackTextTheme!.titleLarge,
  );

  TextTheme get _primaryTextTheme => TextTheme(
    headlineSmall: customWhiteTextTheme!.headlineSmall,
    headlineMedium: customWhiteTextTheme!.headlineMedium,
    headlineLarge: customWhiteTextTheme!.headlineLarge,
    bodySmall: customWhiteTextTheme!.bodySmall,
    bodyMedium: customWhiteTextTheme!.bodyMedium,
    bodyLarge: customWhiteTextTheme!.bodyLarge,
    titleSmall: customWhiteTextTheme!.titleSmall,
    titleMedium: customWhiteTextTheme!.titleMedium,
    titleLarge: customWhiteTextTheme!.titleLarge,
  );

  AppBarTheme get _appBarTheme => AppBarTheme(
    color: customColorScheme!.newPrimaryColor,
    titleTextStyle: _primaryTextTheme.titleMedium,
    elevation: 0,
    centerTitle: true,
    toolbarTextStyle: customWhiteTextTheme!.headlineMedium,
    iconTheme: IconThemeData(color: customColorScheme!.whiteColor),
  );

  ElevatedButtonThemeData get elevatedButtonTheme => ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: customColorScheme!.newPrimaryColor,
      // shadowColor: customColorScheme!.whiteColor,
      alignment: Alignment.center,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
    ),
  );

  InputDecorationTheme get inputTheme => InputDecorationTheme(
    labelStyle: _textTheme.bodyMedium!.copyWith(
      color: customColorScheme!.inputBorderColor,
      fontWeight: FontWeight.w300,
    ),
    contentPadding: const EdgeInsets.symmetric(vertical: 15),
    hintStyle: _textTheme.bodySmall!.copyWith(
      color: customColorScheme!.inputBorderColor,
      fontWeight: FontWeight.w300,
    ),
    focusedBorder: InputBorder.none,
    border: InputBorder.none,
    filled: false,
    enabledBorder: InputBorder.none,
  );
}
