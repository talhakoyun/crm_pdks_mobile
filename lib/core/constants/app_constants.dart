import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

import '../../core/init/navigation/navigation_route.dart';
import '../../core/init/navigation/navigation_service.dart';
import '../../core/position/location_manager.dart';
import '../../viewModel/auth_view_model.dart';
import '../../viewModel/in_and_out_view_model.dart';
import '../../viewModel/inandout_list_view_model.dart';
import '../../viewModel/permissions_view_model.dart';

class ApplicationConstants {
  static ApplicationConstants? _instance;
  static ApplicationConstants get instance {
    if (_instance != null) {
      return _instance!;
    } else {
      _instance = ApplicationConstants.init();
      return _instance!;
    }
  }

  ApplicationConstants.init();

  final List<SingleChildWidget> providers = [
    ChangeNotifierProvider(create: (context) => AuthViewModel()),
    ChangeNotifierProvider(create: (context) => InAndOutViewModel()),
    ChangeNotifierProvider(create: (context) => PermissionViewModel()),
    ChangeNotifierProvider(create: (context) => LocationManager()),
    ChangeNotifierProvider(create: (context) => InAndOutListViewModel()),
  ];
  get navigatorKey => NavigationService.instance.navigatorKey;
  get navigatorRoute => NavigationRoute.instance.generateRoute;
}
