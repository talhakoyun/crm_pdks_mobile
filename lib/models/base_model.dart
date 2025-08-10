class BaseModel<T> {
  final T? data;
  final String? message;
  final bool? status;

  BaseModel({this.data, this.message, this.status});

  factory BaseModel.fromJson(
    Map<String, dynamic> json,
    T Function(Map<String, dynamic>) fromJsonT,
  ) {
    return BaseModel(
      data: json['data'] != null ? fromJsonT(json['data']) : null,
      message: json['message'],
      status: json['status'],
    );
  }

  factory BaseModel.fromJsonList(
    Map<String, dynamic> json,
    T Function(List<Map<String, dynamic>>) fromJsonListT,
  ) {
    return BaseModel(
      data: json['data'] != null
          ? fromJsonListT(List<Map<String, dynamic>>.from(json['data']))
          : null,
      message: json['message'],
      status: json['status'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> result = <String, dynamic>{};
    result['status'] = status;
    result['message'] = message;
    if (data != null) {
      if (data is Map<String, dynamic>) {
        result['data'] = data;
      } else {
        try {
          result['data'] = (data as dynamic).toJson();
        } catch (e) {
          result['data'] = data;
        }
      }
    }
    return result;
  }

  bool get isSuccess => status == true;

  bool get hasData => data != null;

  @override
  String toString() {
    return 'BaseModel(status: $status, message: $message, data: $data)';
  }
}
