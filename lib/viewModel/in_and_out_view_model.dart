import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../core/base/view_model/base_view_model.dart';
import '../core/constants/device_constants.dart';
import '../core/constants/image_constants.dart';
import '../core/constants/string_constants.dart';
import '../core/constants/service_locator.dart';
import '../core/enums/enums.dart';
import '../core/extension/context_extension.dart';
import '../core/widget/dialog/dialog_factory.dart';
import '../core/init/network/connectivity/network_connectivity.dart';
import '../core/init/cache/location_manager.dart';
import '../models/base_model.dart';
import '../service/in_and_out_service.dart';
import '../view/qr_scanner_view.dart';
import '../core/widget/loader.dart';
import '../widgets/snackbar.dart';
import 'auth_view_model.dart';

class InAndOutViewModel extends BaseViewModel {
  final LocationManager locationManager;
  late final NetworkConnectivity _networkConnectivity;
  late final InAndOutService _inAndOutService;
  late final DeviceInfoManager _deviceInfo;
  late final AuthViewModel _authVM;
  bool isExternal = false;
  TextEditingController lateNoteText = TextEditingController();
  TextEditingController earlyNoteText = TextEditingController();
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  bool isLate = false;
  bool isEarly = false;
  String scannerBarcode = "";
  int type = -1;
  int outSide = 0;

  InAndOutViewModel({
    required this.locationManager,
    NetworkConnectivity? networkConnectivity,
    InAndOutService? inAndOutService,
    DeviceInfoManager? deviceInfo,
    AuthViewModel? authViewModel,
  }) : super() {
    _networkConnectivity =
        networkConnectivity ??
        ServiceLocator.instance.get<NetworkConnectivity>();
    _inAndOutService =
        inAndOutService ?? ServiceLocator.instance.get<InAndOutService>();
    _deviceInfo =
        deviceInfo ?? ServiceLocator.instance.get<DeviceInfoManager>();
    _authVM = authViewModel ?? ServiceLocator.instance.get<AuthViewModel>();
  }

  NetworkConnectivity get networkConnectivity => _networkConnectivity;
  DeviceInfoManager get deviceInfo => _deviceInfo;
  AuthViewModel get authVM => _authVM;

  void buildMethod(BuildContext context) {
    // Provider.of yerine listen: false kullanarak doğrudan erişim
    final authViewModel = Provider.of<AuthViewModel>(context, listen: false);
    // Sadece gerektiğinde notify et
    if (authViewModel.event != _authVM.event) {
      notifyListeners();
    }
  }

  void pressLogin(BuildContext context, GlobalKey<ScaffoldState> scaffoldKey) {
    locationManager.determinePosition(context);

    if (locationManager.currentPosition != null) {
      DialogFactory.create(
        context: context,
        type: DialogType.inAndOut,
        parameters: {
          'content': StringConstants.instance.inText,
          'iconPath': ImageConstants.instance.start,
          'color': context.colorScheme.tertiaryContainer,
          'onPressed': () async {
            Navigator.pop(context);

            if (locationManager.currentPosition != null) {
              if (networkConnectivity.internet) {
                await executeShiftProcedure(
                  type: 1,
                  longitude: locationManager.currentPosition!.longitude,
                  latitude: locationManager.currentPosition!.latitude,
                  deviceId: deviceInfo.deviceId,
                  deviceModel: deviceInfo.deviceModel,
                  context: context,
                  isMockLocation: locationManager.isMockLocation,
                );
              } else {
                CustomSnackBar(
                  context,
                  StringConstants.instance.networkMsg,
                  backgroundColor: context.colorScheme.error,
                );
              }
            }
          },
        },
      );
    } else {
      CustomSnackBar(
        context,
        StringConstants.instance.locationErrorMsg,
        backgroundColor: context.colorScheme.error,
      );
    }
  }

  void pressOut(BuildContext context, GlobalKey<ScaffoldState> scaffoldKey) {
    locationManager.determinePosition(context);

    if (locationManager.currentPosition != null) {
      DialogFactory.create(
        context: context,
        type: DialogType.inAndOut,
        parameters: {
          'content': StringConstants.instance.outText,
          'iconPath': ImageConstants.instance.stop,
          'color': context.colorScheme.primaryContainer,
          'onPressed': () async {
            Navigator.pop(context);

            if (networkConnectivity.internet) {
              await executeShiftProcedure(
                type: 2, // Çıkış
                longitude: locationManager.currentPosition!.longitude,
                latitude: locationManager.currentPosition!.latitude,
                deviceId: deviceInfo.deviceId,
                deviceModel: deviceInfo.deviceModel,
                isMockLocation: locationManager.isMockLocation,
                context: context,
              );
            } else {
              CustomSnackBar(
                context,
                StringConstants.instance.networkMsg,
                backgroundColor: context.colorScheme.error,
              );
            }
          },
        },
      );
    } else {
      CustomSnackBar(
        context,
        StringConstants.instance.locationErrorMsg,
        backgroundColor: context.colorScheme.error,
      );
    }
  }

  Future<BaseModel<Map<String, dynamic>>?> executeShiftProcedure({
    required int type, // 1 = giriş, 2 = çıkış
    required double longitude,
    required double latitude,
    required BuildContext context,
    required bool isMockLocation,
    String? deviceId,
    String? deviceModel,
    String? myNote,
  }) async {
    BaseModel<Map<String, dynamic>>? data;

    // Type'a göre flag'leri sıfırla
    if (type == 1) {
      isLate = false;
    } else {
      isEarly = false;
    }

    if (isMockLocation) {
      DialogFactory.create(
        context: context,
        type: DialogType.locationPermission,
        parameters: {'isEnabled': true, 'isMock': isMockLocation},
      );
      return null;
    }

    Loader.show(context);
    try {
      data = await _inAndOutService.sendShift(
        type: type,
        longitude: longitude,
        latitude: latitude,
        outside: outSide,
        deviceId: deviceId,
        deviceModel: deviceModel,
        myNote: myNote,
      );

      if (!context.mounted) return null;
      Loader.hide();

      if (data.status!) {
        CustomSnackBar(context, data.message!);
      } else {
        if (data.data != null &&
            data.data!['note'] != null &&
            !data.data!['note']) {
          _showNoteDialog(
            context: context,
            type: type,
            longitude: longitude,
            latitude: latitude,
            deviceId: deviceId,
            deviceModel: deviceModel,
            message: data.message!,
          );
        } else {
          CustomSnackBar(
            context,
            data.message!,
            backgroundColor: context.colorScheme.error,
          );
        }
      }
    } catch (e) {
      Loader.hide();
      CustomSnackBar(
        context,
        StringConstants.instance.errorMessage,
        backgroundColor: context.colorScheme.error,
      );
    }

    return data;
  }

  void pressQrArea(BuildContext context, GlobalKey<ScaffoldState> scaffoldKey) {
    if (networkConnectivity.internet) {
      if (locationManager.currentPosition != null) {
        DialogFactory.create(
          context: context,
          type: DialogType.qrTypeSelection,
          parameters: {
            'onInPressed': () {
              Navigator.pop(context);
              openQrScanner(context, 1);
            },
            'onOutPressed': () {
              Navigator.pop(context);
              openQrScanner(context, 2);
            },
          },
        );
      } else {
        CustomSnackBar(
          context,
          StringConstants.instance.locationErrorMsg,
          backgroundColor: context.colorScheme.error,
        );
      }
    } else {
      CustomSnackBar(
        scaffoldKey.currentContext!,
        StringConstants.instance.networkMsg,
        backgroundColor: context.colorScheme.error,
      );
    }
  }

  void openQrScanner(BuildContext context, int selectedType) {
    type = selectedType;

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => QrScannerView(
          onQrScanned: (String qrCode) {
            processQrCode(context, qrCode, selectedType);
          },
        ),
      ),
    );
  }

  Future<void> processQrCode(
    BuildContext context,
    String qrCode,
    int type,
  ) async {
    if (locationManager.currentPosition != null) {
      if (locationManager.isMockLocation) {
        DialogFactory.create(
          context: context,
          type: DialogType.locationPermission,
          parameters: {
            'isEnabled': true,
            'isMock': locationManager.isMockLocation,
          },
        );
        return;
      }

      Loader.show(context);

      try {
        var result = await _inAndOutService.sendQrShift(
          qrStr: qrCode,
          type: type,
          longitude: locationManager.currentPosition!.longitude,
          latitude: locationManager.currentPosition!.latitude,
          deviceId: deviceInfo.deviceId,
          deviceModel: deviceInfo.deviceModel,
        );
        if (!context.mounted) return;
        Loader.hide();
        Navigator.pop(context);

        if (result.status!) {
          CustomSnackBar(context, result.message!);
        } else {
          CustomSnackBar(
            context,
            result.message!,
            backgroundColor: context.colorScheme.error,
          );
        }
      } catch (e) {
        Loader.hide();
        Navigator.pop(context);
        CustomSnackBar(
          context,
          e.toString().contains('Internet')
              ? 'İnternet bağlantısı yok'
              : StringConstants.instance.errorMessage,
          backgroundColor: context.colorScheme.error,
        );
      }
    } else {
      CustomSnackBar(
        context,
        StringConstants.instance.locationErrorMsg,
        backgroundColor: context.colorScheme.error,
      );
    }
  }

  bool isLateInCompany({
    required BuildContext context,
    required AuthViewModel authVM,
  }) {
    String startDate = authVM.startTDate ?? "";
    if (startDate.isNotEmpty) {
      List<String> parts = startDate.split(":");
      int toleranceHour = int.parse(parts[0]);
      int toleranceMinute = int.parse(parts[1]);
      int localeHour = DateTime.now().hour;
      int localeMinute = DateTime.now().minute;

      if (toleranceHour == localeHour) {
        if (toleranceMinute <= localeMinute) {
          return true;
        }
      } else if (toleranceHour < localeHour) {
        return true;
      }
    }
    return false;
  }

  bool isEarlyOutCompany({
    required BuildContext context,
    required AuthViewModel authVM,
  }) {
    String endDate = authVM.endTDate ?? "";
    if (endDate.isNotEmpty) {
      List<String> parts = endDate.split(":");
      int toleranceHour = int.parse(parts[0]);
      int toleranceMinute = int.parse(parts[1]);
      int localeHour = DateTime.now().hour;
      int localeMinute = DateTime.now().minute;

      if (toleranceHour == localeHour) {
        if (toleranceMinute >= localeMinute) {
          return true;
        }
      } else if (toleranceHour > localeHour) {
        return true;
      }
    }
    return false;
  }

  @override
  void disp() {}

  @override
  void init() {}

  void updateLocationManager(LocationManager newLocationManager) {
    // Location manager referansını güncelle
    // Bu metod provider tarafından çağrılır
    // Sadece gerektiğinde notify eder
    if (locationManager != newLocationManager) {
      notifyListeners();
    }
  }

  void _showNoteDialog({
    required BuildContext context,
    required int type,
    required double longitude,
    required double latitude,
    required String message,
    String? deviceId,
    String? deviceModel,
  }) {
    final isLateEntry = type == 1;
    final controller = isLateEntry ? lateNoteText : earlyNoteText;

    DialogFactory.create(
      context: context,
      type: DialogType.illegal,
      parameters: {
        'scaffoldKey': scaffoldKey,
        'inAndOutViewModel': this,
        'titleText': isLateEntry
            ? StringConstants.instance.confirmText
            : StringConstants.instance.confirmText2,
        'excuseText': isLateEntry
            ? StringConstants.instance.lateDescription
            : StringConstants.instance.earlyDescription,
        'cancelText': isLateEntry
            ? StringConstants.instance.cancelText
            : StringConstants.instance.cancelText2,
        'controller': controller,
        'message': message,
        'deviceInfo': deviceInfo,
        'situation': isLateEntry
            ? AlertCapabilitySituation.lateInEvent
            : AlertCapabilitySituation.earlyOutEvent,
        'longitude': longitude,
        'latitude': latitude,
        'type': type,
        'deviceId': deviceId,
        'deviceModel': deviceModel,
      },
    );
  }

  void handleNoteSubmission({
    required BuildContext context,
    required int type,
    required String note,
  }) async {
    if (note.isEmpty || note.length < 5) {
      CustomSnackBar(
        context,
        StringConstants.instance.dialogAlertDescription,
        backgroundColor: context.colorScheme.error,
      );
      return;
    }
    Loader.show(context);

    try {
      var data = await _inAndOutService.sendShift(
        type: type,
        longitude: locationManager.currentPosition!.longitude,
        latitude: locationManager.currentPosition!.latitude,
        outside: outSide,
        deviceId: deviceInfo.deviceId,
        deviceModel: deviceInfo.deviceModel,
        myNote: note,
      );

      Loader.hide();
      BuildContext? targetContext = context.mounted
          ? context
          : scaffoldKey.currentContext;

      if (targetContext == null) {
        return;
      }
      if (!targetContext.mounted) return;
      if (data.status!) {
        CustomSnackBar(targetContext, data.message ?? StringConstants.instance.successMessage);
      } else {
        CustomSnackBar(
          targetContext,
          data.message ?? 'Bilinmeyen hata',
          backgroundColor: targetContext.colorScheme.error,
        );
      }
    } catch (e) {
      Loader.hide();
      if (context.mounted) {
        CustomSnackBar(
          context,
          StringConstants.instance.errorMessage,
          backgroundColor: context.colorScheme.error,
        );
      }
    }
  }
}
