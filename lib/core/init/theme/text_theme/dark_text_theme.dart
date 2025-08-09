import 'package:flutter/material.dart';

import '../color_scheme.dart';

class CustomBlackTextTheme {
  static CustomBlackTextTheme? _instance;
  static CustomBlackTextTheme? get instance {
    _instance ??= CustomBlackTextTheme._init();
    return _instance;
  }

  CustomBlackTextTheme._init();
  final TextStyle headlineLarge = TextStyle(
    color: CustomColorScheme.instance!.inputBorderColor,
    fontFamily: 'Poppins',
    fontSize: 24,
  );
  final TextStyle headlineMedium = TextStyle(
    color: CustomColorScheme.instance!.inputBorderColor,
    fontFamily: 'Poppins',
    fontSize: 20,
  );
  final TextStyle headlineSmall = TextStyle(
    color: CustomColorScheme.instance!.inputBorderColor,
    fontFamily: 'Poppins',
    fontSize: 16,
  );
  final TextStyle bodyLarge = TextStyle(
    color: CustomColorScheme.instance!.inputBorderColor,
    fontFamily: 'Poppins',
    fontSize: 14,
  );
  final TextStyle bodyMedium = TextStyle(
    color: CustomColorScheme.instance!.inputBorderColor,
    fontFamily: 'Poppins',
    fontSize: 12,
  );
  final TextStyle bodySmall = TextStyle(
    color: CustomColorScheme.instance!.inputBorderColor,
    fontFamily: 'Poppins',
    fontSize: 10,
  );
  final TextStyle titleLarge = TextStyle(
    color: CustomColorScheme.instance!.inputBorderColor,
    fontFamily: 'Poppins',
    fontSize: 14,
  );
  final TextStyle titleMedium = TextStyle(
    color: CustomColorScheme.instance!.inputBorderColor,
    fontFamily: 'Poppins',
    fontSize: 12,
  );
  final TextStyle titleSmall = TextStyle(
    color: CustomColorScheme.instance!.inputBorderColor,
    fontFamily: 'Poppins',
    fontSize: 10,
  );
}
