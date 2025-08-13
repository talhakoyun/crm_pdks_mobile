// ignore_for_file: avoid_print

import 'dart:convert';

import 'package:http/http.dart' as http;

import '../core/constants/string_constants.dart';
import '../core/init/cache/locale_manager.dart';
import '../models/base_model.dart';

import '../models/events_model.dart';

class InAndOutService {
  LocaleManager localeManager = LocaleManager.instance;
  StringConstants get strCons => StringConstants.instance;

  Future<Map<String, dynamic>> sendShift({
    required int type,
    required double longitude,
    required double latitude,
    required int outside,
    String? deviceId,
    String? deviceModel,
    String? myNote,
  }) async {
    var client = http.Client();

    try {
      String? token = localeManager.getStringValue(PreferencesKeys.TOKEN);
      var response = await client
          .post(
            Uri.parse(strCons.baseUrl + strCons.shiftPing),
            headers: {
              'Accept': 'application/json',
              'Authorization': 'Bearer $token',
            },
            body: {
              "type": type.toString(),
              "outside": outside.toString(),
              "longitude": longitude.toString(),
              "latitude": latitude.toString(),
              "device_id": deviceId.toString(),
              "device_model": deviceModel.toString(),
              "note": myNote ?? "",
            },
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
        if (data['note'] != null && !data['note']) {
          return {
            "status": data['status'],
            "message": data['message'],
            "note": data['note'],
          };
        }
        return {"status": data['status'], "message": data['message']};
      }
    } catch (e) {
      return {"status": false, "message": strCons.errorMessage};
    } finally {
      client.close();
    }
  }

  Future<Map<String, dynamic>> sendQrShift({
    required String qrStr,
    required int type,
    required double longitude,
    required double latitude,
    String? deviceId,
    String? deviceModel,
  }) async {
    var client = http.Client();
    try {
      String? token = localeManager.getStringValue(PreferencesKeys.TOKEN);

      var response = await client
          .post(
            Uri.parse(strCons.baseUrl + strCons.shiftQR),
            headers: {
              'Accept': 'application/json',
              'Authorization': 'Bearer $token',
              'Content-Type': 'application/json',
            },
            body: json.encode({
              "qr_str": qrStr,
              "type": type,
              "device_id": deviceId,
              "device_model": deviceModel,
              "positions": {"latitude": latitude, "longitude": longitude},
            }),
          )
          .timeout(const Duration(seconds: 10));
      if (response.statusCode == 200) {
        var data = json.decode(response.body);
        if (data['status']) {
          return {
            "status": true,
            "message": data['message'] ?? "İşlem başarılı",
          };
        } else {
          return {"status": false, "message": data['message']};
        }
      } else {
        var data = json.decode(response.body);
        return {
          "status": false,
          "message": data['message'] ?? strCons.errorMessage,
        };
      }
    } catch (e) {
      return {"status": false, "message": strCons.errorMessage};
    } finally {
      client.close();
    }
  }

  Future<EventsModel> shiftList() async {
    var client = http.Client();
    try {
      String? token = localeManager.getStringValue(PreferencesKeys.TOKEN);
      var response = await client
          .post(
            Uri.parse(strCons.baseUrl + strCons.shiftList),
            headers: {
              'Accept': 'application/json',
              'Authorization': 'Bearer $token',
            },
          )
          .timeout(const Duration(seconds: 10));
      if (response.statusCode == 200) {
        var data = json.decode(response.body);
        if (data['status']) {
          return eventsModelFromJson(response.body);
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
}
