import 'size_setting.dart';

extension SizerExtension on num {
  double get height => this * SizerUtil.height / 100;
  double get width => this * SizerUtil.width / 100;
  double get scalablePixel => this * (SizerUtil.width / 3) / 100;
}
