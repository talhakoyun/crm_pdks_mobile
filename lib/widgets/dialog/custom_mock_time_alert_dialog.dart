import 'package:flutter/material.dart';

import '../../core/base/base_singleton.dart';
import '../../core/constants/string_constants.dart';
import '../../core/extension/context_extension.dart';

class CustomMockTimeDialog with BaseSingleton {
  static CustomMockTimeDialog instance = CustomMockTimeDialog._init();

  CustomMockTimeDialog._init();
  showMockTimeAlert({
    required BuildContext context,
  }) {
    showDialog<void>(
      useSafeArea: true,
      context: context,
      barrierDismissible: false,
      barrierColor: context.colorScheme.primary,
      builder: (BuildContext context) {
        return AlertDialog(
          scrollable: true,
          elevation: 2,
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(32.0))),
          content: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                Text.rich(
                  TextSpan(
                    text: strCons.mockTimeText1,
                    style: context.textTheme.bodyMedium,
                    children: [
                      TextSpan(
                          text: strCons.mockTimeTex2,
                          style: context.textTheme.bodyMedium)
                    ],
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
          actions: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () {
                    context.navigationOf.pop();
                  },
                  style: ElevatedButton.styleFrom(
                      backgroundColor: context.colorScheme.primary),
                  child: Text(StringConstants.instance.okey),
                ),
              ],
            )
          ],
        );
      },
    );
  }
}
