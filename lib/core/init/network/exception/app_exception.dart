class AppException implements Exception {
  final String? msg;

  AppException([this.msg]);

  @override
  String toString() {
    return '$msg';
  }
}

class FetchDataException extends AppException {
  FetchDataException([super.msg]);
}

class BadRequestException extends AppException {
  final Map<String, dynamic>? data;

  BadRequestException([super.msg, this.data]);
}

class UnauthorisedException extends AppException {
  UnauthorisedException([super.msg]);
}

class InvalidInputException extends AppException {
  InvalidInputException([super.msg]);
}
