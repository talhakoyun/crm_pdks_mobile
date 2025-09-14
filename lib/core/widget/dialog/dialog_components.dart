import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../init/theme/theme_extensions.dart';

class DialogTitleWidget extends StatelessWidget {
  final String iconPath;
  final String title;
  final String? message;

  const DialogTitleWidget({
    super.key,
    required this.iconPath,
    required this.title,
    this.message,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Image.asset(iconPath, width: 20.w, fit: BoxFit.fitWidth),
        const SizedBox(height: 20),
        Text(
          title,
          style: Theme.of(context).primaryTextTheme.titleMedium,
          textAlign: TextAlign.center,
        ),
        if (message != null) ...[
          const SizedBox(height: 20),
          Text(
            message!,
            style: Theme.of(context).primaryTextTheme.titleSmall,
            textAlign: TextAlign.center,
          ),
        ],
      ],
    );
  }
}

class DialogActionButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final bool isPrimary;
  final bool isDestructive;
  final Color? backgroundColor;

  const DialogActionButton({
    super.key,
    required this.text,
    this.onPressed,
    this.isPrimary = false,
    this.isDestructive = false,
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    final Color buttonColor =
        backgroundColor ??
        (isDestructive
            ? context.colorScheme.error
            : context.colorScheme.primary);

    return SizedBox(
      height: 5.h,
      width: isPrimary ? 28.w : null,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(backgroundColor: buttonColor),
        child: Text(text, style: Theme.of(context).primaryTextTheme.bodyMedium),
      ),
    );
  }
}

class DialogActionsRow extends StatelessWidget {
  final List<Widget> actions;
  final MainAxisAlignment alignment;

  const DialogActionsRow({
    super.key,
    required this.actions,
    this.alignment = MainAxisAlignment.center,
  });

  @override
  Widget build(BuildContext context) {
    return Row(mainAxisAlignment: alignment, children: actions);
  }
}
