import 'package:flutter/material.dart';

import '../../../../view/register_view.dart';
import '../../../view/get_permisson_view.dart';
import '../../../view/home_view.dart';
import '../../../view/in_and_out_view.dart';
import '../../../view/login_view.dart';
import '../../../view/permission_procedure_view.dart';
import '../../../view/profile_view.dart';
import '../../../view/splash_view.dart';
import '../../../widgets/hack_device_view.dart';
import '../../constants/navigation_constants.dart';
import '../../widget/not_found_navigation_widget.dart';

class NavigationRoute {
  static final NavigationRoute _instance = NavigationRoute._init();
  static NavigationRoute get instance => _instance;

  NavigationRoute._init();

  Route<dynamic> generateRoute(RouteSettings args) {
    switch (args.name) {
      case NavigationConstants.DEFAULT:
        return normalNavigate(
          SplashView(),
          NavigationConstants.DEFAULT,
          args.arguments,
        );
      case NavigationConstants.LOGIN:
        return normalNavigate(
          LoginView(),
          NavigationConstants.LOGIN,
          args.arguments,
        );
      case NavigationConstants.REGISTER:
        return normalNavigate(
          RegisterView(),
          NavigationConstants.REGISTER,
          null,
        );
      case NavigationConstants.HOME:
        return normalNavigate(HomeView(), NavigationConstants.HOME, null);
      case NavigationConstants.HACK:
        return normalNavigate(DeviceHackView(), NavigationConstants.HACK, null);
      case NavigationConstants.GETPERM:
        return normalNavigate(
          GetPermissionView(),
          NavigationConstants.GETPERM,
          null,
        );
      case NavigationConstants.PROFILE:
        return normalNavigate(ProfileView(), NavigationConstants.PROFILE, null);
      case NavigationConstants.INANDOUTS:
        return normalNavigate(
          InAndOutsView(),
          NavigationConstants.INANDOUTS,
          null,
        );
      case NavigationConstants.PERMISSION:
        return normalNavigate(
          PermissionProceduresView(),
          NavigationConstants.PERMISSION,
          null,
        );
      default:
        return MaterialPageRoute(
          builder: (context) => const NotFoundNavigationWidget(),
        );
    }
  }

  MaterialPageRoute normalNavigate(
    Widget widget,
    String pageName,
    Object? args,
  ) {
    return MaterialPageRoute(
      builder: (context) => widget,
      //analytciste görülecek olan sayfa ismi için pageName veriyoruz
      settings: RouteSettings(name: pageName, arguments: args),
    );
  }
}
