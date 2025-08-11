import 'dart:convert';
import 'base_model.dart';

class HolidayTypeInfo {
  final int? id;
  final String? title;
  final String? iconName;

  HolidayTypeInfo({this.id, this.title, this.iconName});

  factory HolidayTypeInfo.fromJson(Map<String, dynamic> json) {
    return HolidayTypeInfo(
      id: json['id'],
      title: json['title'],
      iconName: json['icon_name'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['title'] = title;
    data['icon_name'] = iconName;
    return data;
  }

  @override
  String toString() =>
      'HolidayTypeInfo(id: $id, title: $title, iconName: $iconName)';
}

class BranchInfo {
  final int? id;
  final String? title;

  BranchInfo({this.id, this.title});

  factory BranchInfo.fromJson(Map<String, dynamic> json) {
    return BranchInfo(id: json['id'], title: json['title']);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['title'] = title;
    return data;
  }

  @override
  String toString() => 'BranchInfo(id: $id, title: $title)';
}

class CompanyInfo {
  final int? id;
  final String? title;

  CompanyInfo({this.id, this.title});

  factory CompanyInfo.fromJson(Map<String, dynamic> json) {
    return CompanyInfo(id: json['id'], title: json['title']);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['title'] = title;
    return data;
  }

  @override
  String toString() => 'CompanyInfo(id: $id, title: $title)';
}

class HolidayDataModel {
  final int? id;
  final String? startDate;
  final String? endDate;
  final int? duration;
  final HolidayTypeInfo? type;
  final int? status;
  final String? statusText;
  final String? note;
  final BranchInfo? branch;
  final CompanyInfo? company;

  HolidayDataModel({
    this.id,
    this.startDate,
    this.endDate,
    this.duration,
    this.type,
    this.status,
    this.statusText,
    this.note,
    this.branch,
    this.company,
  });

  factory HolidayDataModel.fromJson(Map<String, dynamic> json) {
    return HolidayDataModel(
      id: json['id'],
      startDate: json['start_date'],
      endDate: json['end_date'],
      duration: json['duration'],
      type: json['type'] != null
          ? HolidayTypeInfo.fromJson(json['type'])
          : null,
      status: json['status'],
      statusText: json['status_text'],
      note: json['note'],
      branch: json['branch'] != null
          ? BranchInfo.fromJson(json['branch'])
          : null,
      company: json['company'] != null
          ? CompanyInfo.fromJson(json['company'])
          : null,
    );
  }

  static List<HolidayDataModel> fromJsonList(
    List<Map<String, dynamic>> jsonList,
  ) {
    return jsonList.map((json) => HolidayDataModel.fromJson(json)).toList();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['start_date'] = startDate;
    data['end_date'] = endDate;
    data['duration'] = duration;
    data['type'] = type?.toJson();
    data['status'] = status;
    data['status_text'] = statusText;
    data['note'] = note;
    data['branch'] = branch?.toJson();
    data['company'] = company?.toJson();
    return data;
  }

  bool get isApproved => status == 1;

  bool get isRejected => status == 2;

  bool get isPending => status == 0;

  @override
  String toString() {
    return 'HolidayDataModel(id: $id, startDate: $startDate, endDate: $endDate, duration: $duration, status: $status, branch: $branch, company: $company)';
  }
}

typedef HolidayListModel = BaseModel<List<HolidayDataModel>>;

HolidayListModel holidaysModelFromJson(String str) {
  final json = jsonDecode(str);
  return BaseModel.fromJsonList(
    json,
    (jsonList) => HolidayDataModel.fromJsonList(jsonList),
  );
}

String holidaysModelToJson(HolidayListModel data) => json.encode(data.toJson());
