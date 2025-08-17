// ignore_for_file: prefer_typing_uninitialized_variables

import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;

import '../../../init/network/exception/app_exception.dart';
import '../../../init/network/service/base_service.dart';

class NetworkApiServices extends BaseApiServices {
  var jsonResponse;

  @override
  Future getApiResponse(String url) async {
    var client = http.Client();
    try {
      final response = await client.get(Uri.parse(url));
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
    var jsonResponse;
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
        return responseJson;
      case 302:
        throw BadRequestException("response.body.toString()");
      case 400:
        throw BadRequestException(responseJson['message']);
      case 401:
        throw BadRequestException(responseJson['message']);
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
