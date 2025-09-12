import 'package:crm_pdks_mobile/core/init/network/exception/app_exception.dart';

import '../core/constants/string_constants.dart';
import '../core/enums/enums.dart';
import '../core/init/cache/locale_manager.dart';
import '../core/init/network/service/network_api_service.dart';
import '../models/base_model.dart';
import '../models/holiday_types_model.dart';
import '../models/holidays_model.dart';

class PermissionService {
  LocaleManager localeManager = LocaleManager.instance;
  StringConstants get strCons => StringConstants.instance;
  final _apiServices = NetworkApiServices();

  Future<BaseModel<List<HolidayDataModel>>> holidayList() async {
    try {
      String? token = localeManager.getStringValue(PreferencesKeys.TOKEN);

      dynamic response = await _apiServices.getApiResponse(
        strCons.baseUrl + strCons.permissionList,
        token: token,
      );

      if (response['status']) {
        return BaseModel.fromJsonList(
          response,
          (jsonList) => HolidayDataModel.fromJsonList(jsonList),
        );
      } else {
        return BaseModel<List<HolidayDataModel>>(
          status: false,
          message: response['message'] ?? strCons.errorMessage,
          data: null,
        );
      }
    } on BadRequestException catch (e) {
      // 422 hata kodu BadRequestException olarak gelecek
      return BaseModel<List<HolidayDataModel>>(
        status: false,
        message: e.msg ?? strCons.errorMessage,
        data: null,
      );
    } catch (e) {
      return BaseModel<List<HolidayDataModel>>(
        status: false,
        message: strCons.errorMessage,
        data: null,
      );
    }
  }

  Future<BaseModel<List<HolidayTypeDataModel>>> holidayTypeList() async {
    try {
      String? token = localeManager.getStringValue(PreferencesKeys.TOKEN);

      dynamic response = await _apiServices.getApiResponse(
        strCons.baseUrl + strCons.holidayTypeList,
        token: token,
      );

      if (response['status']) {
        return BaseModel.fromJsonList(
          response,
          (jsonList) => HolidayTypeDataModel.fromJsonList(jsonList),
        );
      } else {
        return BaseModel<List<HolidayTypeDataModel>>(
          status: false,
          message: response['message'] ?? strCons.errorMessage,
          data: null,
        );
      }
    } on BadRequestException catch (e) {
      // 422 hata kodu BadRequestException olarak gelecek
      return BaseModel<List<HolidayTypeDataModel>>(
        status: false,
        message: e.msg ?? strCons.errorMessage,
        data: null,
      );
    } catch (e) {
      return BaseModel<List<HolidayTypeDataModel>>(
        status: false,
        message: strCons.errorMessage,
        data: null,
      );
    }
  }

  Future<BaseModel<Map<String, dynamic>>> holidayCreate({
    required int type,
    required DateTime startDt,
    required DateTime endDt,
    required String reason,
    required String address,
  }) async {
    try {
      String? token = localeManager.getStringValue(PreferencesKeys.TOKEN);
      Map<String, String> bodyData = {
        "type": "$type",
        "start_date": "$startDt",
        "end_date": "$endDt",
        "reason": reason,
        "address": address,
      };

      dynamic response = await _apiServices.postApiResponse(
        strCons.baseUrl + strCons.permissionCreate,
        bodyData,
        token,
      );

      if (response['status']) {
        return BaseModel<Map<String, dynamic>>(
          status: true,
          message: "İşlem başarılı",
          data: {"status": true, "message": "İşlem başarılı"},
        );
      } else {
        return BaseModel<Map<String, dynamic>>(
          status: false,
          message: response['message'] ?? strCons.errorMessage,
          data: {"status": false, "message": response['message']},
        );
      }
    } on BadRequestException catch (e) {
      // 422 hata kodu BadRequestException olarak gelecek
      return BaseModel<Map<String, dynamic>>(
        status: false,
        message: e.msg ?? strCons.errorMessage,
        data: {"status": false, "message": e.msg ?? strCons.errorMessage},
      );
    } catch (e) {
      return BaseModel<Map<String, dynamic>>(
        status: false,
        message: strCons.errorMessage,
        data: {"status": false, "message": strCons.errorMessage},
      );
    }
  }
}
