class OfflineQrModel {
  OfflineQrModel({
    this.id,
    required this.processTime,
    required this.latitude,
    required this.longitude,
    required this.zone,
    required this.isQRUpload,
  });
  final int? id;
  final String? processTime;
  final double latitude;
  final double? longitude;
  final int? zone;
  final int isQRUpload;
  factory OfflineQrModel.fromMap(Map<String, dynamic> json) => OfflineQrModel(
        id: json['id'],
        processTime: json["processTime"].toString(),
        latitude: json["latitude"],
        longitude: json["longitude"],
        zone: json["zone"],
        isQRUpload: json['isQRUpload'],
      );

  Map<String, dynamic> offlineQRdataToMap() => {
        "id": id,
        "processTime": processTime.toString(),
        "latitude": latitude,
        "longitude": longitude,
        "zone": zone,
        "isQRUpload": isQRUpload,
      };
}
