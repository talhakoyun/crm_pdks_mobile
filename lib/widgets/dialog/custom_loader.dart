import 'package:flutter/material.dart';

import '../../core/extension/context_extension.dart';

class CustomLoader {
  static showAlertDialog(
    BuildContext context,
  ) {
    AlertDialog customLoader = AlertDialog(
        backgroundColor: Colors.transparent,
        elevation: 0,
        content: SizedBox(
          height: 40,
          width: 40,
          child: Center(
            child: CircularProgressIndicator(
              backgroundColor: context.colorScheme.primary,
              valueColor: AlwaysStoppedAnimation(context.colorScheme.onPrimaryContainer),
              color: context.colorScheme.error,
            ),
          ),
        ));

    // show the dialog
    showDialog(
      useSafeArea: true,
      barrierDismissible: false,
      barrierColor: Colors.black38,
      context: context,
      builder: (BuildContext context) {
        return customLoader;
      },
    );
  }
}
