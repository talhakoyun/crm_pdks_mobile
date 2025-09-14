import 'package:flutter/material.dart';

class SpaceSizedHeightBox extends StatelessWidget {
  const SpaceSizedHeightBox({super.key, required this.height})
    : assert(height > 0 && height <= 1);
  final double height;
  @override
  Widget build(BuildContext context) =>
      SizedBox(height: MediaQuery.of(context).size.height * height);
}
