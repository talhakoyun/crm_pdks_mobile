import 'package:flutter/material.dart';

import '../../core/extension/context_extension.dart';

class CustomTextInput extends StatelessWidget {
  final TextEditingController? controller;
  final TextInputType? textInputType;
  final bool? obscureText;
  final bool autofocus;
  final int? maxLength;
  final String? labelText, hintText;
  final Widget? prefixIcon, suffixIcon;

  const CustomTextInput({
    super.key,
    this.controller,
    this.textInputType,
    this.obscureText,
    this.autofocus = false,
    this.labelText,
    this.hintText,
    this.prefixIcon,
    this.suffixIcon,
    this.maxLength,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        border: Border.all(color: context.colorScheme.surface),
        borderRadius: BorderRadius.circular(20),
      ),
      child: TextFormField(
        autofocus: autofocus,
        cursorColor: context.colorScheme.surface,
        controller: controller,
        keyboardType: textInputType,
        style: context.textTheme.bodyLarge!.copyWith(
          color: context.colorScheme.surface,
        ),
        obscureText: obscureText!,
        maxLength: maxLength,
        decoration: InputDecoration(
          labelText: labelText,
          prefixIcon: prefixIcon,
          suffixIcon: suffixIcon,
          counterText: "",
          hintText: hintText,
          border: InputBorder.none,
        ),
      ),
    );
  }
}
