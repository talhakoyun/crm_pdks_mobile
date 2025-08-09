import 'dart:convert';

EventsModel eventsModelFromJson(String str) =>
    EventsModel.fromJson(json.decode(str));

String eventsModelToJson(EventsModel data) => json.encode(data.toJson());

class EventsModel {
  List<Data>? data;
  String? message;
  bool? status;

  EventsModel({this.data, this.message, this.status});

  EventsModel.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = <Data>[];
      json['data'].forEach((v) {
        data!.add(Data.fromJson(v));
      });
    }
    message = json['message'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    data['message'] = message;
    data['status'] = status;
    return data;
  }
}

class Data {
  String? datetime;
  String? type;
  String? startTime;
  String? endTime;
  bool? expanded;
  List<ZoneList>? zoneList;

  Data({this.datetime, this.type, this.startTime, this.endTime,this.expanded, this.zoneList});

  Data.fromJson(Map<String, dynamic> json) {
    datetime = json['datetime'];
    type = json['type'];
    startTime = json['start_time'];
    endTime = json['end_time'];
    expanded = json['expanded'];
    if (json['zone_list'] != null) {
      zoneList = <ZoneList>[];
      json['zone_list'].forEach((v) {
        zoneList!.add(ZoneList.fromJson(v));
      });
    }
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
}

class ZoneList {
  String? zoneName;
  int? zoneId;
  String? time;

  ZoneList({this.zoneName, this.zoneId, this.time});

  ZoneList.fromJson(Map<String, dynamic> json) {
    zoneName = json['zone_name'];
    zoneId = json['zone_id'];
    time = json['time'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['zone_name'] = zoneName;
    data['zone_id'] = zoneId;
    data['time'] = time;
    return data;
  }
}
