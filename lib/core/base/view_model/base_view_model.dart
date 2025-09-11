import 'package:flutter/material.dart';

import '../../constants/service_locator.dart';
import '../../init/cache/locale_manager.dart';
import '../../init/navigation/navigation_service.dart';

abstract class BaseViewModel extends ChangeNotifier {
  late final LocaleManager _localeManager;
  late final NavigationService _navigationService;
  LocaleManager get localeManager => _localeManager;
  NavigationService get navigation => _navigationService;
  BaseViewModel({
    LocaleManager? localeManager,
    NavigationService? navigationService,
  }) {
    _localeManager =
        localeManager ?? ServiceLocator.instance.get<LocaleManager>();
    _navigationService =
        navigationService ?? ServiceLocator.instance.get<NavigationService>();
  }

  void init();
  void disp();
}
