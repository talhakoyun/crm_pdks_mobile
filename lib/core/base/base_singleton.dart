import '../../../core/constants/app_constants.dart';
import '../../../core/constants/device_constants.dart';
import '../../../core/constants/image_constants.dart';
import '../../../core/constants/string_constants.dart';

mixin BaseSingleton {
  StringConstants get strCons => StringConstants.instance;
  ImageConstants get imgCons => ImageConstants.instance;
  DeviceInfoManager get deviceInfo => DeviceInfoManager.instance;
  ApplicationConstants get appConstants => ApplicationConstants.instance;
}
