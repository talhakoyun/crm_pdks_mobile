class ProfileModel {
  ProfileModel({
    required this.status,
    required this.message,
    required this.data,
  });

  final bool? status;
  final String? message;
  final Data? data;

  factory ProfileModel.fromJson(Map<String, dynamic> json) {
    return ProfileModel(
      status: json["status"],
      message: json["message"],
      data: json["data"] == null ? null : Data.fromJson(json["data"]),
    );
  }

  Map<String, dynamic> toJson() => {
    "status": status,
    "message": message,
    "data": data?.toJson(),
  };
}

class Data {
  Data({
    required this.id,
    required this.name,
    required this.surname,
    required this.email,
    required this.phone,
    required this.gender,
    required this.birthday,
    required this.createdAt,
  });

  final int? id;
  final String? name;
  final String? surname;
  final String? email;
  final String? phone;
  final String? gender;
  final dynamic birthday;
  final DateTime? createdAt;

  factory Data.fromJson(Map<String, dynamic> json) {
    return Data(
      id: json["id"],
      name: json["name"],
      surname: json["surname"],
      email: json["email"],
      phone: json["phone"],
      gender: json["gender"],
      birthday: json["birthday"],
      createdAt: DateTime.tryParse(json["created_at"] ?? ""),
    );
  }

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "surname": surname,
    "email": email,
    "phone": phone,
    "gender": gender,
    "birthday": birthday,
    "created_at": createdAt?.toIso8601String(),
  };
}
