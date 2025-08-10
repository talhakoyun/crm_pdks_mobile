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
    DateTime? offline,
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
            body: offline == null
                ? {
                    "type": type.toString(),
                    "outside": outside.toString(),
                    "longitude": longitude.toString(),
                    "latitude": latitude.toString(),
                    "device_id": deviceId.toString(),
                    "device_model": deviceModel.toString(),
                    "note": myNote ?? "",
                  }
                : {
                    "type": type.toString(),
                    "outside": outside.toString(),
                    "longitude": longitude.toString(),
                    "latitude": latitude.toString(),
                    "device_id": deviceId.toString(),
                    "device_model": deviceModel.toString(),
                    "note": myNote ?? "",
                    "offline": "$offline",
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
    required int type,
    required double longitude,
    required double latitude,
    required int zoneId,
    String? deviceId,
    String? deviceModel,
    DateTime? offline,
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
            },
            body: offline == null
                ? {
                    "type": type.toString(),
                    "longitude": longitude.toString(),
                    "latitude": latitude.toString(),
                    "zone": zoneId.toString(),
                    "device_id": deviceId.toString(),
                    "device_model": deviceModel.toString(),
                  }
                : {
                    "type": type.toString(),
                    "longitude": longitude.toString(),
                    "latitude": latitude.toString(),
                    "zone": zoneId.toString(),
                    "device_id": deviceId.toString(),
                    "device_model": deviceModel.toString(),
                    "offline": "$offline",
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
        return {"status": data['status'], "message": data['message']};
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
          .get(
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
