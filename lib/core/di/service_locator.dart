import '../../service/auth_service.dart';
import '../../service/permission_service.dart';
import '../../service/in_and_out_service.dart';
import '../../viewModel/auth_view_model.dart';
import '../constants/device_constants.dart';
import '../init/cache/locale_manager.dart';
import '../init/navigation/navigation_service.dart';
import '../init/network/connectivity/network_connectivity.dart';
import '../position/location_manager.dart';

class ServiceLocator {
  static final ServiceLocator _instance = ServiceLocator._internal();
  static ServiceLocator get instance => _instance;

  ServiceLocator._internal();

  final Map<Type, dynamic> _services = {};
  final Map<Type, dynamic Function()> _factories = {};
  void registerSingleton<T>(T service) {
    _services[T] = service;
  }

  void registerFactory<T>(T Function() factory) {
    _factories[T] = factory;
  }

  T get<T>() {
    if (_services.containsKey(T)) {
      return _services[T] as T;
    }

    if (_factories.containsKey(T)) {
      return _factories[T]!() as T;
    }

    throw Exception('Service $T is not registered');
  }

  bool isRegistered<T>() {
    return _services.containsKey(T) || _factories.containsKey(T);
  }

  void reset() {
    _services.clear();
    _factories.clear();
  }

  void registerCoreServices() {
    registerSingleton<LocaleManager>(LocaleManager.instance);
    registerSingleton<NavigationService>(NavigationService.instance);
    registerSingleton<DeviceInfoManager>(DeviceInfoManager.instance);
    registerSingleton<NetworkConnectivity>(NetworkConnectivity());
    registerFactory<AuthService>(() => AuthService());
    registerFactory<PermissionService>(() => PermissionService());
    registerFactory<InAndOutService>(() => InAndOutService());
    registerFactory<LocationManager>(() => LocationManager());
    registerFactory<AuthViewModel>(() => AuthViewModel());
  }
}

extension ServiceLocatorExtension on Object {
  T getService<T>() => ServiceLocator.instance.get<T>();
}
