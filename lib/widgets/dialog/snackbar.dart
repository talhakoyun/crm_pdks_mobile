import 'package:flutter/material.dart';

import '../../core/extension/context_extension.dart';

class CustomSnackBar {
  CustomSnackBar(BuildContext context, String content,
      {SnackBarAction? snackBarAction, Color backgroundColor = Colors.green}) {
    final SnackBar snackBar = SnackBar(
        action: snackBarAction,
        duration: const Duration(seconds: 3),
        backgroundColor: backgroundColor,
        content: Text(
          content,
          style: context.primaryTextTheme.bodyMedium,
        ),
        behavior: SnackBarBehavior.floating);

    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}
