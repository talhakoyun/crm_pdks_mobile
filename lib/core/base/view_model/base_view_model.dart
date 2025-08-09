import 'package:flutter/material.dart';

import '../../init/cache/locale_manager.dart';
import '../../init/navigation/navigation_service.dart';
import '../../position/location_manager.dart';

abstract class BaseViewModel extends ChangeNotifier {
  LocaleManager localeManager = LocaleManager.instance;
  NavigationService navigation = NavigationService.instance;
  LocationManager location = LocationManager();
  void init();
  void disp();
}
