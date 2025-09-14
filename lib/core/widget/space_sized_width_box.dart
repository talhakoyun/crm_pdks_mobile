import 'package:flutter/material.dart';

class SpaceSizedWidthBox extends StatelessWidget {
  const SpaceSizedWidthBox({super.key, required this.width})
    : assert(width > 0 && width <= 1);
  final double width;
  @override
  Widget build(BuildContext context) =>
      SizedBox(width: MediaQuery.of(context).size.width * width);
}
