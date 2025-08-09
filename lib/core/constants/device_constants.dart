import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/services.dart';
import 'package:platform_device_id_plus/platform_device_id.dart';

class DeviceInfoManager {
  static DeviceInfoManager? _instance;
  static DeviceInfoManager get instance =>
      _instance ??= DeviceInfoManager._init();

  DeviceInfoManager._init();
  final _deviceInfo = DeviceInfoPlugin();
  String? deviceId;
  String? deviceModel;
  bool? isEmulator;
  bool isFailedDeviceInfo = false;

  DeviceInfoManager() {
    if (deviceId == null || deviceModel == null) {
      getDeviceInfo();
    }
  }

  getDeviceInfo() async {
    deviceId = await PlatformDeviceId.getDeviceId;

    try {
      if (Platform.isAndroid) {
        AndroidDeviceInfo androidInfo = await _deviceInfo.androidInfo;

        deviceModel = "${androidInfo.brand} ${androidInfo.model}";
      } else if (Platform.isIOS) {
        IosDeviceInfo androidInfo = await _deviceInfo.iosInfo;
        deviceModel = "${androidInfo.name} ${androidInfo.model}";
      }
    } on PlatformException {
      isFailedDeviceInfo = true;
    }
  }

  Future<bool?> isRealDevice() async {
    if (!Platform.isIOS) {
      AndroidDeviceInfo androidInfo = await DeviceInfoPlugin().androidInfo;
      return androidInfo.isPhysicalDevice;
    } else {
      IosDeviceInfo iosDeviceInfo = await DeviceInfoPlugin().iosInfo;
      return iosDeviceInfo.isPhysicalDevice;
    }
  }
}
