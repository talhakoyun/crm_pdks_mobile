import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

import '../core/base/view_model/base_view_model.dart';
import '../core/constants/device_constants.dart';
import '../core/constants/image_constants.dart';
import '../core/constants/size_config.dart';
import '../core/constants/string_constants.dart';
<<<<<<< Updated upstream
import '../core/enums/alert_capability_situation.dart';
import '../core/extension/context_extension.dart';
=======
import '../core/constants/service_locator.dart';
import '../core/enums/enums.dart';
import '../core/init/theme/theme_extensions.dart';
import '../core/widget/dialog/dialog_factory.dart';
>>>>>>> Stashed changes
import '../core/init/network/connectivity/network_connectivity.dart';
import '../models/last_event_model.dart';
import '../service/in_and_out_service.dart';
import '../view/qr_scanner_view.dart';
import '../widgets/dialog/custom_dialog.dart';
import '../widgets/dialog/custom_illegal_dialog.dart';
import '../widgets/dialog/custom_loader.dart';
import '../widgets/dialog/snackbar.dart';
import 'auth_view_model.dart';

class InAndOutViewModel extends BaseViewModel {
  NetworkConnectivity networkConnectivity = NetworkConnectivity();
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
          Navigator.pop(context); // Dialog'u kapat

          if (location.currentPosition != null) {
            if (networkConnectivity.internet) {
              await executeShiftProcedure(
                type: 1, // Giriş
                longitude: location.currentPosition!.longitude,
                latitude: location.currentPosition!.latitude,
                deviceId: deviceInfo.deviceId,
                deviceModel: deviceInfo.deviceModel,
                context: context,
                isMockLocation: location.isMockLocation,
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
        situation: AlertCapabilitySituation.lateInEvent,
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
          Navigator.pop(context); // Dialog'u kapat

          if (networkConnectivity.internet) {
            await executeShiftProcedure(
              type: 2, // Çıkış
              longitude: location.currentPosition!.longitude,
              latitude: location.currentPosition!.latitude,
              deviceId: deviceInfo.deviceId,
              deviceModel: deviceInfo.deviceModel,
              isMockLocation: location.isMockLocation,
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
        situation: AlertCapabilitySituation.earlyOutEvent,
      );
    }
  }

  Future<dynamic> executeShiftProcedure({
    required int type, // 1 = giriş, 2 = çıkış
    required double longitude,
    required double latitude,
    required BuildContext context,
    required bool isMockLocation,
    String? deviceId,
    String? deviceModel,
    String? myNote,
  }) async {
    dynamic data;

    // Type'a göre flag'leri sıfırla
    if (type == 1) {
      isLate = false;
    } else {
      isEarly = false;
    }

    if (isMockLocation) {
      CustomAlertDialog.locationPermissionAlert(
        context: context,
        isEnabled: true,
        isMock: isMockLocation,
      );
      return null;
    }

    CustomLoader.showAlertDialog(context);
    try {
      data = await inAndOutService.sendShift(
        type: type,
        longitude: longitude,
        latitude: latitude,
        outside: outSide,
        deviceId: deviceId,
        deviceModel: deviceModel,
        myNote: myNote,
      );

      if (!context.mounted) return;
      Navigator.pop(context);

      if (data['status']) {
        CustomSnackBar(context, data['message']);
      } else {
        if (data['note'] != null && !data['note']) {
          if (type == 1) {
            isLate = true;
          } else {
            isEarly = true;
          }
          CustomSnackBar(
            context,
            data['message'],
            backgroundColor: context.colorScheme.error,
          );
        } else {
          CustomSnackBar(
            context,
            data['message'],
            backgroundColor: context.colorScheme.error,
          );
        }
      }
    } catch (e) {
      Navigator.pop(context);
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
      if (location.currentPosition != null) {
        // QR işlem türü seçim popup'ı göster
        showQrTypeSelectionDialog(context);
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

  void showQrTypeSelectionDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            "İşlem Seçimi",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: context.colorScheme.onSurface,
            ),
          ),
          content: Text(
            "Yapmak istediğiniz işlemi seçin",
            style: TextStyle(
              fontSize: 16,
              color: context.colorScheme.onSurface,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                // Giriş yap (type: 1)
                openQrScanner(context, 1);
              },
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: context.colorScheme.tertiaryContainer,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  "Giriş Yap",
                  style: TextStyle(
                    color: context.colorScheme.onTertiaryContainer,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                // Çıkış yap (type: 2)
                openQrScanner(context, 2);
              },
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: context.colorScheme.errorContainer,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  "Çıkış Yap",
                  style: TextStyle(
                    color: context.colorScheme.onErrorContainer,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  void openQrScanner(BuildContext context, int selectedType) {
    type = selectedType; // Seçilen type'ı sakla

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => QrScannerView(
          onQrScanned: (String qrCode) {
            // QR kod okunduktan sonra API'ye gönder
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
    if (location.currentPosition != null) {
      if (location.isMockLocation) {
        CustomAlertDialog.locationPermissionAlert(
          context: context,
          isEnabled: true,
          isMock: location.isMockLocation,
        );
        return;
      }

      CustomLoader.showAlertDialog(context);

      try {
        var result = await inAndOutService.sendQrShift(
          qrStr: qrCode,
          type: type,
          longitude: location.currentPosition!.longitude,
          latitude: location.currentPosition!.latitude,
          deviceId: deviceInfo.deviceId,
          deviceModel: deviceInfo.deviceModel,
        );
        if (!context.mounted) return;
        Navigator.pop(context);
        Navigator.pop(context);

        if (result['status']) {
          CustomSnackBar(context, result['message']);
        } else {
          CustomSnackBar(
            context,
            result['message'],
            backgroundColor: context.colorScheme.error,
          );
        }
      } catch (e) {
        Navigator.pop(context);
        Navigator.pop(context);
        CustomSnackBar(
          context,
          StringConstants.instance.errorMessage,
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
