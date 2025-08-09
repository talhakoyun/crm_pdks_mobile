class OfflineUserModel {
  OfflineUserModel({
    required this.inTime,
    required this.outTime,
    required this.isOutSide,
    required this.lateReason,
    required this.earlyReason,
    required this.latitude,
    required this.longitude,
    required this.isUpload,
    this.id,
  });
  final int? id;
  final String? inTime;
  final String? outTime;
  final String? lateReason;
  final String? earlyReason;
  final String? isOutSide;
  final double latitude;
  final double? longitude;
  final int? isUpload;

  factory OfflineUserModel.fromMap(Map<String, dynamic> json) =>
      OfflineUserModel(
          inTime: json["inTime"].toString(),
          outTime: json["outTime"].toString(),
          lateReason: json["lateReason"].toString(),
          earlyReason: json["earlyReason"].toString(),
          isOutSide: json["isOutSide"],
          latitude: json["latitude"],
          longitude: json["longitude"],
          isUpload: json['isUpload'],
          id: json['id']);

  Map<String, dynamic> offlineUserdataToMap() => {
        "inTime": inTime.toString(),
        "outTime": outTime.toString(),
        "lateReason": lateReason,
        "earlyReason": earlyReason,
        "isOutSide": isOutSide,
        "latitude": latitude,
        "longitude": longitude,
        "isUpload": isUpload,
        "id": id
      };
}
