import 'package:flutter/material.dart';
import 'app_constants.dart';

/// AppTheme provides light and dark theme configurations with Material 3 support
/// Generated with Flutter Theme Generator - Clean, modular, and maintainable
/// 
/// Features:
/// ✅ Uses AppConstants for consistent design tokens
/// ✅ Modular structure with separate theme components
/// ✅ Material 3 compliant color schemes
/// ✅ Support for 6 contrast modes (light, dark, medium/high contrast variants)
/// ✅ Production-ready with proper type declarations
class AppTheme {
  AppTheme._(); // Private constructor to prevent instantiation

  // ═══════════════════════════════════════════════════════════════════════════════
  // 🎨 PUBLIC THEME GETTERS
  // ═══════════════════════════════════════════════════════════════════════════════

  /// Light theme configuration
  static ThemeData get lightTheme => theme(lightScheme());

  /// Dark theme configuration
  static ThemeData get darkTheme => theme(darkScheme());

  /// Light medium contrast theme
  static ThemeData get lightMediumContrast => theme(lightMediumContrastScheme());

  /// Light high contrast theme
  static ThemeData get lightHighContrast => theme(lightHighContrastScheme());

  /// Dark medium contrast theme
  static ThemeData get darkMediumContrast => theme(darkMediumContrastScheme());

  /// Dark high contrast theme
  static ThemeData get darkHighContrast => theme(darkHighContrastScheme());

  // ═══════════════════════════════════════════════════════════════════════════════
  // 🌈 COLOR SCHEMES - Material 3 compliant
  // ═══════════════════════════════════════════════════════════════════════════════

  /// Light color scheme
  static ColorScheme lightScheme() {
    return const ColorScheme(
      brightness: Brightness.light,
      primary: Color(0xFF1e3a8a),
      surfaceTint: Color(0xFF1e3a8a),
      onPrimary: Color(0xFFFFFFFF),
      primaryContainer: Color(0xFF6e8ada),
      onPrimaryContainer: Color(0xFF001262),
      secondary: Color(0xFF3b82f6),
      onSecondary: Color(0xFFFFFFFF),
      secondaryContainer: Color(0xFF8bd2ff),
      onSecondaryContainer: Color(0xFF135ace),
      tertiary: Color(0xFFf97316),
      onTertiary: Color(0xFF000000),
      tertiaryContainer: Color(0xFFffc366),
      onTertiaryContainer: Color(0xFFd14b00),
      error: Color(0xFFBA1A1A),
      onError: Color(0xFFFFFFFF),
      errorContainer: Color(0xFFFFDAD6),
      onErrorContainer: Color(0xFF93000A),
      surface: Color(0xFFFFFBFE),
      onSurface: Color(0xFF1C1B1F),
      onSurfaceVariant: Color(0xFF49454F),
      outline: Color(0xFF79747E),
      outlineVariant: Color(0xFFCAC4D0),
      shadow: Color(0xFF000000),
      scrim: Color(0xFF000000),
      inverseSurface: Color(0xFF313033),
      onInverseSurface: Color(0xFFF4EFF4),
      inversePrimary: Color(0xFF0a2676),
      primaryFixed: Color(0xFF6e8ada),
      onPrimaryFixed: Color(0xFF00004e),
      primaryFixedDim: Color(0xFF5a76c6),
      onPrimaryFixedVariant: Color(0xFF0a2676),
      secondaryFixed: Color(0xFF8bd2ff),
      onSecondaryFixed: Color(0xFF0046ba),
      secondaryFixedDim: Color(0xFF77beff),
      onSecondaryFixedVariant: Color(0xFF276ee2),
      tertiaryFixed: Color(0xFFffc366),
      onTertiaryFixed: Color(0xFFbd3700),
      tertiaryFixedDim: Color(0xFFffaf52),
      onTertiaryFixedVariant: Color(0xFFe55f02),
      surfaceDim: Color(0xFFE6E0E9),
      surfaceBright: Color(0xFFFFFBFE),
      surfaceContainerLowest: Color(0xFFFFFFFF),
      surfaceContainerLow: Color(0xFFF7F2FA),
      surfaceContainer: Color(0xFFF3EDF7),
      surfaceContainerHigh: Color(0xFFECE6F0),
      surfaceContainerHighest: Color(0xFFE6E0E9),
    );
  }

  /// Dark color scheme
  static ColorScheme darkScheme() {
    return const ColorScheme(
      brightness: Brightness.dark,
      primary: Color(0xFF0a2676),
      surfaceTint: Color(0xFF0a2676),
      onPrimary: Color(0xFF00003a),
      primaryContainer: Color(0xFF00004e),
      onPrimaryContainer: Color(0xFF6e8ada),
      secondary: Color(0xFF276ee2),
      onSecondary: Color(0xFF0032a6),
      secondaryContainer: Color(0xFF0046ba),
      onSecondaryContainer: Color(0xFF8bd2ff),
      tertiary: Color(0xFFe55f02),
      onTertiary: Color(0xFFa92300),
      tertiaryContainer: Color(0xFFbd3700),
      onTertiaryContainer: Color(0xFFffc366),
      error: Color(0xFFFFB4AB),
      onError: Color(0xFF690005),
      errorContainer: Color(0xFF93000A),
      onErrorContainer: Color(0xFFFFDAD6),
      surface: Color(0xFF10090D),
      onSurface: Color(0xFFE6E0E9),
      onSurfaceVariant: Color(0xFFCAC4D0),
      outline: Color(0xFF938F99),
      outlineVariant: Color(0xFF49454F),
      shadow: Color(0xFF000000),
      scrim: Color(0xFF000000),
      inverseSurface: Color(0xFFE6E0E9),
      onInverseSurface: Color(0xFF313033),
      inversePrimary: Color(0xFF1e3a8a),
      primaryFixed: Color(0xFF6e8ada),
      onPrimaryFixed: Color(0xFF00004e),
      primaryFixedDim: Color(0xFF5a76c6),
      onPrimaryFixedVariant: Color(0xFF0a2676),
      secondaryFixed: Color(0xFF8bd2ff),
      onSecondaryFixed: Color(0xFF0046ba),
      secondaryFixedDim: Color(0xFF77beff),
      onSecondaryFixedVariant: Color(0xFF276ee2),
      tertiaryFixed: Color(0xFFffc366),
      onTertiaryFixed: Color(0xFFbd3700),
      tertiaryFixedDim: Color(0xFFffaf52),
      onTertiaryFixedVariant: Color(0xFFe55f02),
      surfaceDim: Color(0xFF10090D),
      surfaceBright: Color(0xFF362F33),
      surfaceContainerLowest: Color(0xff000000),
      surfaceContainerLow: Color(0xFF1D1418),
      surfaceContainer: Color(0xFF211A1E),
      surfaceContainerHigh: Color(0xFF2B2329),
      surfaceContainerHighest: Color(0xFF362F33),
    );
  }

  /// Light medium contrast color scheme
  static ColorScheme lightMediumContrastScheme() {
    return lightScheme().copyWith(
      primary: Color(0xFF0f2b7b),
      surface: Color(0xFFfaf6f9),
    );
  }

  /// Light high contrast color scheme
  static ColorScheme lightHighContrastScheme() {
    return lightScheme().copyWith(
      primary: Color(0xFF001c6c),
      surface: Color(0xFFf5f1f4),
      outline: const Color(0xff000000),
    );
  }

  /// Dark medium contrast color scheme
  static ColorScheme darkMediumContrastScheme() {
    return darkScheme().copyWith(
      primary: Color(0xFF193585),
      surface: Color(0xFF150e12),
    );
  }

  /// Dark high contrast color scheme
  static ColorScheme darkHighContrastScheme() {
    return darkScheme().copyWith(
      primary: Color(0xFF284494),
      surface: Color(0xFF1a1317),
      outline: const Color(0xffffffff),
    );
  }

  // ═══════════════════════════════════════════════════════════════════════════════
  // 🎯 MAIN THEME BUILDER - Clean and modular structure
  // ═══════════════════════════════════════════════════════════════════════════════

  /// Main theme function that combines all theme components
  /// Uses clean, modular structure with proper AppConstants integration
  static ThemeData theme(ColorScheme colorScheme) => ThemeData(
    useMaterial3: true,
    brightness: colorScheme.brightness,
    colorScheme: colorScheme,
    textTheme: _textTheme,
    appBarTheme: colorScheme.brightness == Brightness.light ? _lightAppBarTheme : _darkAppBarTheme,
    elevatedButtonTheme: _elevatedButtonTheme,
    textButtonTheme: _textButtonTheme,
    outlinedButtonTheme: _outlinedButtonTheme,
    inputDecorationTheme: _inputDecorationTheme,
    cardTheme: _cardTheme,
    chipTheme: _chipTheme,
    progressIndicatorTheme: _progressIndicatorTheme,
    dividerTheme: _dividerTheme,
    bottomNavigationBarTheme: _bottomNavigationBarTheme,
    tabBarTheme: _tabBarTheme,
    switchTheme: _switchTheme,
    checkboxTheme: _checkboxTheme,
    radioTheme: _radioTheme,
    sliderTheme: _sliderTheme,
    scaffoldBackgroundColor: colorScheme.surface,
    canvasColor: colorScheme.surface,
  );

  // ═══════════════════════════════════════════════════════════════════════════════
  // 🎨 THEME COMPONENTS - All using AppConstants for consistency
  // ═══════════════════════════════════════════════════════════════════════════════


  /// Text theme using AppConstants for consistent font sizes
  static final TextTheme _textTheme = TextTheme(
    displayLarge: TextStyle(
      fontSize: AppConstants.fontSizeDisplayLarge,
      fontWeight: FontWeight.w400,
      letterSpacing: -0.25,
      height: 1.1228070175438596,
    ),
    displayMedium: TextStyle(
      fontSize: AppConstants.fontSizeDisplayMedium,
      fontWeight: FontWeight.w400,
      letterSpacing: 0,
      height: 1.1555555555555554,
    ),
    displaySmall: TextStyle(
      fontSize: AppConstants.fontSizeDisplaySmall,
      fontWeight: FontWeight.w400,
      letterSpacing: 0,
      height: 1.2222222222222223,
    ),
    headlineLarge: TextStyle(
      fontSize: AppConstants.fontSizeHeadlineLarge,
      fontWeight: FontWeight.w400,
      letterSpacing: 0,
      height: 1.25,
    ),
    headlineMedium: TextStyle(
      fontSize: AppConstants.fontSizeHeadlineMedium,
      fontWeight: FontWeight.w400,
      letterSpacing: 0,
      height: 1.2857142857142858,
    ),
    headlineSmall: TextStyle(
      fontSize: AppConstants.fontSizeHeadlineSmall,
      fontWeight: FontWeight.w400,
      letterSpacing: 0,
      height: 1.3333333333333333,
    ),
    titleLarge: TextStyle(
      fontSize: AppConstants.fontSizeTitleLarge,
      fontWeight: FontWeight.w400,
      letterSpacing: 0,
      height: 1.2727272727272727,
    ),
    titleMedium: TextStyle(
      fontSize: AppConstants.fontSizeTitleMedium,
      fontWeight: FontWeight.w500,
      letterSpacing: 0.15,
      height: 1.5,
    ),
    titleSmall: TextStyle(
      fontSize: AppConstants.fontSizeTitleSmall,
      fontWeight: FontWeight.w500,
      letterSpacing: 0.1,
      height: 1.4285714285714286,
    ),
    labelLarge: TextStyle(
      fontSize: AppConstants.fontSizeLabelLarge,
      fontWeight: FontWeight.w500,
      letterSpacing: 0.1,
      height: 1.4285714285714286,
    ),
    labelMedium: TextStyle(
      fontSize: AppConstants.fontSizeLabelMedium,
      fontWeight: FontWeight.w500,
      letterSpacing: 0.5,
      height: 1.3333333333333333,
    ),
    labelSmall: TextStyle(
      fontSize: AppConstants.fontSizeLabelSmall,
      fontWeight: FontWeight.w500,
      letterSpacing: 0.5,
      height: 1.4545454545454546,
    ),
    bodyLarge: TextStyle(
      fontSize: AppConstants.fontSizeBodyLarge,
      fontWeight: FontWeight.w400,
      letterSpacing: 0.15,
      height: 1.5,
    ),
    bodyMedium: TextStyle(
      fontSize: AppConstants.fontSizeBodyMedium,
      fontWeight: FontWeight.w400,
      letterSpacing: 0.25,
      height: 1.4285714285714286,
    ),
    bodySmall: TextStyle(
      fontSize: AppConstants.fontSizeBodySmall,
      fontWeight: FontWeight.w400,
      letterSpacing: 0.4,
      height: 1.3333333333333333,
    ),
  );


  /// Elevated button theme
  static final ElevatedButtonThemeData _elevatedButtonTheme = ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      elevation: AppConstants.elevationLevel2,
      padding: EdgeInsets.symmetric(
        horizontal: AppConstants.spacingLG,
        vertical: AppConstants.spacingMD,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppConstants.radiusMD),
      ),
    ),
  );

  /// Text button theme
  static final TextButtonThemeData _textButtonTheme = TextButtonThemeData(
    style: TextButton.styleFrom(
      padding: EdgeInsets.symmetric(
        horizontal: AppConstants.spacingLG,
        vertical: AppConstants.spacingMD,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppConstants.radiusMD),
      ),
    ),
  );

  /// Outlined button theme
  static final OutlinedButtonThemeData _outlinedButtonTheme = OutlinedButtonThemeData(
    style: OutlinedButton.styleFrom(
      padding: EdgeInsets.symmetric(
        horizontal: AppConstants.spacingLG,
        vertical: AppConstants.spacingMD,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppConstants.radiusMD),
      ),
    ),
  );


  /// Input decoration theme
  static final InputDecorationTheme _inputDecorationTheme = InputDecorationTheme(
    contentPadding: EdgeInsets.symmetric(
      horizontal: AppConstants.spacingMD,
      vertical: AppConstants.spacingMD,
    ),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(AppConstants.radiusMD),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(AppConstants.radiusMD),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(AppConstants.radiusMD),
    ),
    errorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(AppConstants.radiusMD),
    ),
  );


  /// App bar theme for light mode
  static final AppBarTheme _lightAppBarTheme = AppBarTheme(
    elevation: AppConstants.elevationLevel1,
    centerTitle: false,
    titleSpacing: AppConstants.spacingMD,
    scrolledUnderElevation: AppConstants.elevationLevel1,
  );

  /// App bar theme for dark mode
  static final AppBarTheme _darkAppBarTheme = AppBarTheme(
    elevation: AppConstants.elevationLevel1,
    centerTitle: false,
    titleSpacing: AppConstants.spacingMD,
    scrolledUnderElevation: AppConstants.elevationLevel1,
  );

  /// Card theme
  static final CardThemeData _cardTheme = CardThemeData(
    elevation: AppConstants.elevationLevel1,
    margin: EdgeInsets.all(AppConstants.spacingSM),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(AppConstants.radiusLG),
    ),
  );

  /// Chip theme
  static final ChipThemeData _chipTheme = ChipThemeData(
    padding: EdgeInsets.symmetric(
      horizontal: AppConstants.spacingMD,
      vertical: AppConstants.spacingSM,
    ),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(AppConstants.radiusFull),
    ),
  );

  /// Progress indicator theme
  static final ProgressIndicatorThemeData _progressIndicatorTheme = ProgressIndicatorThemeData();

  /// Divider theme
  static final DividerThemeData _dividerTheme = DividerThemeData(
    thickness: AppConstants.borderWidthThin,
    space: AppConstants.spacingMD,
  );

  /// Bottom navigation bar theme
  static final BottomNavigationBarThemeData _bottomNavigationBarTheme = BottomNavigationBarThemeData(
    type: BottomNavigationBarType.fixed,
  );

  /// Tab bar theme
  static final TabBarThemeData _tabBarTheme = TabBarThemeData(
    labelPadding: EdgeInsets.symmetric(
      horizontal: AppConstants.spacingMD,
      vertical: AppConstants.spacingSM,
    ),
  );

  /// Switch theme
  static final SwitchThemeData _switchTheme = SwitchThemeData(
    thumbColor: WidgetStateProperty.resolveWith((states) {
      if (states.contains(WidgetState.selected)) {
        return lightScheme().primary;
      }
      return null;
    }),
  );

  /// Checkbox theme
  static final CheckboxThemeData _checkboxTheme = CheckboxThemeData(
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(AppConstants.radiusXS),
    ),
  );

  /// Radio theme
  static final RadioThemeData _radioTheme = RadioThemeData();

  /// Slider theme
  static final SliderThemeData _sliderTheme = SliderThemeData();
}

/// Custom theme colors extension for additional brand colors
extension CustomColors on ColorScheme {
  /// Success color for positive actions and states
  Color get success => const Color(0xFF2E7D32);
  
  /// Warning color for caution states
  Color get warning => const Color(0xFFF57C00);
  
  /// Info color for informational states
  Color get info => const Color(0xFF1976D2);
}
