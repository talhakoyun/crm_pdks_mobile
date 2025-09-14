import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../core/init/theme/theme_extensions.dart';

Widget errorPageView({
  required BuildContext context,
  required String imagePath,
  required String title,
  required String subtitle,
  Color? backgroundColor,
}) {
  return Container(
    color: backgroundColor ?? Theme.of(context).colorScheme.surface,
    child: Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(imagePath, width: 1.sw * 0.5),
          const SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Text(
              title,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                color: context.colorScheme.error,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Text(
              subtitle,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                color: context.colorScheme.error,
              ),
            ),
          ),
        ],
      ),
    ),
  );
}
