import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../core/constants/image_constants.dart';
import '../core/constants/string_constants.dart';
import '../core/init/theme/theme_extensions.dart';

class DeviceHackView extends StatelessWidget {
  const DeviceHackView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.colorScheme.primary,
      body: Center(
<<<<<<< Updated upstream
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
=======
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(ImageConstants.instance.alarm, width: 60.w),
            SizedBox(height: MediaQuery.of(context).size.height * 0.05),
            Text(
              StringConstants.instance.hackText,
              style: Theme.of(context).primaryTextTheme.bodyLarge,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
>>>>>>> Stashed changes
    );
  }
}
