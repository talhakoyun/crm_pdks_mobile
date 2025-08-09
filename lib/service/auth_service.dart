import 'dart:convert';

import 'package:http/http.dart' as http;

import '../core/constants/string_constants.dart';
import '../core/init/cache/locale_manager.dart';
import '../core/init/network/service/network_api_service.dart';
import '../models/is_available_model.dart';
import '../models/login_model.dart';
import '../models/logout_model.dart';
import '../models/profile_model.dart';
import '../models/register_model.dart';

class AuthService {
  StringConstants get strCons => StringConstants.instance;
  final _apiServices = NetworkApiServices();
  LocaleManager localeManager = LocaleManager.instance;

  Future<LoginModel> login({required Map body}) async {
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
          return LoginModel.fromJson(data);
        } else if (!data['status']) {
          return LoginModel(
            status: false,
            message: data['message'],
            data: null,
          );
        } else {
          return LoginModel(
            status: false,
            message: strCons.errorMessage,
            data: null,
          );
        }
      } else {
        var data = json.decode(response.body);

        return LoginModel(status: false, message: data['message'], data: null);
      }
    } catch (e) {
      return LoginModel(
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
        } else if (!data['status']) {
          return RegisterModel(status: false, message: data['message']);
        } else {
          return RegisterModel(status: false, message: strCons.errorMessage);
        }
      } else {
        var data = json.decode(response.body);

        return RegisterModel(status: false, message: data['message']);
      }
    } catch (e) {
      return RegisterModel(status: false, message: strCons.errorMessage);
    } finally {
      client.close();
    }
  }

  Future<ProfileModel> profile() async {
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
          return ProfileModel.fromJson(data);
        } else {
          return ProfileModel(
            status: false,
            message: strCons.errorMessage,
            data: null,
          );
        }
      } else {
        var data = json.decode(response.body);
        return ProfileModel(
          status: false,
          message: data['message'] ?? strCons.errorMessage,
          data: null,
        );
      }
    } catch (e) {
      return ProfileModel(
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
      return response = LogoutModel.fromJson(response);
    } catch (e) {
      return LogoutModel(status: false, message: strCons.errorMessage);
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
          return IsAvailableModel.fromJson(data);
        } else {
          return IsAvailableModel(
            status: false,
            message: strCons.errorMessage,
            data: null,
          );
        }
      } else {
        return IsAvailableModel(
          status: false,
          message: strCons.errorMessage,
          data: null,
        );
      }
    } catch (e) {
      return IsAvailableModel(
        status: false,
        message: strCons.errorMessage,
        data: null,
      );
    } finally {
      client.close();
    }
  }
}
