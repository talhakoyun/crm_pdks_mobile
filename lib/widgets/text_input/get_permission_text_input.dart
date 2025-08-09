import 'package:flutter/material.dart';

import '../../core/extension/context_extension.dart';

class GetPermissionInput extends StatelessWidget {
  final TextEditingController? controller;
  final TextInputType? textInputType;
  final bool? obscureText, readOnly, showCursor;
  final int? maxLength, minLines, maxLines;
  final TextAlignVertical? textAlignVertical;
  final String? hintText;
  final Widget? prefixIcon, suffixIcon;
  final VoidCallback? onTap;
  final BoxConstraints? constraints;
  final TextStyle? textStyle, hintStyle;
  final EdgeInsetsGeometry? margin;
  const GetPermissionInput({
    super.key,
    this.controller,
    this.textInputType,
    this.obscureText,
    this.textAlignVertical,
    this.hintText,
    this.prefixIcon,
    this.constraints,
    this.suffixIcon,
    this.maxLength,
    this.onTap,
    this.readOnly,
    this.showCursor,
    this.minLines,
    this.maxLines,
    this.textStyle,
    this.hintStyle,
    this.margin,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      cursorColor: context.colorScheme.surface,
      controller: controller,
      keyboardType: textInputType,
      style: textStyle ??
          context.textTheme.bodyLarge!.copyWith(
            fontWeight: FontWeight.w400,
          ),
      showCursor: showCursor,
      readOnly: readOnly!,
      onTap: onTap,
      minLines: minLines,
      maxLines: maxLines,
      obscureText: obscureText!,
      textAlignVertical: textAlignVertical,
      maxLength: maxLength,
      decoration: InputDecoration(
        constraints: constraints,
        hintStyle: hintStyle ??
            context.textTheme.bodyMedium!.copyWith(
              fontWeight: FontWeight.w400,
            ),
        prefixIcon: Container(
          margin: margin ?? const EdgeInsets.all(7.5),
          decoration: BoxDecoration(
            border: Border(
              right: BorderSide(
                style: BorderStyle.solid,
                color: context.colorScheme.surface,
                width: 0.75,
              ),
            ),
          ),
          child: prefixIcon,
        ),
        suffixIcon: suffixIcon,
        counterText: "",
        hintText: hintText,
        border: InputBorder.none,
        filled: true,
        alignLabelWithHint: true,
        enabledBorder: OutlineInputBorder(
          borderRadius: const BorderRadius.all(Radius.circular(15)),
          borderSide:
              BorderSide(color: context.colorScheme.surface, width: 1.0),
        ),
        focusedBorder: OutlineInputBorder(
          //Add this to your code...
          borderRadius: const BorderRadius.all(Radius.circular(15)),
          borderSide:
              BorderSide(color: context.colorScheme.surface, width: 1.0),
        ),
      ),
    );
  }
}
