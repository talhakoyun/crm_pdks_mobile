import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../core/constants/string_constants.dart';
import '../../core/extension/context_extension.dart';
import '../../core/init/size/size_extension.dart';

Future<void> showInAndOutDialog({
  required BuildContext context,
  required String content,
  required String iconPath,
  required Color color,
  required VoidCallback onPressed,
}) {
  return showDialog(
    barrierDismissible: false,
    context: context,
    builder: (context) => AlertDialog(
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 15.width,
            height: 15.width,
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(7.5),
            ),
            child: Padding(
              padding: context.paddingLow,
              child: SvgPicture.asset(iconPath),
            ),
          ),
          context.emptySizedHeightBoxLow2x,
          Text(content, style: context.textTheme.bodyMedium),
        ],
      ),
      actions: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            ElevatedButton(
              onPressed: onPressed,
              style: ElevatedButton.styleFrom(
                backgroundColor: context.colorScheme.primary,
                fixedSize: Size(25.width, 5.height),
              ),
              child: Text(
                StringConstants.instance.approveButtonText,
                style: context.primaryTextTheme.bodyLarge,
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: context.colorScheme.error,
                fixedSize: Size(25.width, 5.height),
              ),
              child: Text(
                StringConstants.instance.cancelButtonText,
                style: context.primaryTextTheme.bodyLarge,
              ),
            ),
          ],
        ),
      ],
    ),
  );
}
