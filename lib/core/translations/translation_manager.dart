import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

@immutable
final class TranslationManager extends EasyLocalization {
  TranslationManager({required super.child, super.key})
    : super(
        supportedLocales: _supportedItems,
        path: _translationPath,
        useOnlyLangCode: true,
      );

  static final List<Locale> _supportedItems = [
    Locales.tr.locale,
    Locales.en.locale,
  ];

  static const String _translationPath = 'assets/translations';

  static Future<void> updateLanguage({
    required BuildContext context,
    required Locales value,
  }) => context.setLocale(value.locale);
}

enum Locales {
  tr(Locale('tr', 'TR')),

  en(Locale('en', 'US'));

  final Locale locale;

  const Locales(this.locale);
}
