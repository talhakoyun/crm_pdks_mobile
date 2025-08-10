import 'dart:convert';

import 'package:http/http.dart' as http;

import '../core/constants/string_constants.dart';
import '../core/init/cache/locale_manager.dart';
import '../core/init/network/service/network_api_service.dart';

import '../models/base_model.dart';
import '../models/is_available_model.dart';
import '../models/logout_model.dart';
import '../models/register_model.dart';
import '../models/user_model.dart';

class AuthService {
  StringConstants get strCons => StringConstants.instance;
  final _apiServices = NetworkApiServices();
  LocaleManager localeManager = LocaleManager.instance;

  Future<BaseModel<List<UserModel>>> login({required Map body}) async {
    var client = http.Client();
    try {
      var response = await client
          .post(
            Uri.parse(strCons.baseUrl + strCons.loginUrl),
            body: body,
            headers: {'Accept': 'application/json'},
          )
          .timeout(const Duration(seconds: 10));
      if (response.statusCode == 200) {
        var data = json.decode(response.body);
        if (data['status']) {
          return BaseModel.fromJsonList(
            data,
            (jsonList) => UserModel.fromJsonList(jsonList),
          );
        } else {
          return BaseModel(status: false, message: data['message'], data: null);
        }
      } else {
        var data = json.decode(response.body);
        return BaseModel(status: false, message: data['message'], data: null);
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

  Future<RegisterModel> register({required Map body}) async {
    var client = http.Client();
    try {
      var response = await client
          .post(
            Uri.parse(strCons.baseUrl + strCons.register),
            body: body,
            headers: {'Accept': 'application/json'},
          )
          .timeout(const Duration(seconds: 10));
      if (response.statusCode == 200) {
        var data = json.decode(response.body);
        if (data['status']) {
          return registerModelFromJson(response.body);
        } else {
          return BaseModel(status: false, message: data['message'], data: null);
        }
      } else {
        var data = json.decode(response.body);
        return BaseModel(status: false, message: data['message'], data: null);
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

  Future<BaseModel<List<UserModel>>> profile() async {
    var client = http.Client();
    String? token = localeManager.getStringValue(PreferencesKeys.TOKEN);
    try {
      var response = await client
          .get(
            Uri.parse(strCons.baseUrl + strCons.profile),
            headers: {
              'Accept': 'application/json',
              'Authorization': 'Bearer $token',
            },
          )
          .timeout(const Duration(seconds: 10));
      if (response.statusCode == 200) {
        var data = json.decode(response.body);
        if (data['status']) {
          // API response'u tek user objesi dönüyor, liste değil
          if (data['data'] is Map) {
            // Tek bir user objesi geliyorsa onu listeye çevir
            final userModel = UserModel.fromJson(data['data']);
            return BaseModel<List<UserModel>>(
              status: true,
              message: data['message'],
              data: [userModel],
            );
          } else if (data['data'] is List) {
            // Liste geliyorsa normal işle
            return BaseModel.fromJsonList(
              data,
              (jsonList) => UserModel.fromJsonList(jsonList),
            );
          } else {
            return BaseModel(
              status: false,
              message: 'Beklenmeyen data formatı',
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
      } else {
        var data = json.decode(response.body);
        return BaseModel(
          status: false,
          message: data['message'] ?? strCons.errorMessage,
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

  Future<LogoutModel> logout(String? token) async {
    try {
      dynamic response = await _apiServices.postApiResponse(
        strCons.baseUrl + strCons.logout,
        {},
        token!,
      );
      return BaseModel.fromJson(
        response,
        (data) => data, // data kısmı önemli değil, sadece status ve message
      );
    } catch (e) {
      return BaseModel(
        status: false,
        message: strCons.errorMessage,
        data: null,
      );
    }
  }

  Future<IsAvailableModel> isAvalible() async {
    var client = http.Client();
    try {
      var response = await client
          .get(
            Uri.parse(strCons.baseUrl + strCons.isAvalible),
            headers: {'Accept': 'application/json'},
          )
          .timeout(const Duration(seconds: 10));
      if (response.statusCode == 200) {
        var data = json.decode(response.body);
        if (data['status']) {
          return BaseModel.fromJson(
            data,
            (dataJson) => AvailabilityModel.fromJson(dataJson),
          );
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
