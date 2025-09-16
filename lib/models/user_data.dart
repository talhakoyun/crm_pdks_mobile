class UserData {
  final String? id;
  final String? username;
  final String? gender;
  final String? role;
  final String? companyName;
  final String? companyAddress;
  final String? startDate;
  final String? endDate;
  final String? startTDate;
  final String? endTDate;
  final String? department;
  final String? phone;
  final String? email;
  final bool? outside;
  final String? accessToken;
  final String? refreshToken;

  UserData({
    this.id,
    this.username,
    this.gender,
    this.role,
    this.companyName,
    this.companyAddress,
    this.startDate,
    this.endDate,
    this.startTDate,
    this.endTDate,
    this.department,
    this.phone,
    this.email,
    this.outside,
    this.accessToken,
    this.refreshToken,
  });

  UserData copyWith({
    String? id,
    String? username,
    String? gender,
    String? role,
    String? companyName,
    String? companyAddress,
    String? startDate,
    String? endDate,
    String? startTDate,
    String? endTDate,
    String? department,
    String? phone,
    String? email,
    bool? outside,
    String? accessToken,
    String? refreshToken,
  }) {
    return UserData(
      id: id ?? this.id,
      username: username ?? this.username,
      gender: gender ?? this.gender,
      role: role ?? this.role,
      companyName: companyName ?? this.companyName,
      companyAddress: companyAddress ?? this.companyAddress,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      startTDate: startTDate ?? this.startTDate,
      endTDate: endTDate ?? this.endTDate,
      department: department ?? this.department,
      phone: phone ?? this.phone,
      email: email ?? this.email,
      outside: outside ?? this.outside,
      accessToken: accessToken ?? this.accessToken,
      refreshToken: refreshToken ?? this.refreshToken,
    );
  }

  factory UserData.fromJson(Map<String, dynamic> json) {
    return UserData(
      id: json['id'] as String?,
      username: json['username'] as String?,
      gender: json['gender'] as String?,
      role: json['role'] as String?,
      companyName: json['companyName'] as String?,
      companyAddress: json['companyAddress'] as String?,
      startDate: json['startDate'] as String?,
      endDate: json['endDate'] as String?,
      startTDate: json['startTDate'] as String?,
      endTDate: json['endTDate'] as String?,
      department: json['department'] as String?,
      phone: json['phone'] as String?,
      email: json['email'] as String?,
      outside: json['outside'] as bool?,
      accessToken: json['accessToken'] as String?,
      refreshToken: json['refreshToken'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'username': username,
      'gender': gender,
      'role': role,
      'companyName': companyName,
      'companyAddress': companyAddress,
      'startDate': startDate,
      'endDate': endDate,
      'startTDate': startTDate,
      'endTDate': endTDate,
      'department': department,
      'phone': phone,
      'email': email,
      'outside': outside,
      'accessToken': accessToken,
      'refreshToken': refreshToken,
    };
  }
}
