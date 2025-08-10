import 'base_model.dart';

class AvailabilityModel {
  final OS? android;
  final OS? ios;

  AvailabilityModel({required this.android, required this.ios});

  factory AvailabilityModel.fromJson(Map<String, dynamic> json) {
    return AvailabilityModel(
      android: json["android"] == null ? null : OS.fromJson(json["android"]),
      ios: json["ios"] == null ? null : OS.fromJson(json["ios"]),
    );
  }

  Map<String, dynamic> toJson() => {
    "android": android?.toJson(),
    "ios": ios?.toJson(),
  };

  @override
  String toString() {
    return 'AvailabilityModel(android: $android, ios: $ios)';
  }
}

class OS {
  final bool? usable;
  final String? message;
  final int? version;
  final String? link;
  final bool? isRegister;

  OS({
    required this.usable,
    required this.message,
    required this.version,
    required this.link,
    required this.isRegister,
  });

  factory OS.fromJson(Map<String, dynamic> json) {
    return OS(
      usable: json["usable"],
      message: json["message"],
      version: json["version"],
      link: json["link"],
      isRegister: json["is_register"],
    );
  }

  Map<String, dynamic> toJson() => {
    "usable": usable,
    "message": message,
    "version": version,
    "link": link,
    "is_register": isRegister,
  };

  @override
  String toString() {
    return 'OS(usable: $usable, message: $message, version: $version, link: $link, isRegister: $isRegister)';
  }
}

typedef IsAvailableModel = BaseModel<AvailabilityModel>;
