import 'dart:convert';
import 'base_model.dart';

class HolidayDataModel {
  final int? id;
  final String? reason;
  final String? address;
  final String? startDate;
  final String? endDate;
  final int? type;
  final String? typeText;
  final int? confirm;
  final String? confirmText;

  HolidayDataModel({
    this.id,
    this.reason,
    this.address,
    this.startDate,
    this.endDate,
    this.type,
    this.typeText,
    this.confirm,
    this.confirmText,
  });

  factory HolidayDataModel.fromJson(Map<String, dynamic> json) {
    return HolidayDataModel(
      id: json['id'],
      reason: json['reason'],
      address: json['address'],
      startDate: json['start_date'],
      endDate: json['end_date'],
      type: json['type'],
      typeText: json['type_text'],
      confirm: json['confirm'],
      confirmText: json['confirm_text'],
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
    data['reason'] = reason;
    data['address'] = address;
    data['start_date'] = startDate;
    data['end_date'] = endDate;
    data['type'] = type;
    data['type_text'] = typeText;
    data['confirm'] = confirm;
    data['confirm_text'] = confirmText;
    return data;
  }

  bool get isApproved => confirm == 1;

  bool get isRejected => confirm == 0;

  bool get isPending => confirm == null;

  @override
  String toString() {
    return 'HolidayDataModel(id: $id, reason: $reason, startDate: $startDate, endDate: $endDate, confirm: $confirm)';
  }
}

/// Holiday List response için BaseModel tip tanımı
/// BaseModel<List<HolidayDataModel>> olarak kullanılır
typedef HolidayListModel = BaseModel<List<HolidayDataModel>>;

/// JSON string'den HolidayListModel oluşturmak için helper fonksiyon
HolidayListModel holidaysModelFromJson(String str) {
  final json = jsonDecode(str);
  return BaseModel.fromJsonList(
    json,
    (jsonList) => HolidayDataModel.fromJsonList(jsonList),
  );
}

/// HolidayListModel'i JSON string'e çevirmek için helper fonksiyon
String holidaysModelToJson(HolidayListModel data) => json.encode(data.toJson());
