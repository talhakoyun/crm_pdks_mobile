// ignore_for_file: constant_identifier_names

import '../constants/string_constants.dart';

enum BottomNavigationItem { HOME, IN_AND_OUT, PERMISSIONS, PROFILE }

extension BottomNavigationItemExtension on BottomNavigationItem {
  String get title {
    switch (this) {
      case BottomNavigationItem.HOME:
        return StringConstants.instance.bottomNavigationHome;
      case BottomNavigationItem.IN_AND_OUT:
        return StringConstants.instance.bottomNavigationInAndOut;
      case BottomNavigationItem.PERMISSIONS:
        return StringConstants.instance.bottomNavigationPermissions;
      case BottomNavigationItem.PROFILE:
        return StringConstants.instance.bottomNavigationProfile;
    }
  }

  String get icon {
    switch (this) {
      case BottomNavigationItem.HOME:
        return 'home';
      case BottomNavigationItem.IN_AND_OUT:
        return 'access_time';
      case BottomNavigationItem.PERMISSIONS:
        return 'assignment';
      case BottomNavigationItem.PROFILE:
        return 'person';
    }
  }

  String get route {
    switch (this) {
      case BottomNavigationItem.HOME:
        return '/home';
      case BottomNavigationItem.IN_AND_OUT:
        return '/in-and-out';
      case BottomNavigationItem.PERMISSIONS:
        return '/permission';
      case BottomNavigationItem.PROFILE:
        return '/profile';
    }
  }
}
