import 'dart:convert';

import '../core/constants/string_constants.dart';
import '../core/enums/enums.dart';
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
    try {
      dynamic response = await _apiServices.postApiResponse(
        strCons.baseUrl + strCons.loginUrl,
        body,
        null,
      );

      if (response['status']) {
        return BaseModel.fromJsonList(
          response,
          (jsonList) => UserModel.fromJsonList(jsonList),
        );
      } else {
        return BaseModel(
          status: false,
          message: response['message'],
          data: null,
        );
      }
    } catch (e) {
      return BaseModel(
        status: false,
        message: strCons.errorMessage,
        data: null,
      );
    }
  }

  Future<RegisterModel> register({required Map body}) async {
    try {
      dynamic response = await _apiServices.postApiResponse(
        strCons.baseUrl + strCons.register,
        body,
        null,
      );

      if (response['status']) {
        return registerModelFromJson(json.encode(response));
      } else {
        return BaseModel(
          status: false,
          message: response['message'],
          data: null,
        );
      }
    } catch (e) {
      return BaseModel(
        status: false,
        message: strCons.errorMessage,
        data: null,
      );
    }
  }

  Future<BaseModel<List<UserModel>>> profile() async {
    try {
      String? token = localeManager.getStringValue(PreferencesKeys.TOKEN);

      dynamic response = await _apiServices.getApiResponse(
        strCons.baseUrl + strCons.profile,
        token: token,
      );

      if (response['status']) {
        // API response'u tek user objesi dönüyor, liste değil
        if (response['data'] is Map) {
          // Tek bir user objesi geliyorsa onu listeye çevir
          final userModel = UserModel.fromJson(response['data']);
          return BaseModel<List<UserModel>>(
            status: true,
            message: response['message'],
            data: [userModel],
          );
        } else if (response['data'] is List) {
          // Liste geliyorsa normal işle
          return BaseModel.fromJsonList(
            response,
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
          message: response['message'] ?? strCons.errorMessage,
          data: null,
        );
      }
    } catch (e) {
      return BaseModel(
        status: false,
        message: strCons.errorMessage,
        data: null,
      );
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
    try {
      dynamic response = await _apiServices.getApiResponse(
        strCons.baseUrl + strCons.isAvalible,
      );

      if (response['status']) {
        return BaseModel.fromJson(
          response,
          (dataJson) => AvailabilityModel.fromJson(dataJson),
        );
      } else {
        return BaseModel(
          status: false,
          message: response['message'] ?? strCons.errorMessage,
          data: null,
        );
      }
    } catch (e) {
      return BaseModel(
        status: false,
        message: strCons.errorMessage,
        data: null,
      );
    }
  }
}
