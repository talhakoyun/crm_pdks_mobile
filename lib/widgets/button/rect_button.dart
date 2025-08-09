import 'package:flutter/material.dart';

import '../../core/extension/context_extension.dart';
import '../../core/init/size/size_setting.dart';

class RectButton extends StatelessWidget {
  const RectButton({
    super.key,
    required this.onTap,
    required this.buttonTex,
    required this.buttonColor,
    this.iconPath,
    this.imgWidth,
    this.iconColor,
  });
  final VoidCallback onTap;
  final String buttonTex;
  final Color buttonColor;
  final String? iconPath;
  final Color? iconColor;
  final double? imgWidth;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width:
          SizerUtil.width > 650 ? SizerUtil.width * .45 : SizerUtil.width * .4,
      height: SizerUtil.height > 720
          ? SizerUtil.height * .09
          : SizerUtil.height * .1,
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
              textScaler: TextScaler.linear(1.1),
              style: context.primaryTextTheme.headlineSmall!.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            Image.asset(
              iconPath!,
              width: imgWidth,
              color: iconColor,
            )
          ],
        ),
      ),
    );
  }
}
