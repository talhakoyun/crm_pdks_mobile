import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;

import '../../../init/network/exception/app_exception.dart';
import '../../../init/network/service/base_service.dart';

// Refresh token fonksiyonu için typedef
typedef RefreshTokenFunction = Future<String?> Function();

class NetworkApiServices extends BaseApiServices {
  dynamic jsonResponse;
  final RefreshTokenFunction? _refreshTokenFunction;

  // Constructor'a refreshToken fonksiyonunu enjekte ediyoruz
  NetworkApiServices({RefreshTokenFunction? refreshTokenFunction})
    : _refreshTokenFunction = refreshTokenFunction;

  @override
  Future getApiResponse(String url, {String? token}) async {
    var client = http.Client();
    try {
      final response = await client.get(
        Uri.parse(url),
        headers: (token != null)
            ? {'Accept': 'application/json', 'Authorization': 'Bearer $token'}
            : {'Accept': 'application/json'},
      );

      if (response.statusCode == 401 && _refreshTokenFunction != null) {
        final newToken = await _refreshTokenFunction();
        if (newToken != null) {
          return await getApiResponse(url, token: newToken);
        } else {
          throw UnauthorisedException('Token refresh failed');
        }
      }

      jsonResponse = returnResponse(response);
      debugPrint(response.body.toString());
    } on SocketException {
      throw FetchDataException('No Internet Connection');
    } finally {
      client.close();
    }

    return jsonResponse;
  }

  @override
  Future postApiResponse(String url, var data, String? token) async {
    dynamic jsonResponse;
    var client = http.Client();
    try {
      http.Response response = await client
          .post(
            Uri.parse(url),
            body: data,
            headers: (token != null)
                ? {
                    'Accept': 'application/json',
                    'Authorization': 'Bearer $token',
                  }
                : {'Accept': 'application/json'},
          )
          .timeout(const Duration(seconds: 10));

      if (response.statusCode == 401 && _refreshTokenFunction != null) {
        final newToken = await _refreshTokenFunction();
        if (newToken != null) {
          return await postApiResponse(url, data, newToken);
        } else {
          throw UnauthorisedException('Token refresh failed');
        }
      }

      jsonResponse = returnResponse(response);
    } on SocketException {
      throw FetchDataException('No Internet Connection');
    } finally {
      client.close();
    }

    return jsonResponse;
  }

  dynamic returnResponse(http.Response response) {
    var responseJson = jsonDecode(response.body);
    switch (response.statusCode) {
      case 200:
      case 201:
        return responseJson;
      case 302:
        throw BadRequestException(response.body.toString());
      case 400:
        throw BadRequestException(response.body.toString());
      case 401:
        throw UnauthorisedException(response.body.toString());
      case 404:
        throw BadRequestException(response.body.toString());
      case 500:
        throw BadRequestException(response.body.toString());
      default:
        throw FetchDataException(
          "Error accourded while communicating with server with status code ${response.statusCode}",
        );
    }
  }
}
