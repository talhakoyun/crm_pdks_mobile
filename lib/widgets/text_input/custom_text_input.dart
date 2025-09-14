import 'package:flutter/material.dart';

import '../../core/init/theme/theme_extensions.dart';

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
<<<<<<< Updated upstream
=======
    if (isModernStyle) {
      return Container(
        decoration: BoxDecoration(
          color: context.colorScheme.surface.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(15),
          border: Border.all(
            color: context.colorScheme.surface.withValues(alpha: 0.3),
            width: 1,
          ),
        ),
        child: TextFormField(
          autofocus: autofocus,
          controller: controller,
          focusNode: focusNode,
          keyboardType: textInputType,
          textInputAction: textInputAction,
          onFieldSubmitted: onFieldSubmitted,
          style: context.textTheme.bodyLarge!.copyWith(
            color: context.colorScheme.surface,
          ),
          obscureText: obscureText ?? false,
          maxLength: maxLength,
          decoration: InputDecoration(
            labelText: labelText,
            labelStyle: context.textTheme.bodyMedium!.copyWith(
              color: context.colorScheme.surface.withValues(alpha: 0.7),
            ),
            hintText: hintText,
            hintStyle: context.textTheme.bodyMedium!.copyWith(
              color: context.colorScheme.surface.withValues(alpha: 0.5),
            ),
            prefixIcon: prefixIcon,
            suffixIcon: suffixIcon,
            counterText: "",
            border: InputBorder.none,
            focusedBorder: InputBorder.none,
            enabledBorder: InputBorder.none,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 20,
              vertical: 16,
            ),
          ),
        ),
      );
    }

>>>>>>> Stashed changes
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
