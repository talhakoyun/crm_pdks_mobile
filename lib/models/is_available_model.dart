class IsAvailableModel {
  IsAvailableModel({
    required this.status,
    required this.data,
    required this.message,
  });

  final bool? status;
  final Data? data;
  final String? message;

  factory IsAvailableModel.fromJson(Map<String, dynamic> json) {
    return IsAvailableModel(
      status: json["status"],
      data: json["data"] == null ? null : Data.fromJson(json["data"]),
      message: json["message"],
    );
  }

  Map<String, dynamic> toJson() => {
    "status": status,
    "data": data?.toJson(),
    "message": message,
  };
}

class Data {
  Data({required this.android, required this.ios});

  final OS? android;
  final OS? ios;

  factory Data.fromJson(Map<String, dynamic> json) {
    return Data(
      android: json["android"] == null ? null : OS.fromJson(json["android"]),
      ios: json["ios"] == null ? null : OS.fromJson(json["ios"]),
    );
  }

  Map<String, dynamic> toJson() => {
    "android": android?.toJson(),
    "ios": ios?.toJson(),
  };
}

class OS {
  OS({
    required this.usable,
    required this.message,
    required this.version,
    required this.link,
    required this.isRegister,
  });

  final bool? usable;
  final String? message;
  final int? version;
  final String? link;
  final bool? isRegister;

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
}
