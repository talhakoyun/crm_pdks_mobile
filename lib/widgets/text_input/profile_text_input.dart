import 'package:flutter/material.dart';

import '../../core/extension/context_extension.dart';

class ProfileTextInput extends StatelessWidget {
  final double? heightCon, iconSize;
  final String? title, description;
  final IconData? icon;

  const ProfileTextInput({
    super.key,
    this.heightCon,
    this.iconSize,
    this.description,
    this.title,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: heightCon,
      decoration: BoxDecoration(
        border: Border.all(color: context.colorScheme.surface),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          Container(
            width: 45,
            height: 45,
            margin: const EdgeInsets.only(left: 10),
            padding: const EdgeInsets.only(
              right: 5,
            ),
            decoration: BoxDecoration(
              border: Border(
                right: BorderSide(
                  style: BorderStyle.solid,
                  color: context.colorScheme.surface,
                  width: 0.75,
                ),
              ),
            ),
            child: Icon(
              icon,
              color: context.colorScheme.surface,
              size: iconSize,
            ),
          ),
          context.emptySizedWidthBoxLow2x,
          Padding(
            padding: const EdgeInsets.only(top: 10.0),
            child: Column(
              children: [
                Text.rich(
                  TextSpan(
                    text: "$title\n",
                    style: context.textTheme.bodyMedium!.copyWith(
                      color: context.colorScheme.surface,
                      fontWeight: FontWeight.w300,
                    ),
                    children: <TextSpan>[
                      TextSpan(
                        text: description,
                        style: context.textTheme.bodyLarge!.copyWith(
                          color: context.colorScheme.surface,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
