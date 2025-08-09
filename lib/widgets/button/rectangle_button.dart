import 'package:flutter/material.dart';

import '../../core/extension/context_extension.dart';
import '../../core/init/size/size_extension.dart';
import '../../core/init/size/size_setting.dart';

class RectangleButton extends StatelessWidget {
  const RectangleButton(
      {super.key,
      required this.onTap,
      required this.buttonTex,
      required this.buttonColor,
      required this.iconPath,
      required this.iconColor});
  final Function()? onTap;
  final String buttonTex;
  final Color buttonColor;
  final String iconPath;
  final Color iconColor;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: SizerUtil.width * .45,
      height: SizerUtil.height > 720
          ? SizerUtil.height * .18
          : SizerUtil.height * .2,
      child: ElevatedButton(
        onPressed: onTap,
        style: ElevatedButton.styleFrom(
          backgroundColor: buttonColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Text(
              buttonTex,
              textScaler: TextScaler.linear(1.2),
              style: context.primaryTextTheme.headlineSmall!.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            Image.asset(
              iconPath,
              width: 15.width,
              color: iconColor,
            )
          ],
        ),
      ),
    );
  }
}
