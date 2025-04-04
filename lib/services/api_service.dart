import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:vishv_umiyadham_foundation/models/user_model.dart';
import 'package:vishv_umiyadham_foundation/services/storage_service.dart';
import 'package:vishv_umiyadham_foundation/utils/constants.dart';

class ApiService {
  final StorageService _storageService = StorageService();

  // Helper method to get auth headers
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

  // Handle API response
  dynamic _handleResponse(http.Response response) {
    if (response.statusCode >= 200 && response.statusCode < 300) {
      return json.decode(response.body);
    } else {
      final error = json.decode(response.body);
      throw Exception(error['message'] ?? 'Something went wrong');
    }
  }

  // Register user
  Future<Map<String, dynamic>> register(String name, String email, String phone,
      String password, String role) async {
    final response = await http.post(
      Uri.parse('${ApiConstants.baseUrl}${ApiConstants.register}'),
      headers: await _getHeaders(requireAuth: false),
      body: json.encode({
        'name': name,
        'email': email,
        'phone': phone,
        'password': password,
        'role': role,
      }),
    );

    final data = _handleResponse(response);

    // Save token and user data
    await _storageService.saveToken(data['token']);
    await _storageService.saveUser(json.encode(data['user']));

    return data;
  }

  // Login user
  Future<Map<String, dynamic>> login(String email, String password) async {
    final response = await http.post(
      Uri.parse('${ApiConstants.baseUrl}${ApiConstants.login}'),
      headers: await _getHeaders(requireAuth: false),
      body: json.encode({
        'email': email,
        'password': password,
      }),
    );

    final data = _handleResponse(response);

    // Save token and user data
    await _storageService.saveToken(data['token']);
    await _storageService.saveUser(json.encode(data['user']));

    return data;
  }

  // Logout user
  Future<void> logout() async {
    try {
      await http.post(
        Uri.parse('${ApiConstants.baseUrl}${ApiConstants.logout}'),
        headers: await _getHeaders(),
      );
    } catch (e) {
      // Even if the API call fails, we still want to clear local storage
      print('Logout API error: $e');
    } finally {
      await _storageService.clearAll();
    }
  }

  // Get user profile
  Future<User> getUserProfile() async {
    final response = await http.get(
      Uri.parse('${ApiConstants.baseUrl}${ApiConstants.userProfile}'),
      headers: await _getHeaders(),
    );

    final data = _handleResponse(response);
    return User.fromJson(data['user']);
  }

  // Get teams
  Future<List<dynamic>> getTeams() async {
    final response = await http.get(
      Uri.parse('${ApiConstants.baseUrl}${ApiConstants.teams}'),
      headers: await _getHeaders(),
    );

    return _handleResponse(response);
  }

  // Create team
  Future<dynamic> createTeam(String name, String captainId) async {
    final response = await http.post(
      Uri.parse('${ApiConstants.baseUrl}${ApiConstants.teams}'),
      headers: await _getHeaders(),
      body: json.encode({
        'name': name,
        'captainId': captainId,
      }),
    );

    return _handleResponse(response);
  }

  // Invite player
  Future<dynamic> invitePlayer(String teamId, String playerUniqueId) async {
    final response = await http.post(
      Uri.parse('${ApiConstants.baseUrl}${ApiConstants.invitePlayer}'),
      headers: await _getHeaders(),
      body: json.encode({
        'teamId': teamId,
        'playerUniqueId': playerUniqueId,
      }),
    );

    return _handleResponse(response);
  }

  // Get matches
  Future<List<dynamic>> getMatches() async {
    final response = await http.get(
      Uri.parse('${ApiConstants.baseUrl}${ApiConstants.matches}'),
      headers: await _getHeaders(),
    );

    return _handleResponse(response);
  }

  // Process payment
  Future<dynamic> processPayment(String captainId, double amount) async {
    final response = await http.post(
      Uri.parse('${ApiConstants.baseUrl}${ApiConstants.payments}'),
      headers: await _getHeaders(),
      body: json.encode({
        'captainId': captainId,
        'amount': amount,
      }),
    );

    return _handleResponse(response);
  }

  // Approve captain (Admin only)
  Future<dynamic> approveCaptain(String captainId) async {
    final response = await http.post(
      Uri.parse('${ApiConstants.baseUrl}${ApiConstants.approveCaptain}'),
      headers: await _getHeaders(),
      body: json.encode({
        'captainId': captainId,
      }),
    );

    return _handleResponse(response);
  }
}
