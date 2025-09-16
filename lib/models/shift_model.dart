import 'dart:convert';
import 'base_model.dart';

class ShiftDataModel {
  final String? datetime;
  final String? type;
  final String? startTime;
  final String? endTime;

  ShiftDataModel({this.datetime, this.type, this.startTime, this.endTime});

  factory ShiftDataModel.fromJson(Map<String, dynamic> json) {
    return ShiftDataModel(
      datetime: json['datetime'],
      type: json['type'],
      startTime: json['start_time'],
      endTime: json['end_time'],
    );
  }

  static List<ShiftDataModel> fromJsonList(
    List<Map<String, dynamic>> jsonList,
  ) {
    return jsonList.map((json) => ShiftDataModel.fromJson(json)).toList();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['datetime'] = datetime;
    data['type'] = type;
    data['start_time'] = startTime;
    data['end_time'] = endTime;
    return data;
  }

  @override
  String toString() {
    return 'ShiftDataModel(datetime: $datetime, type: $type, startTime: $startTime, endTime: $endTime)';
  }
}

typedef ShiftsModel = BaseModel<List<ShiftDataModel>>;

ShiftsModel shiftsModelFromJson(String str) {
  final json = jsonDecode(str);
  return BaseModel.fromJsonList(
    json,
    (jsonList) => ShiftDataModel.fromJsonList(jsonList),
  );
}

String shiftsModelToJson(ShiftsModel data) => json.encode(data.toJson());
