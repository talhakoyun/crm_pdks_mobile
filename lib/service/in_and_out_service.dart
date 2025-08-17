import 'dart:convert';

import '../core/constants/string_constants.dart';
import '../core/enums/enums.dart';
import '../core/init/cache/locale_manager.dart';
import '../core/init/network/service/network_api_service.dart';
import '../models/base_model.dart';
import '../models/shift_model.dart';

class InAndOutService {
  LocaleManager localeManager = LocaleManager.instance;
  StringConstants get strCons => StringConstants.instance;
  final _apiServices = NetworkApiServices();

  Future<BaseModel<Map<String, dynamic>>> sendShift({
    required int type,
    required double longitude,
    required double latitude,
    required int outside,
    String? deviceId,
    String? deviceModel,
    String? myNote,
  }) async {
    try {
      String? token = localeManager.getStringValue(PreferencesKeys.TOKEN);
      Map<String, String> bodyData = {
        "type": type.toString(),
        "outside": outside.toString(),
        "longitude": longitude.toString(),
        "latitude": latitude.toString(),
        "device_id": deviceId.toString(),
        "device_model": deviceModel.toString(),
        "note": myNote ?? "",
      };

      dynamic response = await _apiServices.postApiResponse(
        strCons.baseUrl + strCons.shiftPing,
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
    } catch (e) {
      return BaseModel<Map<String, dynamic>>(
        status: false,
        message: strCons.errorMessage,
        data: {"status": false, "message": strCons.errorMessage},
      );
    }
  }

  Future<BaseModel<Map<String, dynamic>>> sendQrShift({
    required String qrStr,
    required int type,
    required double longitude,
    required double latitude,
    String? deviceId,
    String? deviceModel,
  }) async {
    try {
      String? token = localeManager.getStringValue(PreferencesKeys.TOKEN);
      Map<String, dynamic> bodyData = {
        "qr_str": qrStr,
        "type": type,
        "device_id": deviceId,
        "device_model": deviceModel,
        "positions": {"latitude": latitude, "longitude": longitude},
      };

      dynamic response = await _apiServices.postApiResponse(
        strCons.baseUrl + strCons.shiftQR,
        json.encode(bodyData),
        token,
      );

      if (response['status']) {
        return BaseModel<Map<String, dynamic>>(
          status: true,
          message: response['message'] ?? "İşlem başarılı",
          data: {
            "status": true,
            "message": response['message'] ?? "İşlem başarılı",
          },
        );
      } else {
        return BaseModel<Map<String, dynamic>>(
          status: false,
          message: response['message'] ?? strCons.errorMessage,
          data: {"status": false, "message": response['message']},
        );
      }
    } catch (e) {
      return BaseModel<Map<String, dynamic>>(
        status: false,
        message: strCons.errorMessage,
        data: {"status": false, "message": strCons.errorMessage},
      );
    }
  }

  Future<BaseModel<List<ShiftDataModel>>> shiftList() async {
    try {
      String? token = localeManager.getStringValue(PreferencesKeys.TOKEN);

      dynamic response = await _apiServices.postApiResponse(
        strCons.baseUrl + strCons.shiftList,
        {},
        token,
      );

      if (response['status']) {
        return BaseModel.fromJsonList(
          response,
          (jsonList) => ShiftDataModel.fromJsonList(jsonList),
        );
      } else {
        return BaseModel<List<ShiftDataModel>>(
          status: false,
          message: response['message'] ?? strCons.errorMessage,
          data: null,
        );
      }
    } catch (e) {
      return BaseModel<List<ShiftDataModel>>(
        status: false,
        message: strCons.errorMessage,
        data: null,
      );
    }
  }
}
