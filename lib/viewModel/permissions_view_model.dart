// ignore_for_file: unused_local_variable, use_build_context_synchronously

import 'package:flutter/material.dart';

import '../core/base/view_model/base_view_model.dart';

import '../core/constants/navigation_constants.dart';
import '../core/constants/string_constants.dart';
import '../core/extension/context_extension.dart';
import '../core/widget/customize_dialog.dart';
import '../models/holidays_model.dart';
import '../service/permission_service.dart';
import '../widgets/dialog/custom_loader.dart';
import '../widgets/dialog/snackbar.dart';

enum PermissionStatus { loading, loaded, loadingFailed }

class PermissionViewModel extends BaseViewModel {
  Map? permissionData;
  TextEditingController holidayReason = TextEditingController();
  TextEditingController holidayAddress = TextEditingController();
  TextEditingController holidayType = TextEditingController();
  TextEditingController holidayStartDt = TextEditingController();
  TextEditingController holidayEndDt = TextEditingController();
  final dynamic typeItems = [
    'Ücretsiz İzin',
    'İdari İzin',
    'Yıllık İzin',
    'Sağlık Raporu',
    'Analık İzni',
    'Emzirme İzni',
    'Babalık İzni',
    'Evlenme İzni',
    'Ölüm İzni',
    'Doğum İzni',
  ];
  PermissionStatus? permissionStatus;
  final permissionServices = PermissionService();

  List<HolidayDataModel> permissionListItems = [];
  HolidayListModel? holidayList;
  PermissionViewModel() {
    permissionStatus = PermissionStatus.loading;
  }

  @override
  void init() {}
  @override
  void disp() {}

  void fetchList(BuildContext context) async {
    permissionStatus = PermissionStatus.loading;
    HolidayListModel holidayListModel = await permissionServices.holidayList();
    if (holidayListModel.status!) {
      permissionListItems = holidayListModel.data!;
      permissionStatus = PermissionStatus.loaded;
      notifyListeners();
    } else {
      permissionStatus = PermissionStatus.loadingFailed;
      CustomSnackBar customSnackBar = CustomSnackBar(
        context,
        holidayListModel.message!,
        backgroundColor: context.colorScheme.error,
      );
      notifyListeners();
    }
  }

  void getPermission({
    required int type,
    required DateTime startDt,
    required DateTime endDt,
    required BuildContext context,
  }) async {
    CustomLoader.showAlertDialog(context);
    if (type != 0 &&
        holidayReason.text != "" &&
        holidayAddress.text != "" &&
        holidayEndDt.text != "" &&
        holidayStartDt.text.isNotEmpty) {
      var data = await permissionServices.holidayCreate(
        type: type,
        startDt: startDt,
        endDt: endDt,
        reason: holidayReason.text.trim(),
        address: holidayAddress.text.trim(),
      );
      context.navigationOf.pop();
      if (data['status']) {
        holidayAddress.clear();
        holidayReason.clear();
        holidayEndDt.clear();
        holidayStartDt.clear();
        holidayType.clear();
        CustomSnackBar customSnackBar = CustomSnackBar(
          context,
          StringConstants.instance.reviewText,
        );
        navigation.navigateToPageClear(path: NavigationConstants.HOME);
      } else {
        CustomSnackBar customSnackBar = CustomSnackBar(
          context,
          data['message'],
          backgroundColor: context.colorScheme.error,
        );
      }
    } else {
      CustomSnackBar customSnackBar = CustomSnackBar(
        context,
        StringConstants.instance.notEmptyText,
        backgroundColor: context.colorScheme.error,
      );
      context.navigationOf.pop();
    }

    notifyListeners();
  }

  errorDialog(BuildContext context, String message) {
    CustomizeDialog.show(
      context: context,
      type: DialogType.error,
      message: message,
    );
  }
}
