import 'package:flutter/material.dart';

import '../core/extension/context_extension.dart';
import '../core/init/size/size_setting.dart';

Widget errorPageView(
    {required BuildContext context,
    required String imagePath,
    required String title,
    required String subtitle,
    Color backgroundColor = Colors.white}) {
  return Container(
    color: backgroundColor,
    child: Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            imagePath,
            width: SizerUtil.width * 0.5,
          ),
          const SizedBox(
            height: 20,
          ),
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
