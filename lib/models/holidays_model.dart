// ignore_for_file: unnecessary_null_in_if_null_operators

import 'dart:convert';

HolidayListModel holidaysModelFromJson(String str) =>
    HolidayListModel.fromJson(json.decode(str));

String holidaysModelToJson(HolidayListModel data) => json.encode(data.toJson());

class HolidayListModel {
  List<Data>? data;
  String? message;
  bool? status;

  HolidayListModel({this.data, this.message, this.status});

  HolidayListModel.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = <Data>[];
      json['data'].forEach((v) {
        data!.add(new Data.fromJson(v));
      });
    }
    message = json['message'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    data['message'] = this.message;
    data['status'] = this.status;
    return data;
  }
}

class Data {
  int? id;
  String? reason;
  String? address;
  String? startDate;
  String? endDate;
  int? type;
  String? typeText;
  int? confirm;
  String? confirmText;

  Data(
      {this.id,
      this.reason,
      this.address,
      this.startDate,
      this.endDate,
      this.type,
      this.typeText,
      this.confirm,
      this.confirmText});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    reason = json['reason'];
    address = json['address'];
    startDate = json['start_date'];
    endDate = json['end_date'];
    type = json['type'];
    typeText = json['type_text'];
    confirm = json['confirm'];
    confirmText = json['confirm_text'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['reason'] = this.reason;
    data['address'] = this.address;
    data['start_date'] = this.startDate;
    data['end_date'] = this.endDate;
    data['type'] = this.type;
    data['type_text'] = this.typeText;
    data['confirm'] = this.confirm;
    data['confirm_text'] = this.confirmText;
    return data;
  }
}
