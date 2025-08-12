import 'dart:convert';
import 'base_model.dart';

class EventDataModel {
  final String? datetime;
  final String? type;
  final String? startTime;
  final String? endTime;

  EventDataModel({this.datetime, this.type, this.startTime, this.endTime});

  factory EventDataModel.fromJson(Map<String, dynamic> json) {
    return EventDataModel(
      datetime: json['datetime'],
      type: json['type'],
      startTime: json['start_time'],
      endTime: json['end_time'],
    );
  }

  static List<EventDataModel> fromJsonList(
    List<Map<String, dynamic>> jsonList,
  ) {
    return jsonList.map((json) => EventDataModel.fromJson(json)).toList();
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
    return 'EventDataModel(datetime: $datetime, type: $type, startTime: $startTime, endTime: $endTime)';
  }
}

typedef EventsModel = BaseModel<List<EventDataModel>>;

EventsModel eventsModelFromJson(String str) {
  final json = jsonDecode(str);
  return BaseModel.fromJsonList(
    json,
    (jsonList) => EventDataModel.fromJsonList(jsonList),
  );
}

String eventsModelToJson(EventsModel data) => json.encode(data.toJson());
