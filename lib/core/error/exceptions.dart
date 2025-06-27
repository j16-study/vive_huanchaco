// vive_huanchaco/lib/core/error/exceptions.dart
class ServerException implements Exception {
  final String message;
  const ServerException({this.message = 'Error del servidor'});
}

class CacheException implements Exception {
  final String message;
  const CacheException({this.message = 'Error de caché'});
}

class AuthException implements Exception {
  final String message;
  AuthException(this.message);
}
