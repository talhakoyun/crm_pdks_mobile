import 'package:flutter/material.dart';

import 'size_setting.dart';
import '../../enums/enums.dart';

typedef ResponsiveBuild =
    Widget Function(
      BuildContext context,
      Orientation orientation,
      DeviceType deviceType,
    );

class Sizer extends StatelessWidget {
  const Sizer({super.key, required this.builder});

  final ResponsiveBuild builder;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return OrientationBuilder(
          builder: (context, orientation) {
            SizerUtil.setScreenSize(constraints, orientation);
            return builder(context, orientation, SizerUtil.deviceType);
          },
        );
      },
    );
  }
}
