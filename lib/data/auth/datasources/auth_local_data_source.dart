// vive_huanchaco/lib/features/auth/data/datasources/auth_local_data_source.dart
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vive_huanchaco/core/error/exceptions.dart';

abstract class AuthLocalDataSource {
  Future<void> cacheUserToken(String token);
  Future<String?> getUserToken();
  Future<void> deleteUserToken();
}

class AuthLocalDataSourceImpl implements AuthLocalDataSource {
  final SharedPreferences sharedPreferences;
  static const String CACHED_USER_TOKEN = 'CACHED_USER_TOKEN';

  AuthLocalDataSourceImpl({required this.sharedPreferences});

  @override
  Future<void> cacheUserToken(String token) {
    return sharedPreferences.setString(CACHED_USER_TOKEN, token);
  }

  @override
  Future<String?> getUserToken() {
    try {
      return Future.value(sharedPreferences.getString(CACHED_USER_TOKEN));
    } catch (e) {
      throw CacheException();
    }
  }

  @override
  Future<void> deleteUserToken() {
    return sharedPreferences.remove(CACHED_USER_TOKEN);
  }
}