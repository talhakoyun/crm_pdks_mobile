import 'dart:convert';
import 'base_model.dart';

class EventDataModel {
  final String? datetime;
  final String? type;
  final String? startTime;
  final String? endTime;
  bool? expanded;
  final List<ZoneListModel>? zoneList;

  EventDataModel({
    this.datetime,
    this.type,
    this.startTime,
    this.endTime,
    this.expanded,
    this.zoneList,
  });

  factory EventDataModel.fromJson(Map<String, dynamic> json) {
    return EventDataModel(
      datetime: json['datetime'],
      type: json['type'],
      startTime: json['start_time'],
      endTime: json['end_time'],
      expanded: json['expanded'],
      zoneList: json['zone_list'] != null
          ? List<ZoneListModel>.from(
              json['zone_list'].map((x) => ZoneListModel.fromJson(x)),
            )
          : null,
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
    data['expanded'] = expanded;
    if (zoneList != null) {
      data['zone_list'] = zoneList!.map((v) => v.toJson()).toList();
    }
    return data;
  }

  @override
  String toString() {
    return 'EventDataModel(datetime: $datetime, type: $type, startTime: $startTime, endTime: $endTime)';
  }
}

class ZoneListModel {
  final String? zoneName;
  final int? zoneId;
  final String? time;

  ZoneListModel({this.zoneName, this.zoneId, this.time});

  factory ZoneListModel.fromJson(Map<String, dynamic> json) {
    return ZoneListModel(
      zoneName: json['zone_name'],
      zoneId: json['zone_id'],
      time: json['time'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['zone_name'] = zoneName;
    data['zone_id'] = zoneId;
    data['time'] = time;
    return data;
  }

  @override
  String toString() {
    return 'ZoneListModel(zoneName: $zoneName, zoneId: $zoneId, time: $time)';
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
