import 'package:flutter/material.dart';

import '../extension/context_extension.dart';

class SpaceSizedHeightBox extends StatelessWidget {
  const SpaceSizedHeightBox({Key? key, required this.height})
      : assert(height > 0 && height <= 1),
        super(key: key);
  final double height;
  @override
  Widget build(BuildContext context) =>
      SizedBox(height: context.height * height);
}
