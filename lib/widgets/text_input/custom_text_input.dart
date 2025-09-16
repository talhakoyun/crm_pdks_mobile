import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../core/extension/context_extension.dart';

class CustomTextInput extends StatelessWidget {
  final TextEditingController? controller;
  final TextInputType? textInputType;
  final bool? obscureText;
  final bool autofocus;
  final int? maxLength;
  final String? labelText, hintText;
  final Widget? prefixIcon, suffixIcon;
  final TextInputAction? textInputAction;
  final Function(String)? onFieldSubmitted;
  final bool isModernStyle;
  final FocusNode? focusNode;
  final List<TextInputFormatter>? inputFormatters;

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
    this.textInputAction,
    this.onFieldSubmitted,
    this.isModernStyle = false,
    this.focusNode,
    this.inputFormatters,
  });

  @override
  Widget build(BuildContext context) {
    if (isModernStyle) {
      return Container(
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(15),
          border: Border.all(
            color: Colors.white.withValues(alpha: 0.3),
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
          inputFormatters: inputFormatters,
          style: TextStyle(color: Colors.white, fontSize: 16),
          obscureText: obscureText ?? false,
          maxLength: maxLength,
          decoration: InputDecoration(
            labelText: labelText,
            labelStyle: TextStyle(
              color: Colors.white.withValues(alpha: 0.7),
              fontSize: 14,
            ),
            hintText: hintText,
            hintStyle: TextStyle(
              color: Colors.white.withValues(alpha: 0.5),
              fontSize: 14,
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
        focusNode: focusNode,
        keyboardType: textInputType,
        textInputAction: textInputAction,
        onFieldSubmitted: onFieldSubmitted,
        inputFormatters: inputFormatters,
        style: context.textTheme.bodyLarge!.copyWith(
          color: context.colorScheme.surface,
        ),
        obscureText: obscureText ?? false,
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
