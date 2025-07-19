import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vishv_umiyadham_foundation/utils/constants.dart';

class StorageService {
  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();

  Future<void> saveToken(String token) async {
    await _secureStorage.write(key: StorageConstants.token, value: token);
  }

  Future<String?> getToken() async {
    return await _secureStorage.read(key: StorageConstants.token);
  }

  Future<void> saveUser(String userData) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(StorageConstants.user, userData);
  }

  Future<String?> getUser() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(StorageConstants.user);
  }

  Future<bool> isLoggedIn() async {
    final token = await getToken();
    return token != null;
  }

  Future<void> clearAll() async {
    await _secureStorage.deleteAll();
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }
}
