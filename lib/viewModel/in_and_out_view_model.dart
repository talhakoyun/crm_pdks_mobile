// ignore_for_file: use_build_context_synchronously,

import 'package:crm_pdks_mobile/core/constants/size_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';

import '../core/base/view_model/base_view_model.dart';
import '../core/constants/device_constants.dart';
import '../core/constants/image_constants.dart';
import '../core/constants/string_constants.dart';
import '../core/extension/context_extension.dart';
import '../core/init/network/connectivity/network_connectivity.dart';
import '../models/last_event_model.dart';
import '../service/in_and_out_service.dart';
import '../view/home_view.dart';
import '../widgets/dialog/custom_dialog.dart';
import '../widgets/dialog/custom_illegal_dialog.dart';
import '../widgets/dialog/custom_loader.dart';
import '../widgets/dialog/snackbar.dart';
import 'auth_view_model.dart';

class InAndOutViewModel extends BaseViewModel {
  NetworkConnectivity networkConnectivity = NetworkConnectivity();
  static const platform = MethodChannel('samples.mavihost/mockTime');
  bool isExternal = false;
  TextEditingController lateNoteText = TextEditingController();
  TextEditingController earlyNoteText = TextEditingController();
  final inAndOutService = InAndOutService();
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  bool isLate = false;
  bool isEarly = false;
  String scannerBarcode = "";
  int type = -1;
  int outSide = 0;
  LastEventModel? model;
  DeviceInfoManager deviceInfo = DeviceInfoManager();
  AuthViewModel authVM = AuthViewModel();

  void buildMethod(BuildContext context) {
    context.watch<AuthViewModel>();
    notifyListeners();
  }

  void pressLogin(BuildContext context, GlobalKey<ScaffoldState> scaffoldKey) {
    location.determinePosition(context);
    if (location.currentPosition != null) {
      showInAndOutDialog(
        context: context,
        content: StringConstants.instance.inText,
        iconPath: ImageConstants.instance.start,
        color: context.colorScheme.tertiaryContainer,
        onPressed: () async {
          if (location.currentPosition != null) {
            if (networkConnectivity.internet) {
              await inProcedure(
                longitude: location.currentPosition!.longitude,
                latitude: location.currentPosition!.latitude,
                deviceId: deviceInfo.deviceId,
                deviceModel: deviceInfo.deviceModel,
                context: scaffoldKey.currentContext!,
                isMockLocation: location.isMockLocation,
              );
              context.navigationOf.pop();
            } else {
              context.navigationOf.pop();
              CustomSnackBar(
                scaffoldKey.currentContext!,
                StringConstants.instance.networkMsg,
                backgroundColor: context.colorScheme.error,
              );
            }
          }
        },
      );
    } else {
      CustomSnackBar(
        context,
        StringConstants.instance.locationErrorMsg,
        backgroundColor: context.colorScheme.error,
      );
    }

    if (isLate) {
      CustomIllegalDialog.instance.showIllegalDialog(
        context: context,
        scaffoldKey: GlobalKey<ScaffoldState>(),
        locationManager: location,
        titleText: StringConstants.instance.confirmText,
        excuseText: StringConstants.instance.lateDescription,
        cancelText: StringConstants.instance.cancelText,
        controller: lateNoteText,
        message: StringConstants.instance.successMessage,
        deviceInfo: deviceInfo,
        situation: AlertCabilitySituation.lateInEvent,
      );
    }
  }

  void pressOut(BuildContext context, GlobalKey<ScaffoldState> scaffoldKey) {
    location.determinePosition(context);
    if (location.currentPosition != null) {
      showInAndOutDialog(
        context: context,
        content: StringConstants.instance.outText,
        iconPath: ImageConstants.instance.stop,
        color: context.colorScheme.errorContainer,
        onPressed: () async {
          if (networkConnectivity.internet) {
            await outProcedure(
              longitude: location.currentPosition!.longitude,
              latitude: location.currentPosition!.latitude,
              deviceId: deviceInfo.deviceId,
              deviceModel: deviceInfo.deviceModel,
              isMockLocation: location.isMockLocation,
              context: scaffoldKey.currentContext!,
            );
            context.navigationOf.pop();
          } else {
            context.navigationOf.pop();
            CustomSnackBar(
              scaffoldKey.currentContext!,
              StringConstants.instance.networkMsg,
              backgroundColor: context.colorScheme.error,
            );
          }
        },
      );
    } else {
      CustomSnackBar(
        context,
        StringConstants.instance.locationErrorMsg,
        backgroundColor: context.colorScheme.error,
      );
    }

    if (isEarly) {
      CustomIllegalDialog.instance.showIllegalDialog(
        context: context,
        scaffoldKey: GlobalKey<ScaffoldState>(),
        locationManager: location,
        titleText: StringConstants.instance.confirmText2,
        excuseText: StringConstants.instance.earlyDescription,
        cancelText: StringConstants.instance.cancelText2,
        controller: earlyNoteText,
        message: 'message',
        deviceInfo: deviceInfo,
        situation: AlertCabilitySituation.earlyOutEvent,
      );
    }
  }

  Future<dynamic> inProcedure({
    required double longitude,
    required double latitude,
    required BuildContext context,
    required bool isMockLocation,
    String? deviceId,
    String? deviceModel,
    String? myNote,
  }) async {
    dynamic data;
    isLate = false;

    if (isMockLocation) {
      CustomAlertDialog.locationPermissionAlert(
        context: context,
        isEnabled: true,
        isMock: isMockLocation,
      );
    } else {
      CustomLoader.showAlertDialog(context);

      data = await inAndOutService.sendShift(
        type: 1,
        longitude: longitude,
        latitude: latitude,
        outside: outSide,
        deviceId: deviceId,
        deviceModel: deviceModel,
        myNote: myNote,
      );

      if (data['status']) {
        Navigator.pop(context);
        CustomSnackBar(context, data['message']);
      } else if (data != null && !data['status']) {
        if (data['note'] != null && !data['note']) {
          Navigator.pop(context);
          isLate = true;
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => const HomeView()),
            (Route<dynamic> route) => false,
          );
        } else {
          Navigator.pop(context);
          CustomSnackBar(context, data['message']);
        }
      }
    }

    data = await inAndOutService.sendShift(
      type: 1,
      longitude: longitude,
      latitude: latitude,
      outside: outSide,
      deviceId: deviceId,
      deviceModel: deviceModel,
      myNote: myNote,
    );
    Navigator.pop(context);

    if (data['status']) {
      CustomSnackBar(context, data['message']);
    } else {
      if (data['note'] != null && !data['note']) {
        isLate = true;
        CustomSnackBar(context, data['message']);
      } else {
        CustomSnackBar(context, data['message']);
      }
    }
    return data;
  }

  Future<dynamic> outProcedure({
    required double longitude,
    required double latitude,
    required BuildContext context,
    String? deviceId,
    String? deviceModel,
    String? myNote,
    required bool isMockLocation,
  }) async {
    dynamic data;
    isEarly = false;

    if (isMockLocation) {
      CustomAlertDialog.locationPermissionAlert(
        context: context,
        isEnabled: true,
        isMock: isMockLocation,
      );
    } else {
      CustomLoader.showAlertDialog(context);

      data = await inAndOutService.sendShift(
        type: 2,
        longitude: longitude,
        latitude: latitude,
        outside: outSide,
        deviceId: deviceId,
        deviceModel: deviceModel,
        myNote: myNote,
      );

      if (data['status'] != null && data['status']) {
        Navigator.pop(context);
        CustomSnackBar(context, data['message']);
      } else {
        if (data['note'] != null && !data['note']) {
          Navigator.pop(context);
          isEarly = true;
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => const HomeView()),
            (Route<dynamic> route) => false,
          );
        } else {
          Navigator.pop(context);
          CustomSnackBar(context, data['message']);
        }
      }
    }
    return data;
  }

  void pressQrArea(BuildContext context, GlobalKey<ScaffoldState> scaffoldKey) {
    if (networkConnectivity.internet) {
      if (location.currentPosition != null) {
        // QR kod okuma işlemi buraya gelecek
        scanQR(context, location.currentPosition!);
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

  Future<void> qrCodeScanner(BuildContext context) async {
    if (networkConnectivity.internet) {
      if (location.currentPosition != null) {
        await qrShiftSend(
          longitude: location.currentPosition!.longitude,
          latitude: location.currentPosition!.latitude,
          zoneId: int.parse(scannerBarcode),
          context: context,
          deviceId: deviceInfo.deviceId,
          deviceModel: deviceInfo.deviceModel,
          isMockLocation: location.isMockLocation,
        );
      }
    } else {
      CustomSnackBar(
        context,
        StringConstants.instance.networkMsg,
        backgroundColor: context.colorScheme.error,
      );
    }
  }

  void scanQR(BuildContext context, Position position) async {
    if (scannerBarcode == "-1") {
      CustomSnackBar(
        context,
        StringConstants.instance.qrErrorMsg,
        backgroundColor: context.colorScheme.error,
      );
    } else {
      try {
        await qrShiftSend(
          longitude: position.longitude,
          latitude: position.latitude,
          zoneId: int.parse(scannerBarcode),
          context: context,
          deviceId: deviceInfo.deviceId,
          deviceModel: deviceInfo.deviceModel,
          isMockLocation: location.isMockLocation,
        );

        if (networkConnectivity.internet) {
          var sendQrShift = await inAndOutService.sendQrShift(
            type: 3,
            longitude: position.longitude,
            latitude: position.latitude,
            zoneId: int.parse(scannerBarcode),
            deviceId: deviceInfo.deviceId,
            deviceModel: deviceInfo.deviceModel,
          );

          if (sendQrShift["status"]) {
            CustomSnackBar(context, sendQrShift["message"]);
          } else {
            CustomSnackBar(context, sendQrShift["message"]);
          }
        } else {
          CustomSnackBar(
            context,
            StringConstants.instance.networkMsg,
            backgroundColor: context.colorScheme.error,
          );
        }
      } catch (e) {
        CustomSnackBar(
          context,
          StringConstants.instance.qrErrorMsg,
          backgroundColor: context.colorScheme.error,
        );
      }
    }
  }

  Future<dynamic> qrShiftSend({
    required double longitude,
    required double latitude,
    required int zoneId,
    required BuildContext context,
    String? deviceId,
    String? deviceModel,
    String? myNote,
    required bool isMockLocation,
  }) async {
    dynamic data;
    isEarly = false;

    if (isMockLocation) {
      CustomAlertDialog.locationPermissionAlert(
        context: context,
        isEnabled: true,
        isMock: isMockLocation,
      );
    } else {
      CustomLoader.showAlertDialog(context);

      data = await inAndOutService.sendQrShift(
        type: 3,
        longitude: longitude,
        latitude: latitude,
        zoneId: zoneId,
        deviceId: deviceId,
        deviceModel: deviceModel,
      );

      if (data['status'] != null && data['status']) {
        Navigator.pop(context);
        CustomSnackBar(context, data['message']);
      } else {
        if (data['note'] != null && !data['note']) {
          Navigator.pop(context);
          isEarly = true;
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => const HomeView()),
            (Route<dynamic> route) => false,
          );
        } else {
          Navigator.pop(context);
          CustomSnackBar(context, data['message']);
        }
      }
    }
    return data;
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

  void showInAndOutDialog({
    required BuildContext context,
    required String content,
    required String iconPath,
    required Color color,
    required VoidCallback onPressed,
  }) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: context.colorScheme.onError,
          titleTextStyle: context.textTheme.titleLarge,
          title: Text(content, textAlign: TextAlign.center),
          actionsAlignment: MainAxisAlignment.center,
          alignment: Alignment.center,
          content: Padding(
            padding: context.paddingLow,
            child: SvgPicture.asset(
              fit: BoxFit.contain,
              colorFilter: ColorFilter.mode(
                context.colorScheme.tertiaryContainer,
                BlendMode.srcIn,
              ),
              ImageConstants.instance.start,
              width: SizeConfig.instance.widthSize(context, 5),
              height: SizeConfig.instance.heightSize(context, 35),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(StringConstants.instance.cancelButtonText),
            ),
            TextButton(
              onPressed: onPressed,
              child: Text(StringConstants.instance.okey),
            ),
          ],
        );
      },
    );
  }

  @override
  void disp() {}

  @override
  void init() {}
}
