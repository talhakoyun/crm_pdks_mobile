import 'package:flutter/material.dart';

import '../enums/enums.dart';
import '../init/size/size_setting.dart';
import '../widget/page_animation/slider_route.dart';
import '../widget/space_sized_height_box.dart';
import '../widget/space_sized_width_box.dart';

extension ContextExtension on BuildContext {
  MediaQueryData get mediaQuery => MediaQuery.of(this);

  TextTheme get textTheme => Theme.of(this).textTheme;
  TextTheme get primaryTextTheme => Theme.of(this).primaryTextTheme;
  ElevatedButtonThemeData get elevatedButtonTheme =>
      Theme.of(this).elevatedButtonTheme;

  ColorScheme get colorScheme => Theme.of(this).colorScheme;

  ThemeData get appTheme => Theme.of(this);
}

extension MediaQueryExtension on BuildContext {
  double get height => SizerUtil.height;
  double get width => SizerUtil.width;

  double get lowValue => height * 0.01;
  double get normalValue => height * 0.02;
  double get mediumValue => height * 0.04;
  double get highValue => height * 0.1;

  double dynamicWidth(double val) => width * val;
  double dynamicHeight(double val) => height * val;
}

extension PaddingExtension on BuildContext {
  EdgeInsets get paddingLow => EdgeInsets.all(lowValue);
  EdgeInsets get paddingNormal => EdgeInsets.all(normalValue);
  EdgeInsets get onlyLeftPaddingLow => EdgeInsets.only(left: lowValue);
  EdgeInsets get onlyRightPaddingLow => EdgeInsets.only(right: lowValue);
  EdgeInsets get onlyBottomPaddingNormal =>
      EdgeInsets.only(bottom: normalValue);
  EdgeInsets get onlyTopPaddingHigh => EdgeInsets.only(top: highValue);
}

extension SizedBoxExtension on BuildContext {
  Widget get emptySizedWidthBoxLow2x => const SpaceSizedWidthBox(width: 0.02);
  Widget get emptySizedWidthBoxLow3x => const SpaceSizedWidthBox(width: 0.03);

  Widget get emptySizedHeightBoxLow => const SpaceSizedHeightBox(height: 0.01);
  Widget get emptySizedHeightBoxLow2x =>
      const SpaceSizedHeightBox(height: 0.02);
  Widget get emptySizedHeightBoxLow3x =>
      const SpaceSizedHeightBox(height: 0.03);
  Widget get emptySizedHeightBoxNormal =>
      const SpaceSizedHeightBox(height: 0.05);
  Widget get emptySizedHeightBoxHigh => const SpaceSizedHeightBox(height: 0.1);
}

extension NavigationExtension on BuildContext {
  NavigatorState get navigationOf => Navigator.of(this);

  Future<bool> pop<T>([T? data]) async {
    return navigationOf.maybePop(data);
  }

  void popWithRoot() => Navigator.of(this, rootNavigator: true).pop();

  Future<T?> navigateName<T>(String path, {Object? data}) async {
    return navigationOf.pushNamed<T>(path, arguments: data);
  }

  Future<T?> navigateToReset<T>(String path, {Object? data}) async {
    return navigationOf.pushNamedAndRemoveUntil(
      path,
      (route) => false,
      arguments: data,
    );
  }

  Future<T?> navigateToPage<T>(
    Widget page, {
    Object? extra,
    SlideType type = SlideType.DEFAULT,
  }) async {
    return navigationOf.push<T>(
      type.route(page, RouteSettings(arguments: extra)),
    );
  }
}
