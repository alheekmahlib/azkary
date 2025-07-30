// استثناءات مخصصة للتطبيق
// Custom exceptions for the app

class AppException implements Exception {
  final String message;
  final String? code;

  AppException(this.message, {this.code});

  @override
  String toString() =>
      'AppException: $message ${code != null ? '(Code: $code)' : ''}';
}

// استثناء الشبكة / Network exception
class NetworkException extends AppException {
  NetworkException(String message, {String? code}) : super(message, code: code);
}

// استثناء الخادم / Server exception
class ServerException extends AppException {
  ServerException(String message, {String? code}) : super(message, code: code);
}

// استثناء البيانات / Data exception
class DataException extends AppException {
  DataException(String message, {String? code}) : super(message, code: code);
}

// استثناء التخزين / Storage exception
class StorageException extends AppException {
  StorageException(String message, {String? code}) : super(message, code: code);
}

// استثناء المصادقة / Authentication exception
class AuthException extends AppException {
  AuthException(String message, {String? code}) : super(message, code: code);
}

// معالج الأخطاء / Error handler
class ErrorHandler {
  static String getErrorMessage(dynamic error) {
    if (error is AppException) {
      return error.message;
    } else if (error is NetworkException) {
      return 'خطأ في الاتصال بالشبكة';
    } else if (error is ServerException) {
      return 'خطأ في الخادم';
    } else if (error is DataException) {
      return 'خطأ في البيانات';
    } else if (error is StorageException) {
      return 'خطأ في التخزين';
    } else if (error is AuthException) {
      return 'خطأ في المصادقة';
    } else {
      return 'حدث خطأ غير متوقع';
    }
  }
}
