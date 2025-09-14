import 'package:flutter/material.dart';
import '../../init/theme/theme_extensions.dart';

abstract class BaseDialogBuilder {
  Future<T?> build<T>(BuildContext context) {
    return showDialog<T>(
      context: context,
      barrierDismissible: barrierDismissible,
      barrierColor: getBarrierColor(context),
      useSafeArea: useSafeArea,
      builder: (context) => buildDialogWidget(context),
    );
  }

  Widget buildDialogWidget(BuildContext context) {
    return AlertDialog(
      shape: getShape(),
      backgroundColor: getBackgroundColor(context),
      elevation: elevation,
      title: buildTitle(context),
      content: buildContent(context),
      actions: buildActions(context),
    );
  }

  Widget? buildTitle(BuildContext context);
  Widget? buildContent(BuildContext context);
  List<Widget>? buildActions(BuildContext context);
  bool get barrierDismissible => false;
  bool get useSafeArea => true;
  double get elevation => 2.0;
  Color? getBarrierColor(BuildContext context) =>
      context.colorScheme.scrim.withValues(alpha: 0.54);
  Color? getBackgroundColor(BuildContext context) => null;
  ShapeBorder? getShape() =>
      RoundedRectangleBorder(borderRadius: BorderRadius.circular(15));
}
