import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../core/constants/string_constants.dart';
import '../../core/extension/context_extension.dart';

class CustomAlertDialog {
  static locationPermissionAlert({
    required BuildContext context,
    required bool isEnabled,
    required bool isMock,
  }) async {
    return showDialog<void>(
      useSafeArea: true,
      context: context,
      barrierDismissible: false,
      barrierColor: context.colorScheme.primary,
      builder: (BuildContext context) {
        return AlertDialog(
          scrollable: true,
          elevation: 2,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(32.0)),
          ),
          content: SingleChildScrollView(
            child: Center(
              child: Column(
                children: <Widget>[
                  isMock
                      ? Text.rich(
                          TextSpan(
                            text: StringConstants
                                .instance
                                .isMockLocationPermissionTitle,
                            style: context.textTheme.bodyLarge,
                            children: [
                              TextSpan(
                                text: StringConstants
                                    .instance
                                    .isMockLocationPermissionDescription,
                                style: context.textTheme.bodyLarge,
                              ),
                            ],
                          ),
                        )
                      : Text(
                          isEnabled
                              ? StringConstants
                                    .instance
                                    .isEnableLocationAlertText
                              : StringConstants
                                    .instance
                                    .isNotEnableLocationAlertText,
                          style: context.textTheme.bodyLarge,
                          textAlign: TextAlign.center,
                        ),
                  const SizedBox(height: 5),
                ],
              ),
            ),
          ),
          actions: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () {
                    if (Platform.isIOS) {
                      exit(0);
                    } else {
                      SystemNavigator.pop();
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: context.colorScheme.primary,
                  ),
                  child: Text(
                    StringConstants.instance.okey,
                    style: context.primaryTextTheme.bodyLarge,
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );
  }
}
