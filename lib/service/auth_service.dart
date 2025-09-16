import 'dart:convert';

import '../core/constants/string_constants.dart';
import '../core/enums/enums.dart';
import '../core/init/cache/locale_manager.dart';
import '../core/init/network/exception/app_exception.dart';
import '../core/init/network/service/network_api_service.dart';
import '../models/base_model.dart';
import '../models/is_available_model.dart';
import '../models/logout_model.dart';
import '../models/register_model.dart';
import '../models/user_model.dart';
import '../core/constants/service_locator.dart';

class AuthService {
  StringConstants get strCons => StringConstants.instance;
  final NetworkApiServices _apiServices = ServiceLocator.instance
      .get<NetworkApiServices>();
  LocaleManager localeManager = LocaleManager.instance;

  Future<String?> refreshAccessToken({required String refreshToken}) async {
    try {
      dynamic response = await _apiServices.postApiResponse(
        strCons.baseUrl + strCons.refreshToken,
        null,
        refreshToken,
      );

      if (response['status']) {
        final userModel = UserModel.fromJson(response['data']);
        await localeManager.setStringValue(
          PreferencesKeys.TOKEN,
          userModel.accessToken ?? "",
        );
        await localeManager.setStringValue(
          PreferencesKeys.REFRESH_TOKEN,
          userModel.refreshToken ?? "",
        );
        return userModel.accessToken;
      } else {
        return null;
      }
    } catch (e) {
      return null;
    }
  }

  Future<BaseModel<List<UserModel>>> login({required Map body}) async {
    try {
      dynamic response = await _apiServices.postApiResponse(
        strCons.baseUrl + strCons.loginUrl,
        body,
        null,
        refreshTokenOn401: false,
      );
      if (response['status']) {
        return BaseModel.fromJsonList(
          response,
          (jsonList) => UserModel.fromJsonList(jsonList),
        );
      } else {
        return BaseModel(
          status: false,
          message: response['message'] ?? strCons.errorMessage,
          data: null,
        );
      }
    } on BadRequestException catch (e) {
      String errorMessage = e.msg ?? strCons.errorMessage;
      try {
        var errorJson = jsonDecode(e.msg ?? '{}');
        if (errorJson is Map && errorJson.containsKey('message')) {
          errorMessage = errorJson['message'].toString();
        }
      } catch (e) {
        // JSON değilse, olduğu gibi kullan
      }

      return BaseModel(status: false, message: errorMessage, data: null);
    } on UnauthorisedException catch (e) {
      String errorMessage = e.msg ?? strCons.errorMessage;
      try {
        var errorJson = jsonDecode(e.msg ?? '{}');
        if (errorJson is Map && errorJson.containsKey('message')) {
          errorMessage = errorJson['message'].toString();
        }
      } catch (e) {
        // JSON değilse, olduğu gibi kullan
      }

      return BaseModel(status: false, message: errorMessage, data: null);
    } catch (e) {
      if (e is AppException) {
        String errorMessage = e.msg ?? strCons.errorMessage;
        try {
          var errorJson = jsonDecode(e.msg ?? '{}');
          if (errorJson is Map && errorJson.containsKey('message')) {
            errorMessage = errorJson['message'].toString();
          }
        } catch (e) {
          // JSON değilse, olduğu gibi kullan
        }

        return BaseModel(status: false, message: errorMessage, data: null);
      }

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
    } on BadRequestException catch (e) {
      return BaseModel(
        status: false,
        message: e.msg ?? strCons.errorMessage,
        data: null,
      );
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
        if (response['data'] is Map) {
          final userModel = UserModel.fromJson(response['data']);
          return BaseModel<List<UserModel>>(
            status: true,
            message: response['message'],
            data: [userModel],
          );
        } else if (response['data'] is List) {
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
    } on BadRequestException catch (e) {
      return BaseModel(
        status: false,
        message: e.msg ?? strCons.errorMessage,
        data: null,
      );
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
      return BaseModel.fromJson(response, (data) => data);
    } on BadRequestException catch (e) {
      return BaseModel(
        status: false,
        message: e.msg ?? strCons.errorMessage,
        data: null,
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
    } on BadRequestException catch (e) {
      return BaseModel(
        status: false,
        message: e.msg ?? strCons.errorMessage,
        data: null,
      );
    } catch (e) {
      return BaseModel(
        status: false,
        message: strCons.errorMessage,
        data: null,
      );
    }
  }

  Future<BaseModel> changePassword({
    required String currentPassword,
    required String newPassword,
    required String newPasswordConfirmation,
  }) async {
    try {
      String? token = localeManager.getStringValue(PreferencesKeys.TOKEN);

      Map<String, dynamic> body = {
        'current_password': currentPassword,
        'new_password': newPassword,
        'new_password_confirmation': newPasswordConfirmation,
      };

      dynamic response = await _apiServices.postApiResponse(
        strCons.baseUrl + strCons.changePassword,
        body,
        token,
      );

      if (response is Map && response['status'] == true) {
        return BaseModel(
          status: true,
          message: response['message'] ?? 'Şifre başarıyla değiştirildi',
          data: response['data'],
        );
      } else if (response is Map) {
        String errorMessage = strCons.errorMessage;
        if (response['message'] != null) {
          errorMessage = response['message'];
        }
        return BaseModel(status: false, message: errorMessage, data: null);
      } else {
        return BaseModel(
          status: false,
          message: strCons.errorMessage,
          data: null,
        );
      }
    } on BadRequestException catch (e) {
      return BaseModel(
        status: false,
        message: e.msg ?? strCons.errorMessage,
        data: null,
      );
    } catch (e) {
      return BaseModel(
        status: false,
        message: strCons.errorMessage,
        data: null,
      );
    }
  }
}
