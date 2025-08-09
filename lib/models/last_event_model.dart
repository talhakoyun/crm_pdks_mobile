import 'dart:convert';

LastEventModel lastEventModelFromJson(String str) =>
    LastEventModel.fromJson(json.decode(str));

String lastEventModelToJson(LastEventModel data) => json.encode(data.toJson());

class LastEventModel {
  LastEventModel({this.status, this.last, this.message});

  bool? status;
  Last? last;
  String? message;

  factory LastEventModel.fromJson(Map<String, dynamic> json) => LastEventModel(
        status: json["status"],
        last: Last.fromJson(json["last"]),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "last": last!.toJson(),
      };
}

class Last {
  Last({
    this.time,
    this.type,
  });

  DateTime? time;
  int? type;

  factory Last.fromJson(Map<String, dynamic> json) => Last(
        time: DateTime.parse(json["time"]),
        type: json["type"],
      );

  Map<String, dynamic> toJson() => {
        "time": time!.toIso8601String(),
        "type": type,
      };
}
