import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CustomColorScheme {
  static CustomColorScheme? _instance;
  static CustomColorScheme? get instance {
    _instance ??= CustomColorScheme._init();
    return _instance;
  }

  // Her temada olması gerekenler.
  //-----------------------------------------------------------------------------
  final Brightness brightnessLight = Brightness.light;
  CustomColorScheme._init();
  final SystemUiOverlayStyle systemUiOverlayLight = SystemUiOverlayStyle.light;
  final Color whiteColor = const Color(0xFFFFFFFF);
  final Color blackColor = const Color(0xFF000000);
  final Color errorColor = const Color(0xFFAE2E22);
  final Color successColor = const Color(0xFF00C9A5);
  //-----------------------------------------------------------------------------
  //Proje'ye göre değişecekler.
  //xx kullanılmamışlar silinecekleri ifade eder
  final Color newPrimaryColor = const Color(0xFF005792); // Ana mavi renk
  final Color newonPrimaryColor = const Color(0xFF003d6b);
  final Color newSecondaryColor = const Color(0xffFFAE1A);
  final Color newOnSecondaryColor = const Color(0xffFF981A);
  final Color navbarFirstColor = const Color(0xffFF981A);
  final Color navbarSecondColor = const Color(0xFFADDCFF);
  final Color navbarThirdColor = const Color(0xff00BB86);
  final Color containerColor = const Color(0xff595457);
  final Color newPrimaryVariantColor = const Color(0xFF85CAFF);
  final Color cardColor = const Color(0xffE1E1E1);
  final Color notApprovedColor = const Color(0xff929292);
  final Color textColor = const Color(0xff7a7a7a);
  final Color backgroundPermission = const Color(0xfff2f2f2);
  final Color inputBorderColor = const Color(0xff545454);

  // AppBar gradient renkleri
  final Color appBarGradientStart = const Color(0xFF005792); // Ana renk
  final Color appBarGradientEnd = const Color(0xFF003d6b); // Koyu ton

  // Buton ve UI element renkleri
  final Color primaryButtonColor = const Color(0xFF005792);
  final Color secondaryButtonColor = const Color(
    0xFF0077B6,
  ); // Biraz daha açık ton

  final MaterialColor colorSwatch =
      const MaterialColor(0xFF005792, <int, Color>{
        50: Color(0xFFE3F2FD),
        100: Color(0xFFBBDEFB),
        200: Color(0xFF90CAF9),
        300: Color(0xFF64B5F6),
        400: Color(0xFF42A5F5),
        500: Color(0xFF005792),
        600: Color(0xFF004A7C),
        700: Color(0xFF003d6b),
        800: Color(0xFF003055),
        900: Color(0xFF002340),
      });

  Color determineColor(int index) {
    switch (index) {
      case 0:
        return notApprovedColor;
      case 1:
        return successColor;
      case 2:
        return errorColor;
      default:
        return newonPrimaryColor;
    }
  }
}
