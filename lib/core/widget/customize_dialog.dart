import 'dart:io';

import 'package:flutter/material.dart';

import '../constants/image_constants.dart';
import '../constants/string_constants.dart';
import '../enums/enums.dart';
import '../extension/context_extension.dart';
import '../init/size/size_extension.dart';

class CustomizeDialog {
  static void show({
    required BuildContext context,
    required DialogType type,
    required String message,
    String? title,
    String? buttonText,
    bool exitOnClose = false,
    Function? onConfirm,
  }) {
    late String icon;
    late String dialogTitle;
    late String dialogButtonText;
    late Function dialogAction;

    switch (type) {
      case DialogType.error:
        icon = ImageConstants.instance.error;
        dialogTitle = title ?? "Hata";
        dialogButtonText = buttonText ?? "Kapat";
        dialogAction =
            onConfirm ??
            () {
              if (exitOnClose) {
                exit(0);
              } else {
                Navigator.of(context).pop();
              }
            };
        break;
      case DialogType.success:
        icon = ImageConstants.instance.success;
        dialogTitle = title ?? "Başarılı";
        dialogButtonText = buttonText ?? "Kapat";
        dialogAction = onConfirm ?? () => Navigator.of(context).pop();
        break;
      case DialogType.update:
        icon = ImageConstants.instance.error;
        dialogTitle = title ?? StringConstants.instance.appName;
        dialogButtonText = buttonText ?? "Güncelle";
        dialogAction = onConfirm ?? () => Navigator.of(context).pop();
        break;
    }

    AlertDialog customizeAlert = AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      title: Column(
        children: [
          Image.asset(icon, width: 20.width, fit: BoxFit.fitWidth),
          const SizedBox(height: 20),
          Text(
            dialogTitle,
            style: context.primaryTextTheme.titleMedium,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 20),
          Text(
            message,
            style: context.primaryTextTheme.titleSmall,
            textAlign: TextAlign.center,
          ),
        ],
      ),
      actions: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              height: 5.height,
              width: 27.width,
              child: ElevatedButton(
                onPressed: () => dialogAction(),
                child: Text(
                  dialogButtonText,
                  style: context.primaryTextTheme.bodyMedium,
                ),
              ),
            ),
          ],
        ),
      ],
    );

    showDialog(
      useSafeArea: true,
      barrierColor: Colors.black54,
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return PopScope(
          canPop: false,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [customizeAlert],
          ),
        );
      },
    );
  }
}
