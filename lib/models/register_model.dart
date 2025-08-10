import 'dart:convert';
import 'base_model.dart';

class RegisterDataModel {
  final String? key;

  RegisterDataModel({this.key});

  factory RegisterDataModel.fromJson(Map<String, dynamic> json) {
    return RegisterDataModel(key: json['key']);
  }

  static List<RegisterDataModel> fromJsonList(
    List<Map<String, dynamic>> jsonList,
  ) {
    return jsonList.map((json) => RegisterDataModel.fromJson(json)).toList();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['key'] = key;
    return data;
  }

  @override
  String toString() {
    return 'RegisterDataModel(key: $key)';
  }
}

typedef RegisterModel = BaseModel<List<RegisterDataModel>>;

RegisterModel registerModelFromJson(String str) {
  final json = jsonDecode(str);
  return BaseModel.fromJsonList(
    json,
    (jsonList) => RegisterDataModel.fromJsonList(jsonList),
  );
}
