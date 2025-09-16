import 'package:flutter/material.dart';

import '../core/base/view_model/base_view_model.dart';
import '../core/constants/navigation_constants.dart';
import '../core/constants/string_constants.dart';
import '../core/constants/service_locator.dart';
import '../core/enums/enums.dart';
import '../core/extension/context_extension.dart';
import '../core/widget/dialog/dialog_factory.dart';
import '../models/base_model.dart';
import '../models/holiday_types_model.dart';
import '../models/holidays_model.dart';
import '../service/permission_service.dart';
import '../core/widget/loader.dart';
import '../widgets/snackbar.dart';

class PermissionViewModel extends BaseViewModel {
  Map? permissionData;
  TextEditingController holidayReason = TextEditingController();
  TextEditingController holidayAddress = TextEditingController();
  TextEditingController holidayType = TextEditingController();
  TextEditingController holidayStartDt = TextEditingController();
  TextEditingController holidayEndDt = TextEditingController();
  List<HolidayTypeDataModel> typeItems = [];
  PermissionStatus? permissionStatus;
  bool _showValidationErrors = false;
  bool get showValidationErrors => _showValidationErrors;
  late final PermissionService _permissionServices;
  List<HolidayDataModel> permissionListItems = [];
  HolidayListModel? holidayList;

  PermissionViewModel({PermissionService? permissionService}) : super() {
    _permissionServices =
        permissionService ?? ServiceLocator.instance.get<PermissionService>();
    permissionStatus = PermissionStatus.loading;
  }

  void setHolidayType(String title, int id) {
    holidayType.text = title;
    _clearValidationErrors(); 
    notifyListeners();
  }

  void setHolidayStartDate(String date) {
    holidayStartDt.text = date;
    _clearValidationErrors(); 
    notifyListeners();
  }

  void setHolidayEndDate(String date) {
    holidayEndDt.text = date;
    _clearValidationErrors(); 
    notifyListeners();
  }
  
  void setShowValidationErrors(bool show) {
    _showValidationErrors = show;
    notifyListeners();
  }
  
  void _clearValidationErrors() {
    _showValidationErrors = false;
    notifyListeners();
  }
  
  void clearForm() {
    holidayAddress.clear();
    holidayReason.clear();
    holidayEndDt.clear();
    holidayStartDt.clear();
    holidayType.clear();
    _clearValidationErrors();
  }
  
  bool validateForm(int type) {
    return type != 0 &&
           holidayReason.text.trim().isNotEmpty &&
           holidayAddress.text.trim().isNotEmpty &&
           holidayStartDt.text.isNotEmpty &&
           holidayEndDt.text.isNotEmpty;
  }
  
  bool isFieldEmpty(String value, {bool isType = false, int type = 0}) {
    if (isType) {
      return type == 0;
    }
    return value.trim().isEmpty;
  }
  
  void onTextChanged(String value) {
    if (_showValidationErrors && value.trim().isNotEmpty) {
      _clearValidationErrors();
    }
  }

  @override
  void init() {
    fetchHolidayTypes();
  }

  @override
  void disp() {}

  Future<void> fetchHolidayTypes() async {
    try {
      final response = await _permissionServices.holidayTypeList();
      if (response.status!) {
        typeItems = response.data!;
        notifyListeners();
      }
    } catch (e) {
      debugPrint('Error fetching holiday types: $e');
    }
  }

  Future<void> fetchList(BuildContext context) async {
    permissionStatus = PermissionStatus.loading;
    HolidayListModel holidayListModel = await _permissionServices.holidayList();
    if (holidayListModel.status!) {
      permissionListItems = holidayListModel.data!;
      permissionStatus = PermissionStatus.loaded;
      notifyListeners();
    } else {
      permissionStatus = PermissionStatus.loadingFailed;
      if (!context.mounted) return;
      CustomSnackBar(
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
    if (!validateForm(type)) {
      setShowValidationErrors(true);
      CustomSnackBar(
        context,
        StringConstants.instance.notEmptyText,
        backgroundColor: context.colorScheme.error,
      );
      return; 
    }
    Loader.show(context);
    try {
      BaseModel<Map<String, dynamic>> data = await _permissionServices
          .holidayCreate(
            type: type,
            startDt: startDt,
            endDt: endDt,
            reason: holidayReason.text.trim(),
            address: holidayAddress.text.trim(),
          );
      
      Loader.hide();
      if (!context.mounted) return;
      if (data.status!) {
        clearForm();
        CustomSnackBar(context, StringConstants.instance.reviewText);
        navigation.navigateToPageClear(path: NavigationConstants.HOME);
      } else {
        CustomSnackBar(
          context,
          data.message!,
          backgroundColor: context.colorScheme.error,
        );
      }
    } catch (e) {
      Loader.hide();
      if (context.mounted) {
        CustomSnackBar(
          context,
          StringConstants.instance.unExpectedError,
          backgroundColor: context.colorScheme.error,
        );
      }
    }

    notifyListeners();
  }

  errorDialog(BuildContext context, String message) {
    DialogFactory.create(
      context: context,
      type: DialogType.error,
      parameters: {'message': message},
    );
  }
}
