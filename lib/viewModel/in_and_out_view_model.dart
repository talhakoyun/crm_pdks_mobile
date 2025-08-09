// ignore_for_file: use_build_context_synchronously,

import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';

import '../core/base/view_model/base_view_model.dart';
import '../core/constants/device_constants.dart';
import '../core/constants/image_constants.dart';
import '../core/constants/string_constants.dart';
import '../core/extension/context_extension.dart';
import '../core/init/cache/locale_manager.dart';
import '../core/init/network/connectivity/network_connectivity.dart';
import '../helper/database_controller.dart';
import '../models/last_event_model.dart';
import '../models/offline_qr_model.dart';
import '../models/offline_userdata_model.dart';
import '../models/qr_model.dart';
import '../service/in_and_out_service.dart';
import '../view/home_view.dart';
import '../widgets/dialog/custom_dialog.dart';
import '../widgets/dialog/custom_illegal_dialog.dart';
import '../widgets/dialog/custom_inAndout_dialog.dart';
import '../widgets/dialog/custom_loader.dart';
import '../widgets/dialog/custom_mock_time_alert_dialog.dart';
import '../widgets/dialog/mock_status_dialog.dart';
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
  DataBaseController dataBaseController = DataBaseController();
  AuthViewModel authVM = AuthViewModel();

  void buildMethod(BuildContext context) {
    context.watch<AuthViewModel>();
    if ((networkConnectivity.internet)) {
      if (location.currentPosition != null) {
        dataBaseController.fetchIndata().then((value) {
          if (!(location.isMockLocation)) {
            value.forEach((element) async {
              OfflineUserModel dataModel;
              dataModel = OfflineUserModel.fromMap(element);
              debugPrint(dataModel.inTime);
              var data = await inProcedure(
                longitude: dataModel.longitude!,
                latitude: dataModel.latitude,
                context: context,
                isMockLocation: location.isMockLocation,
                offline: DateTime.parse(dataModel.inTime!),
                deviceId: deviceInfo.deviceId,
                deviceModel: deviceInfo.deviceModel,
                myNote: dataModel.lateReason,
              );
              debugPrint("biri  eklendi");
              debugPrint("$data");

              if (data['status'] ||
                  data['duplicate'] == true ||
                  data['message'] ==
                      StringConstants.instance.locationErrorMsg ||
                  data['message'] == StringConstants.instance.inErrorMessage) {
                dataBaseController.updateInAndOutdata({
                  "isUpload": 1,
                }, dataModel.id!);
              }
            });
          }
        });
        dataBaseController.fetchOutdata().then((value) {
          if (!(location.isMockLocation)) {
            value.forEach((element) async {
              OfflineUserModel dataModel;
              dataModel = OfflineUserModel.fromMap(element);
              debugPrint(dataModel.inTime);
              var data = await outProcedure(
                longitude: dataModel.longitude!,
                latitude: dataModel.latitude,
                context: context,
                deviceId: deviceInfo.deviceId,
                deviceModel: deviceInfo.deviceModel,
                isMockLocation: location.isMockLocation,
                offline: DateTime.parse(dataModel.outTime!),
                myNote: dataModel.earlyReason,
              );
              debugPrint("bir out procedure  eklendi");
              debugPrint("$data");

              if (data['status'] ||
                  data['duplicate'] == true ||
                  data['message'] ==
                      StringConstants.instance.locationErrorMsg ||
                  data['message'] == StringConstants.instance.outErrorMessage) {
                dataBaseController.updateInAndOutdata({
                  "isUpload": 1,
                }, dataModel.id!);
              }
            });
          }
        });
        dataBaseController.fetchQrdata().then((value) {
          if (!(location.isMockLocation)) {
            value.forEach((element) async {
              OfflineQrModel qrDataModel;
              qrDataModel = OfflineQrModel.fromMap(element);
              debugPrint(qrDataModel.processTime);
              var sendQrShift = await inAndOutService.sendQrShift(
                type: 3,
                longitude: qrDataModel.longitude!,
                latitude: qrDataModel.latitude,
                zoneId: qrDataModel.zone!,
                deviceId: deviceInfo.deviceId,
                deviceModel: deviceInfo.deviceModel,
                offline: DateTime.parse(qrDataModel.processTime!),
              );
              debugPrint("bir qr procedure  eklendi");
              debugPrint("$sendQrShift");

              if (qrDataModel.id != element['id'] ||
                  sendQrShift['status'] ||
                  sendQrShift['message'] ==
                      StringConstants.instance.successMessage.toLowerCase() ||
                  sendQrShift['message'].toLowerCase().trim() ==
                      StringConstants.instance.qrErrorMsg
                          .toLowerCase()
                          .trim()) {
                dataBaseController.updateQrData({
                  "isQRUpload": 1,
                }, qrDataModel.id!);
              }
            });
          }
        });
      }
    }
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
              if (Platform.isIOS) {
                context.navigationOf.pop();
                CustomSnackBar(
                  scaffoldKey.currentContext!,
                  StringConstants.instance.noOffMode,
                  backgroundColor: context.colorScheme.error,
                );
              } else {
                bool timeIsCurrect = await MockStatusDialog.instance
                    .getMockStatus(platform);
                if (timeIsCurrect) {
                  CustomMockTimeDialog.instance.showMockTimeAlert(
                    context: context,
                  );
                } else {
                  Navigator.pop(context);
                  bool ouTSide = outSide == 0 ? false : true;
                  if (((localeManager.getBoolValue(PreferencesKeys.OFFLINE) ==
                              true) &&
                          (localeManager.getBoolValue(
                                PreferencesKeys.OUTSIDE,
                              ) ==
                              false)) ||
                      ((localeManager.getBoolValue(PreferencesKeys.OFFLINE) ==
                              true) &&
                          (localeManager.getBoolValue(
                                PreferencesKeys.OUTSIDE,
                              ) ==
                              ouTSide))) {
                    if (isLateInCompany(
                      context: context,
                      authController: authVM,
                    )) {
                      CustomIllegalDialog.instance.showIllegalDialog(
                        scaffoldKey: scaffoldKey,
                        locationManager: location,
                        context: context,
                        titleText: StringConstants.instance.lateText,
                        excuseText: StringConstants.instance.lateDescription,
                        cancelText: StringConstants.instance.cancelText,
                        controller: lateNoteText,
                        message: StringConstants.instance.successMessage,
                        deviceInfo: deviceInfo,
                        situation: AlertCabilitySituation.offlineInEvent,
                      );
                    } else {
                      dataBaseController.insertDatabase(
                        userdataModel: OfflineUserModel(
                          earlyReason: null,
                          lateReason: null,
                          inTime: DateTime.now().toString(),
                          outTime: "0",
                          isOutSide: outSide.toString(),
                          latitude: location.currentPosition!.latitude,
                          longitude: location.currentPosition!.longitude,
                          isUpload: 0,
                        ),
                        context: context,
                      );
                    }
                  } else {
                    CustomSnackBar(
                      context,
                      StringConstants.instance.offModeDialog,
                      backgroundColor: context.colorScheme.error,
                    );
                  }
                }
              }
            }
          } else {
            Navigator.pop(context);
            CustomSnackBar(
              scaffoldKey.currentContext!,
              StringConstants.instance.locationError,
              backgroundColor: context.colorScheme.error,
            );
          }
        },
      ).whenComplete(() {
        if (isLate) {
          CustomIllegalDialog.instance.showIllegalDialog(
            scaffoldKey: scaffoldKey,
            locationManager: location,
            context: context,
            titleText: StringConstants.instance.lateText,
            excuseText: StringConstants.instance.lateDescription,
            cancelText: StringConstants.instance.cancelText,
            controller: lateNoteText,
            message: StringConstants.instance.successMessage,
            deviceInfo: deviceInfo,
            situation: AlertCabilitySituation.onlineInEvent,
          );
        }
        isLate = false;
      });
    } else {
      CustomSnackBar(
        context,
        StringConstants.instance.locationError,
        backgroundColor: context.colorScheme.error,
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
        color: context.colorScheme.primaryContainer,
        onPressed: () async {
          if (networkConnectivity.internet) {
            await outProcedure(
              longitude: location.currentPosition!.longitude,
              latitude: location.currentPosition!.latitude,
              context: scaffoldKey.currentContext!,
              isMockLocation: location.isMockLocation,
              deviceId: deviceInfo.deviceId,
              deviceModel: deviceInfo.deviceModel,
            );
            Navigator.pop(context);
          } else {
            if (Platform.isIOS) {
              Navigator.pop(context);
              CustomSnackBar(
                scaffoldKey.currentContext!,
                StringConstants.instance.noOffMode,
                backgroundColor: context.colorScheme.error,
              );
            } else {
              bool timeIsCurrect = await MockStatusDialog.instance
                  .getMockStatus(platform);
              if (timeIsCurrect) {
                CustomMockTimeDialog.instance.showMockTimeAlert(
                  context: context,
                );
              } else {
                Navigator.pop(context);
                bool ouTSide = outSide == 0 ? false : true;
                if (((localeManager.getBoolValue(PreferencesKeys.OFFLINE) ==
                            true) &&
                        (localeManager.getBoolValue(PreferencesKeys.OUTSIDE) ==
                            false)) ||
                    ((localeManager.getBoolValue(PreferencesKeys.OFFLINE) ==
                            true) &&
                        (localeManager.getBoolValue(PreferencesKeys.OUTSIDE) ==
                            ouTSide))) {
                  if (isEarlyOutCompany(context: context, authVM: authVM)) {
                    CustomIllegalDialog.instance.showIllegalDialog(
                      scaffoldKey: scaffoldKey,
                      locationManager: location,
                      context: context,
                      titleText: StringConstants.instance.earlyText,
                      excuseText: StringConstants.instance.earlyDescription,
                      cancelText: StringConstants.instance.cancelText2,
                      controller: earlyNoteText,
                      message: 'message',
                      deviceInfo: deviceInfo,
                      situation: AlertCabilitySituation.offlineOutEvent,
                    );
                  } else {
                    dataBaseController.insertDatabase(
                      userdataModel: OfflineUserModel(
                        earlyReason: null,
                        lateReason: null,
                        inTime: "0",
                        outTime: DateTime.now().toString(),
                        isOutSide: outSide.toString(),
                        latitude: location.currentPosition!.latitude,
                        longitude: location.currentPosition!.longitude,
                        isUpload: 0,
                      ),
                      context: context,
                    );
                  }

                  CustomSnackBar(
                    scaffoldKey.currentContext!,
                    StringConstants.instance.successMessage2,
                  );
                } else {
                  CustomSnackBar(
                    context,
                    StringConstants.instance.offModeDialog,
                    backgroundColor: context.colorScheme.error,
                  );
                }
              }
            }
          }
        },
      ).whenComplete(() {
        if (isEarly) {
          CustomIllegalDialog.instance.showIllegalDialog(
            scaffoldKey: scaffoldKey,
            locationManager: location,
            context: context,
            titleText: StringConstants.instance.earlyText,
            excuseText: StringConstants.instance.earlyDescription,
            cancelText: StringConstants.instance.cancelText2,
            controller: earlyNoteText,
            message: 'message',
            deviceInfo: deviceInfo,
            situation: AlertCabilitySituation.onlineOutEvent,
          );
          isEarly = false;
        }
      });
    } else {
      CustomSnackBar(
        context,
        StringConstants.instance.locationError,
        backgroundColor: context.colorScheme.error,
      );
    }
  }

  Future<dynamic> inProcedure({
    required double longitude,
    required double latitude,
    required BuildContext context,
    required bool isMockLocation,
    DateTime? offline,
    String? deviceId,
    String? deviceModel,
    String? myNote,
    Map<String, dynamic>? oflfineData,
  }) async {
    dynamic data;
    isLate = false;
    if (myNote == null) {
      if (isMockLocation) {
        CustomAlertDialog.locationPermissionAlert(
          context: context,
          isEnabled: true,
          isMock: isMockLocation,
        );
      } else {
        if (offline == null) {
          CustomLoader.showAlertDialog(context);
        }

        data = await inAndOutService.sendShift(
          type: 1,
          longitude: longitude,
          latitude: latitude,
          outside: outSide,
          deviceId: deviceId,
          deviceModel: deviceModel,
          myNote: myNote,
          offline: offline,
        );
        if (offline == null) {
          if (data['status']) {
            Navigator.pop(context);
            CustomSnackBar(context, data['message']);
          } else if (data != null && !data['status']) {
            if (data['note'] != null && !data['note']) {
              isLate = true;
              Navigator.pop(context);
            } else {
              Navigator.pop(context);
              CustomSnackBar(
                context,
                data['message'],
                backgroundColor: context.colorScheme.error,
              );
            }
          }
        }
      }
    } else {
      CustomLoader.showAlertDialog(context);
      data = await inAndOutService.sendShift(
        type: 1,
        longitude: longitude,
        latitude: latitude,
        outside: outSide,
        offline: offline,
        deviceId: deviceId,
        deviceModel: deviceModel,
        myNote: myNote,
      );
      Navigator.pop(context);
      if (data['status']) {
        isLate = false;

        CustomSnackBar(context, data['message']);
      } else if (data != null && !data['status']) {
        if (data['note'] != null && !data['note']) {
          isLate = true;
        } else {
          CustomSnackBar(
            context,
            data['message'],
            backgroundColor: context.colorScheme.error,
          );
        }
      }
    }
    return data;
  }

  Future<dynamic> outProcedure({
    required double longitude,
    required double latitude,
    required BuildContext context,
    String? deviceId,
    DateTime? offline,
    String? deviceModel,
    String? myNote,
    required bool isMockLocation,
    Map<String, dynamic>? offlineData,
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
      if (offline == null) {
        CustomLoader.showAlertDialog(context);
      }
      data = await inAndOutService.sendShift(
        type: 2,
        longitude: longitude,
        latitude: latitude,
        outside: outSide,
        deviceId: deviceId,
        deviceModel: deviceModel,
        myNote: myNote,
      );
      if (offline == null) {
        if (data['status'] != null && data['status']) {
          Navigator.pop(context);
          CustomSnackBar(context, data['message']);
        } else if (data != null && !data['status']) {
          if (data['note'] != null && !data['note']) {
            isEarly = true;
            Navigator.pop(context);
          } else {
            Navigator.pop(context);
            CustomSnackBar(
              context,
              data['message'],
              backgroundColor: context.colorScheme.error,
            );
          }
        } else if (data['status']) {
          CustomSnackBar(context, StringConstants.instance.outSuccessMessage);
        }
      }
    }

    return data;
  }

  // region QR
  void pressQrArea(
    BuildContext context,
    GlobalKey<ScaffoldState> scaffoldKey,
  ) async {
    location.determinePosition(context);
    if (networkConnectivity.internet) {
      if (location.currentPosition != null) {
        // scanQR(context, location.currentPosition!);
        debugPrint("ScanQR");
      } else {
        CustomSnackBar(
          scaffoldKey.currentContext!,
          StringConstants.instance.locationError,
          backgroundColor: context.colorScheme.error,
        );
      }
    } else {
      if (Platform.isIOS) {
        context.navigationOf.pop();
        CustomSnackBar(
          scaffoldKey.currentContext!,
          StringConstants.instance.noOffMode,
          backgroundColor: context.colorScheme.error,
        );
      } else {
        bool timeIsCurrect = await MockStatusDialog.instance.getMockStatus(
          platform,
        );
        if (timeIsCurrect) {
          CustomMockTimeDialog.instance.showMockTimeAlert(context: context);
        } else {
          if (location.currentPosition != null) {
            if (((localeManager.getBoolValue(PreferencesKeys.OFFLINE) ==
                    true) &&
                (localeManager.getBoolValue(PreferencesKeys.ZONE) == true))) {
              // scanQR(context, location.currentPosition!);
              debugPrint("ScanQR");
            } else {
              CustomSnackBar(
                context,
                StringConstants.instance.offModeandQrAreaDialog,
                backgroundColor: context.colorScheme.error,
              );
            }
          } else {
            CustomSnackBar(
              scaffoldKey.currentContext!,
              StringConstants.instance.locationError,
              backgroundColor: context.colorScheme.error,
            );
          }
        }
      }
    }
  }

  // Future<void> scanQR(BuildContext context, Position position) async {
  //   String barcodeScanRes;

  //   try {
  //     barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
  //       '#ff6666',
  //       'Vazgeç',
  //       true,
  //       ScanMode.QR,
  //     );
  //     debugPrint(barcodeScanRes);
  //   } on PlatformException {
  //     barcodeScanRes = 'Platform versiyonu alınamadı.';
  //   }

  //   scannerBarcode = barcodeScanRes;

  //   if (scannerBarcode != "") {
  //     sendQrPonit(scannerBarcode, position, context);
  //   }
  // }

  Future<dynamic> sendQrPonit(
    String scannerBarcode,
    Position position,
    BuildContext context,
  ) async {
    if (scannerBarcode == "-1") {
      CustomSnackBar(
        context,
        StringConstants.instance.cancelText2,
        backgroundColor: context.colorScheme.error,
      );
    } else {
      try {
        Map<String, dynamic> qrMap = jsonDecode(scannerBarcode);
        CustomLoader.showAlertDialog(context);

        var qrModel = QrModel.fromJson(qrMap);
        if (qrModel.id != null &&
            qrModel.branchID != null &&
            qrModel.companyID != null &&
            qrModel.name != null) {
          int zoneId = qrModel.id!;
          type = 3;
          if (networkConnectivity.internet) {
            var sendQrShift = await inAndOutService.sendQrShift(
              type: type,
              longitude: position.longitude,
              latitude: position.latitude,
              zoneId: zoneId,
              deviceId: deviceInfo.deviceId,
              deviceModel: deviceInfo.deviceModel,
            );
            if (sendQrShift["status"]) {
              Navigator.pop(context);
              CustomSnackBar(context, sendQrShift['message']);
            } else {
              Navigator.pop(context);
              CustomSnackBar(
                context,
                sendQrShift['message'],
                backgroundColor: context.colorScheme.error,
              );
            }
          } else {
            dataBaseController.insertQrDatabase(
              qrdataModel: OfflineQrModel(
                processTime: DateTime.now().toString(),
                latitude: position.latitude,
                longitude: position.longitude,
                zone: zoneId,
                isQRUpload: 0,
              ),
              context: context,
            );
            Navigator.pop(context);
            CustomSnackBar(
              scaffoldKey.currentContext!,
              StringConstants.instance.successMessage2,
            );
          }
        } else {
          Navigator.pop(context);
          CustomSnackBar(
            context,
            StringConstants.instance.qrErrorMessage,
            backgroundColor: context.colorScheme.error,
          );
        }
      } catch (e) {
        Navigator.pop(context);
        CustomSnackBar(
          context,
          StringConstants.instance.qrErrorMessage,
          backgroundColor: context.colorScheme.error,
        );
      }
    }
  }

  Future<dynamic> qrProcedure({
    required double longitude,
    required double latitude,
    required BuildContext context,
    String? deviceId,
    DateTime? offline,
    String? deviceModel,
    String? myNote,
    required bool isMockLocation,
    Map<String, dynamic>? offlineData,
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
      if (offline == null) {
        CustomLoader.showAlertDialog(context);
      }
      data = await inAndOutService.sendShift(
        type: 2,
        longitude: longitude,
        latitude: latitude,
        outside: outSide,
        deviceId: deviceId,
        deviceModel: deviceModel,
        myNote: myNote,
      );
      if (offline == null) {
        if (data['status'] != null && data['status']) {
          Navigator.pop(context);
          CustomSnackBar(context, data['message']);
        } else if (data != null && !data['status']) {
          if (data['note'] != null && !data['note']) {
            isEarly = true;
            Navigator.pop(context);
          } else {
            Navigator.pop(context);
            CustomSnackBar(
              context,
              data['message'],
              backgroundColor: context.colorScheme.error,
            );
          }
        } else if (data['status']) {
          CustomSnackBar(context, StringConstants.instance.outSuccessMessage);
        }
      }
    }

    return data;
  }

  //endregion
  bool isLateInCompany({
    required BuildContext context,
    required AuthViewModel authController,
  }) {
    List<String> time = authController.startTDate!.split(":");
    int toleranceHour = int.parse(time[0]);
    int toleranceMinute = int.parse(time[1]);
    DateTime dateTime = DateTime.now();
    int localeHour = dateTime.hour;
    int localeMinute = dateTime.minute;
    if (toleranceHour == localeHour) {
      if (toleranceMinute <= localeMinute) {
        return true;
      }
      return false;
    } else if (toleranceHour < localeHour) {
      return true;
    }
    return false;
  }

  bool isEarlyOutCompany({
    required BuildContext context,
    required AuthViewModel authVM,
  }) {
    List<String> time = authVM.endTDate!.split(":");
    int toleranceHour = int.parse(time[0]);
    int toleranceMinute = int.parse(time[1]);
    DateTime dateTime = DateTime.now();
    int localeHour = dateTime.hour;
    int localeMinute = dateTime.minute;
    if (toleranceHour == localeHour) {
      if (toleranceMinute >= localeMinute) {
        return true;
      }
      return false;
    } else if (toleranceHour > localeHour) {
      return true;
    }
    return false;
  }

  // Future<void> pushSignalService() async {
  //   OneSignal.shared.setLogLevel(OSLogLevel.verbose, OSLogLevel.none);

  //   OneSignal.shared.setAppId("071e20d6-c9c9-4ad9-a710-de8cbda0c0e5");
  //   String? id = authVM.localeManager.getStringValue(PreferencesKeys.ID);
  //   String? name = authVM.localeManager.getStringValue(
  //     PreferencesKeys.USERNAME,
  //   );
  //   String? compID = authVM.localeManager.getStringValue(
  //     PreferencesKeys.COMPID,
  //   );
  //   String? departmentID = authVM.localeManager.getStringValue(
  //     PreferencesKeys.DEPARTMENTID,
  //   );
  //   try {
  //     if (id.isNotEmpty &&
  //         name.isNotEmpty &&
  //         compID.isNotEmpty &&
  //         departmentID.isNotEmpty) {
  //       await OneSignal.shared.promptUserForPushNotificationPermission(
  //         fallbackToSettings: true,
  //       );
  //       await OneSignal.shared.setExternalUserId(id).whenComplete(() {
  //         print("Onesignal email: | $id");
  //       });
  //       await OneSignal.shared.sendTag("id", id).whenComplete(() {
  //         print("Onesignal email: | $id");
  //       });
  //       await OneSignal.shared.sendTag("name", name).whenComplete(() {
  //         print("Onesignal fullname: | $name");
  //       });
  //       await OneSignal.shared.sendTag("company_id", compID).whenComplete(() {
  //         print("Onesignal compID: | $compID");
  //       });
  //       await OneSignal.shared
  //           .sendTag("departmentID", departmentID)
  //           .whenComplete(() {
  //             print("Onesignal departmant: | $departmentID");
  //           });
  //     }
  //   } catch (e) {
  //     print("***************OneSignal exeption:****************\n $e");
  //   }
  // }

  @override
  void disp() {}

  @override
  void init() {}
}
