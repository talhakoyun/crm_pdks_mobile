import '../core/init/network/service/model_interface.dart';

class LogoutModel {
  String? message;
  bool? status;

  LogoutModel({this.message, this.status});

  LogoutModel.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};

    data['message'] = message;
    data['status'] = status;
    return data;
  }
}

class LogoutModelError extends IDataModel {
  String? message;
  bool? status;

  LogoutModelError({this.message, this.status});

  LogoutModelError.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['message'] = message;
    data['status'] = status;
    return data;
  }
}
