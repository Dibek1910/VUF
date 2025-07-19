import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:vishv_umiyadham_foundation/models/user_model.dart';
import 'package:vishv_umiyadham_foundation/services/storage_service.dart';
import 'package:vishv_umiyadham_foundation/utils/constants.dart';

class ApiService {
  final StorageService _storageService = StorageService();

  Future<Map<String, String>> _getHeaders({bool requireAuth = true}) async {
    Map<String, String> headers = {
      'Content-Type': 'application/json',
    };

    if (requireAuth) {
      final token = await _storageService.getToken();
      if (token != null) {
        headers['Authorization'] = 'Bearer $token';
      }
    }

    return headers;
  }

  dynamic _handleResponse(http.Response response) {
    if (response.statusCode >= 200 && response.statusCode < 300) {
      if (response.body.isEmpty) {
        return {};
      }
      return json.decode(response.body);
    } else {
      final error = response.body.isNotEmpty
          ? json.decode(response.body)
          : {'message': 'Unknown error occurred'};
      throw Exception(error['message'] ?? 'Something went wrong');
    }
  }

  Future<Map<String, dynamic>> register(String name, String email, String phone,
      String password, String role) async {
    try {
      final response = await http
          .post(
            Uri.parse('${ApiConstants.baseUrl}${ApiConstants.register}'),
            headers: await _getHeaders(requireAuth: false),
            body: json.encode({
              'name': name,
              'email': email,
              'phone': phone,
              'password': password,
              'role': role,
            }),
          )
          .timeout(Duration(seconds: AppConstants.requestTimeout));

      final data = _handleResponse(response);
      await _storageService.saveToken(data['token']);
      await _storageService.saveUser(json.encode(data['user']));
      return data;
    } catch (e) {
      throw Exception('Registration failed: ${e.toString()}');
    }
  }

  Future<Map<String, dynamic>> login(String email, String password) async {
    try {
      final response = await http
          .post(
            Uri.parse('${ApiConstants.baseUrl}${ApiConstants.login}'),
            headers: await _getHeaders(requireAuth: false),
            body: json.encode({
              'email': email,
              'password': password,
            }),
          )
          .timeout(Duration(seconds: AppConstants.requestTimeout));

      final data = _handleResponse(response);
      await _storageService.saveToken(data['token']);
      await _storageService.saveUser(json.encode(data['user']));
      return data;
    } catch (e) {
      throw Exception('Login failed: ${e.toString()}');
    }
  }

  Future<void> logout() async {
    try {
      await http
          .post(
            Uri.parse('${ApiConstants.baseUrl}${ApiConstants.logout}'),
            headers: await _getHeaders(),
          )
          .timeout(Duration(seconds: AppConstants.requestTimeout));
    } catch (e) {
      print('Logout API error: $e');
    } finally {
      await _storageService.clearAll();
    }
  }

  Future<User> getUserProfile() async {
    try {
      final response = await http
          .get(
            Uri.parse('${ApiConstants.baseUrl}${ApiConstants.userProfile}'),
            headers: await _getHeaders(),
          )
          .timeout(Duration(seconds: AppConstants.requestTimeout));

      final data = _handleResponse(response);
      return User.fromJson(data);
    } catch (e) {
      throw Exception('Failed to get user profile: ${e.toString()}');
    }
  }
}
