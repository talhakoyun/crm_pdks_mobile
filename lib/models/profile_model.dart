class ProfileModel {
  bool? status;
  String? message;
  List<Data>? data;

  ProfileModel({this.status, this.message, this.data});

  ProfileModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    if (json['data'] != null) {
      data = <Data>[];
      json['data'].forEach((v) {
        data!.add(Data.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    data['message'] = message;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Data {
  int? id;
  String? name;
  String? surname;
  String? email;
  String? phone;
  Role? role;
  Null? company;
  Department? department;
  Settings? settings;
  String? profilePhoto;
  String? tokenType;
  String? accessToken;
  int? expiresAt;

  Data({
    this.id,
    this.name,
    this.surname,
    this.email,
    this.phone,
    this.role,
    this.company,
    this.department,
    this.settings,
    this.profilePhoto,
    this.tokenType,
    this.accessToken,
    this.expiresAt,
  });

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    surname = json['surname'];
    email = json['email'];
    phone = json['phone'];
    role = json['role'] != null ? Role.fromJson(json['role']) : null;
    company = json['company'];
    department = json['department'] != null
        ? Department.fromJson(json['department'])
        : null;
    settings = json['settings'] != null
        ? Settings.fromJson(json['settings'])
        : null;
    profilePhoto = json['profile_photo'];
    tokenType = json['token_type'];
    accessToken = json['access_token'];
    expiresAt = json['expires_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['surname'] = surname;
    data['email'] = email;
    data['phone'] = phone;
    if (role != null) {
      data['role'] = role!.toJson();
    }
    data['company'] = company;
    if (department != null) {
      data['department'] = department!.toJson();
    }
    if (settings != null) {
      data['settings'] = settings!.toJson();
    }
    data['profile_photo'] = profilePhoto;
    data['token_type'] = tokenType;
    data['access_token'] = accessToken;
    data['expires_at'] = expiresAt;
    return data;
  }
}

class Role {
  int? id;
  String? name;
  Null? slug;
  Null? permissions;
  int? isActive;
  Null? createdBy;
  Null? updatedBy;
  Null? deletedBy;
  Null? createdAt;
  Null? updatedAt;
  Null? deletedAt;

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

  Role.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    slug = json['slug'];
    permissions = json['permissions'];
    isActive = json['is_active'];
    createdBy = json['created_by'];
    updatedBy = json['updated_by'];
    deletedBy = json['deleted_by'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    deletedAt = json['deleted_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
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
}

class Department {
  Null? id;
  Null? name;

  Department({this.id, this.name});

  Department.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    return data;
  }
}

class Settings {
  bool? outside;
  bool? offline;
  bool? zone;

  Settings({this.outside, this.offline, this.zone});

  Settings.fromJson(Map<String, dynamic> json) {
    outside = json['outside'];
    offline = json['offline'];
    zone = json['zone'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['outside'] = outside;
    data['offline'] = offline;
    data['zone'] = zone;
    return data;
  }
}
