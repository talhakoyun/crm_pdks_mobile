import 'package:flutter/material.dart';

import '../core/constants/image_constants.dart';
import '../core/constants/string_constants.dart';
import '../core/extension/context_extension.dart';
import '../core/init/size/size_extension.dart';

class DeviceHackView extends StatelessWidget {
  const DeviceHackView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.colorScheme.primary,
      body: Center(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            ImageConstants.instance.alarm,
            width: 55.width,
          ),
          context.emptySizedHeightBoxNormal,
          Text(
            StringConstants.instance.hackText,
            style: context.primaryTextTheme.bodyLarge,
            textAlign: TextAlign.center,
          )
        ],
      )),
    );
  }
}
