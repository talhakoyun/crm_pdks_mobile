import 'color_scheme.dart';
import 'text_theme/dark_text_theme.dart';
import 'text_theme/light_text_theme.dart';

mixin ThemeInterface {
  CustomColorScheme? customColorScheme = CustomColorScheme.instance;
  CustomBlackTextTheme? customBlackTextTheme = CustomBlackTextTheme.instance;
  CustomWhiteTextTheme? customWhiteTextTheme = CustomWhiteTextTheme.instance;
}
