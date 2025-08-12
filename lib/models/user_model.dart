import 'dart:convert';
import 'base_model.dart';

class UserModel {
  final int? id;
  final String? name;
  final String? surname;
  final String? email;
  final String? phone;
  final String? gender;
  final Role? role;
  final Company? company;
  final Department? department;
  final Settings? settings;
  final Shift? shift;
  final String? birthday;
  final String? profilePhoto;
  final String? tokenType;
  final String? accessToken;
  final int? expiresAt;
  final String? createdAt;

  UserModel({
    this.id,
    this.name,
    this.surname,
    this.email,
    this.phone,
    this.gender,
    this.role,
    this.company,
    this.department,
    this.settings,
    this.shift,
    this.birthday,
    this.profilePhoto,
    this.tokenType,
    this.accessToken,
    this.expiresAt,
    this.createdAt,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
      name: json['name'],
      surname: json['surname'],
      email: json['email'],
      phone: json['phone'],
      gender: json['gender'],
      role: json['role'] != null ? Role.fromJson(json['role']) : null,
      company: json['company'] != null
          ? Company.fromJson(json['company'])
          : null,
      department: json['department'] != null
          ? Department.fromJson(json['department'])
          : null,
      settings: json['settings'] != null
          ? Settings.fromJson(json['settings'])
          : null,
      shift: json['shift'] != null ? Shift.fromJson(json['shift']) : null,
      birthday: json['birthday'],
      profilePhoto: json['profile_photo'],
      tokenType: json['token_type'],
      accessToken: json['access_token'],
      expiresAt: json['expires_at'],
      createdAt: json['created_at'],
    );
  }

  static List<UserModel> fromJsonList(List<dynamic> jsonList) {
    return jsonList.map((json) => UserModel.fromJson(json)).toList();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['id'] = id;
    data['name'] = name;
    data['surname'] = surname;
    data['email'] = email;
    data['phone'] = phone;
    data['gender'] = gender;
    if (role != null) data['role'] = role!.toJson();
    if (company != null) data['company'] = company!.toJson();
    if (department != null) data['department'] = department!.toJson();
    if (settings != null) data['settings'] = settings!.toJson();
    if (shift != null) data['shift'] = shift!.toJson();
    data['birthday'] = birthday;
    data['profile_photo'] = profilePhoto;
    data['token_type'] = tokenType;
    data['access_token'] = accessToken;
    data['expires_at'] = expiresAt;
    data['created_at'] = createdAt;
    return data;
  }

  String get fullName => '${name ?? ''} ${surname ?? ''}'.trim();

  bool get hasToken => accessToken != null && accessToken!.isNotEmpty;

  @override
  String toString() {
    return 'UserModel(id: $id, name: $name, surname: $surname, email: $email)';
  }
}

class Role {
  final int? id;
  final String? name;
  final String? slug;
  final dynamic permissions;
  final int? isActive;
  final dynamic createdBy;
  final dynamic updatedBy;
  final dynamic deletedBy;
  final String? createdAt;
  final String? updatedAt;
  final String? deletedAt;

  Role({
    this.id,
    this.name,
    this.slug,
    this.permissions,
    this.isActive,
    this.createdBy,
    this.updatedBy,
    this.deletedBy,
    this.createdAt,
    this.updatedAt,
    this.deletedAt,
  });

  factory Role.fromJson(Map<String, dynamic> json) {
    return Role(
      id: json['id'],
      name: json['name'],
      slug: json['slug'],
      permissions: json['permissions'],
      isActive: json['is_active'],
      createdBy: json['created_by'],
      updatedBy: json['updated_by'],
      deletedBy: json['deleted_by'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
      deletedAt: json['deleted_at'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['id'] = id;
    data['name'] = name;
    data['slug'] = slug;
    data['permissions'] = permissions;
    data['is_active'] = isActive;
    data['created_by'] = createdBy;
    data['updated_by'] = updatedBy;
    data['deleted_by'] = deletedBy;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    data['deleted_at'] = deletedAt;
    return data;
  }

  @override
  String toString() =>
      'Role(id: $id, name: $name, slug: $slug, isActive: $isActive)';
}

class Company {
  final int? id;
  final String? name;
  final String? address;

  Company({this.id, this.name, this.address});

  factory Company.fromJson(Map<String, dynamic> json) {
    return Company(
      id: json['id'],
      name: json['name'],
      address: json['address'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['id'] = id;
    data['name'] = name;
    data['address'] = address;
    return data;
  }

  @override
  String toString() => 'Company(id: $id, name: $name, address: $address)';
}

class Department {
  final int? id;
  final String? name;

  Department({this.id, this.name});

  factory Department.fromJson(Map<String, dynamic> json) {
    return Department(id: json['id'], name: json['name']);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['id'] = id;
    data['name'] = name;
    return data;
  }

  @override
  String toString() => 'Department(id: $id, name: $name)';
}

class Settings {
  final bool? outside;

  Settings({this.outside});

  factory Settings.fromJson(Map<String, dynamic> json) {
    return Settings(outside: json['outside']);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['outside'] = outside;
    return data;
  }

  @override
  String toString() => 'Settings(outside: $outside)';
}

class Shift {
  final String? start;
  final String? end;
  final Tolerance? tolerance;

  Shift({this.start, this.end, this.tolerance});

  factory Shift.fromJson(Map<String, dynamic> json) {
    return Shift(
      start: json['start'],
      end: json['end'],
      tolerance: json['tolerance'] != null
          ? Tolerance.fromJson(json['tolerance'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['start'] = start;
    data['end'] = end;
    if (tolerance != null) data['tolerance'] = tolerance!.toJson();
    return data;
  }

  @override
  String toString() => 'Shift(start: $start, end: $end, tolerance: $tolerance)';
}

class Tolerance {
  final String? start;
  final String? end;

  Tolerance({this.start, this.end});

  factory Tolerance.fromJson(Map<String, dynamic> json) {
    return Tolerance(start: json['start'], end: json['end']);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['start'] = start;
    data['end'] = end;
    return data;
  }

  @override
  String toString() => 'Tolerance(start: $start, end: $end)';
}

typedef UserLoginModel = BaseModel<List<UserModel>>;

UserLoginModel userLoginModelFromJson(String str) {
  final json = jsonDecode(str);
  return BaseModel.fromJsonList(
    json,
    (jsonList) => UserModel.fromJsonList(jsonList),
  );
}

String userLoginModelToJson(UserLoginModel data) => json.encode(data.toJson());
