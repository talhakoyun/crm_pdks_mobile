import 'dart:convert';
import 'base_model.dart';

class HolidayTypeDataModel {
  final int? id;
  final String? title;
  final String? iconName;

  HolidayTypeDataModel({this.id, this.title, this.iconName});

  factory HolidayTypeDataModel.fromJson(Map<String, dynamic> json) {
    return HolidayTypeDataModel(
      id: json['id'],
      title: json['title'],
      iconName: json['icon_name'],
    );
  }

  static List<HolidayTypeDataModel> fromJsonList(
    List<Map<String, dynamic>> jsonList,
  ) {
    return jsonList.map((json) => HolidayTypeDataModel.fromJson(json)).toList();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['title'] = title;
    data['icon_name'] = iconName;
    return data;
  }

  @override
  String toString() =>
      'HolidayTypeDataModel(id: $id, title: $title, iconName: $iconName)';
}

typedef HolidayTypeListModel = BaseModel<List<HolidayTypeDataModel>>;

HolidayTypeListModel holidayTypesModelFromJson(String str) {
  final json = jsonDecode(str);
  return BaseModel.fromJsonList(
    json,
    (jsonList) => HolidayTypeDataModel.fromJsonList(jsonList),
  );
}

String holidayTypesModelToJson(HolidayTypeListModel data) =>
    json.encode(data.toJson());
