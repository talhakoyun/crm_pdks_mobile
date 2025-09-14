import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class DialogButton extends StatelessWidget {
  final String buttonText;
  final double? width;
  final double? height;
  final Color? color;
  final Color? highlightColor;
  final Color? splashColor;
  final Gradient? gradient;
  final BorderRadius? radius;
  final Function()? onPressed;
  final BoxBorder? border;
  final EdgeInsets? padding;
  final EdgeInsets? margin;

  const DialogButton({
    super.key,
    required this.buttonText,
    this.width,
    this.height = 40.0,
    required this.color,
    this.highlightColor,
    this.splashColor,
    this.gradient,
    this.radius,
    this.border,
    this.padding = const EdgeInsets.only(left: 6, right: 6),
    this.margin = const EdgeInsets.all(6),
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding,
      margin: margin,
      width: 1.sw > 350 ? 120 : 90,
      height: height,
      decoration: BoxDecoration(
        color: color,
        gradient: gradient,
        borderRadius: radius ?? BorderRadius.circular(15),
        border: border ?? Border.all(color: Colors.transparent, width: 0),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          highlightColor: highlightColor ?? Theme.of(context).highlightColor,
          splashColor: splashColor ?? Theme.of(context).splashColor,
          onTap: onPressed,
          child: Center(
            child: Text(
              buttonText,
              style: Theme.of(context).primaryTextTheme.bodyMedium!.copyWith(
                fontSize: 1.sw > 350 ? 20.sp : 16.sp,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
