import 'package:flutter/material.dart';

import '../../core/extension/context_extension.dart';

class PermButton extends StatelessWidget {
  const PermButton({
    super.key,
    required this.onTap,
    required this.buttonTex,
    required this.buttonColor,
  });
  final VoidCallback onTap;
  final String buttonTex;
  final Color buttonColor;
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onTap,
      style: ElevatedButton.styleFrom(
        backgroundColor: buttonColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
      ),
      child: Text(
        buttonTex,
        textScaler: TextScaler.linear(1.1),
        style: context.primaryTextTheme.headlineSmall!.copyWith(
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
