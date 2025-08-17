import 'dart:convert';

import 'package:http/http.dart' as http;

import '../core/constants/string_constants.dart';
import '../core/enums/enums.dart';
import '../core/init/cache/locale_manager.dart';
import '../models/base_model.dart';
import '../models/holiday_types_model.dart';
import '../models/holidays_model.dart';

class PermissionService {
  LocaleManager localeManager = LocaleManager.instance;
  StringConstants get strCons => StringConstants.instance;

  Future<HolidayListModel> holidayList() async {
    var client = http.Client();
    try {
      String? token = localeManager.getStringValue(PreferencesKeys.TOKEN);

      var response = await client
          .get(
            Uri.parse(strCons.baseUrl + strCons.permissionList),
            headers: {
              'Accept': 'application/json',
              'Authorization': 'Bearer $token',
            },
          )
          .timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        var data = json.decode(response.body);
        if (data['status']) {
          return holidaysModelFromJson(response.body);
        } else {
          return BaseModel(
            status: false,
            message: strCons.errorMessage,
            data: null,
          );
        }
      } else {
        return BaseModel(
          status: false,
          message: strCons.errorMessage,
          data: null,
        );
      }
    } catch (e) {
      return BaseModel(
        status: false,
        message: strCons.errorMessage,
        data: null,
      );
    } finally {
      client.close();
    }
  }

  Future<HolidayTypeListModel> holidayTypeList() async {
    var client = http.Client();
    try {
      String? token = localeManager.getStringValue(PreferencesKeys.TOKEN);

      var response = await client
          .get(
            Uri.parse(strCons.baseUrl + strCons.holidayTypeList),
            headers: {
              'Accept': 'application/json',
              'Authorization': 'Bearer $token',
            },
          )
          .timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        var data = json.decode(response.body);
        if (data['status']) {
          return holidayTypesModelFromJson(response.body);
        } else {
          return BaseModel(
            status: false,
            message: strCons.errorMessage,
            data: null,
          );
        }
      } else {
        return BaseModel(
          status: false,
          message: strCons.errorMessage,
          data: null,
        );
      }
    } catch (e) {
      return BaseModel(
        status: false,
        message: strCons.errorMessage,
        data: null,
      );
    } finally {
      client.close();
    }
  }

  Future<Map<String, dynamic>> holidayCreate({
    required int type,
    required DateTime startDt,
    required DateTime endDt,
    required String reason,
    required String address,
  }) async {
    var client = http.Client();
    try {
      String? token = localeManager.getStringValue(PreferencesKeys.TOKEN);
      Map bodyData = {
        "type": "$type",
        "start_date": "$startDt",
        "end_date": "$endDt",
        "reason": reason,
        "address": address,
      };
      var response = await client
          .post(
            Uri.parse(strCons.baseUrl + strCons.permissionCreate),
            headers: {
              'Accept': 'application/json',
              'Authorization': 'Bearer $token',
            },
            body: bodyData,
          )
          .timeout(const Duration(seconds: 10));
      if (response.statusCode == 200) {
        var data = json.decode(response.body);
        if (data['status']) {
          return {"status": true, "message": "işlem başarılı"};
        } else {
          return {"status": false, "message": data['message']};
        }
      } else {
        var data = json.decode(response.body);
        return {"status": data['status'], "message": data['message']};
      }
    } catch (e) {
      return {"status": false, "message": strCons.errorMessage};
    } finally {
      client.close();
    }
  }
}
