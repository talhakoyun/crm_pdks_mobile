import 'package:flutter/material.dart';

class CustomSnackBar {
  CustomSnackBar(
    BuildContext context,
    String content, {
    SnackBarAction? snackBarAction,
    Color? backgroundColor,
  }) {
    if (!context.mounted) return;
    final SnackBar snackBar = SnackBar(
      action: snackBarAction,
      duration: const Duration(seconds: 3),
      backgroundColor:
          backgroundColor ?? Theme.of(context).colorScheme.tertiaryContainer,
      content: Text(
        content,
        style: Theme.of(context).primaryTextTheme.bodyMedium,
      ),
      behavior: SnackBarBehavior.floating,
    );

    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}
