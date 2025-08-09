import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../core/extension/context_extension.dart';

class CustomListTile extends StatelessWidget {
  const CustomListTile({
    super.key,
    required this.onTap,
    required this.text,
    required this.iconPath,
    this.height,
    this.width,
  });
  final VoidCallback onTap;
  final String text;
  final String iconPath;
  final double? width, height;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
          elevation: 0,
          color: context.colorScheme.primary.withValues(alpha: .20),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          child: SizedBox(
            width: width,
            height: height,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                  margin: const EdgeInsets.only(left: 5, right: 5),
                  padding: context.paddingLow,
                  child: SvgPicture.asset(
                    iconPath,
                    colorFilter: ColorFilter.mode(
                      context.colorScheme.primary,
                      BlendMode.srcIn,
                    ),
                  ),
                ),
                Text(
                  text,
                  style: context.textTheme.bodyLarge!.copyWith(
                    color: context.colorScheme.surface,
                    fontWeight: FontWeight.w400,
                  ),
                )
              ],
            ),
          )),
    );
  }
}
