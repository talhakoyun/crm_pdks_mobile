import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

import '../../core/init/navigation/navigation_route.dart';
import '../../core/init/navigation/navigation_service.dart';
import 'service_locator.dart';
import '../init/cache/location_manager.dart';
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
    ChangeNotifierProvider<LocationManager>(
      create: (context) => ServiceLocator.instance.get<LocationManager>(),
    ),

    ChangeNotifierProvider<AuthViewModel>(
      create: (context) => ServiceLocator.instance.get<AuthViewModel>(),
    ),

    ChangeNotifierProxyProvider<LocationManager, InAndOutViewModel>(
      create: (context) {
        final locationManager = Provider.of<LocationManager>(
          context,
          listen: false,
        );
        return InAndOutViewModel(locationManager: locationManager);
      },
      update: (context, locationManager, previous) {
        if (previous != null && previous.locationManager == locationManager) {
          return previous;
        }
        return InAndOutViewModel(locationManager: locationManager);
      },
    ),

    ChangeNotifierProvider<PermissionViewModel>(
      create: (context) => PermissionViewModel(),
    ),

    ChangeNotifierProvider<InAndOutListViewModel>(
      create: (context) => InAndOutListViewModel(),
    ),
  ];
  get navigatorKey => NavigationService.instance.navigatorKey;
  get navigatorRoute => NavigationRoute.instance.generateRoute;
}
