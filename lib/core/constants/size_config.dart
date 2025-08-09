import 'package:flutter/material.dart';

class SizeConfig {
  static SizeConfig? _instance;

  static SizeConfig get instance => _instance ??= SizeConfig._init();

  SizeConfig._init();

  double findHeight(double value) {
    return (value * 100) / 800;
  }

  double _findWidth(double value) {
    return (value * 100) / 360;
  }

  double heightSize(BuildContext context, double value) {
    value /= 100;
    return MediaQuery.of(context).size.height * findHeight(value);
  }

  double widthSize(BuildContext context, double value) {
    value /= 100;
    return MediaQuery.of(context).size.width * _findWidth(value);
  }

  double scalablePixel(BuildContext context, double value) {
    return value * (MediaQuery.of(context).size.width / 3) / 100;
  }
}
