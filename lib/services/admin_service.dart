import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:vishv_umiyadham_foundation/services/storage_service.dart';
import 'package:vishv_umiyadham_foundation/utils/constants.dart';

class AdminService {
  final StorageService _storageService = StorageService();

  Future<Map<String, String>> _getHeaders() async {
    Map<String, String> headers = {
      'Content-Type': 'application/json',
    };

    final token = await _storageService.getToken();
    if (token != null) {
      headers['Authorization'] = 'Bearer $token';
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

  Future<Map<String, dynamic>> getAdminDashboard() async {
    try {
      final response = await http
          .get(
            Uri.parse('${ApiConstants.baseUrl}${ApiConstants.adminDashboard}'),
            headers: await _getHeaders(),
          )
          .timeout(Duration(seconds: AppConstants.requestTimeout));

      return _handleResponse(response);
    } catch (e) {
      throw Exception('Failed to fetch admin dashboard: ${e.toString()}');
    }
  }

  Future<List<dynamic>> getPendingCaptains() async {
    try {
      final response = await http
          .get(
            Uri.parse(
                '${ApiConstants.baseUrl}${ApiConstants.adminPendingCaptains}'),
            headers: await _getHeaders(),
          )
          .timeout(Duration(seconds: AppConstants.requestTimeout));

      return _handleResponse(response);
    } catch (e) {
      throw Exception('Failed to fetch pending captains: ${e.toString()}');
    }
  }

  Future<dynamic> approveCaptain(String captainId) async {
    try {
      final response = await http
          .post(
            Uri.parse(
                '${ApiConstants.baseUrl}${ApiConstants.adminApproveCaptain}'),
            headers: await _getHeaders(),
            body: json.encode({
              'captainId': captainId,
            }),
          )
          .timeout(Duration(seconds: AppConstants.requestTimeout));

      return _handleResponse(response);
    } catch (e) {
      throw Exception('Failed to approve captain: ${e.toString()}');
    }
  }

  Future<dynamic> rejectCaptain(String captainId) async {
    try {
      final response = await http
          .post(
            Uri.parse(
                '${ApiConstants.baseUrl}${ApiConstants.adminRejectCaptain}'),
            headers: await _getHeaders(),
            body: json.encode({
              'captainId': captainId,
            }),
          )
          .timeout(Duration(seconds: AppConstants.requestTimeout));

      return _handleResponse(response);
    } catch (e) {
      throw Exception('Failed to reject captain: ${e.toString()}');
    }
  }

  Future<List<dynamic>> getAllTeams() async {
    try {
      final response = await http
          .get(
            Uri.parse('${ApiConstants.baseUrl}${ApiConstants.adminTeams}'),
            headers: await _getHeaders(),
          )
          .timeout(Duration(seconds: AppConstants.requestTimeout));

      return _handleResponse(response);
    } catch (e) {
      throw Exception('Failed to fetch teams: ${e.toString()}');
    }
  }

  Future<List<dynamic>> getPendingRemovals() async {
    try {
      final response = await http
          .get(
            Uri.parse(
                '${ApiConstants.baseUrl}${ApiConstants.adminPendingRemovals}'),
            headers: await _getHeaders(),
          )
          .timeout(Duration(seconds: AppConstants.requestTimeout));

      return _handleResponse(response);
    } catch (e) {
      throw Exception('Failed to fetch pending removals: ${e.toString()}');
    }
  }

  Future<dynamic> approvePlayerRemoval(String teamId) async {
    try {
      final response = await http
          .post(
            Uri.parse(
                '${ApiConstants.baseUrl}${ApiConstants.adminApproveRemoval}'),
            headers: await _getHeaders(),
            body: json.encode({
              'teamId': teamId,
            }),
          )
          .timeout(Duration(seconds: AppConstants.requestTimeout));

      return _handleResponse(response);
    } catch (e) {
      throw Exception('Failed to approve player removal: ${e.toString()}');
    }
  }

  Future<dynamic> rejectPlayerRemoval(String teamId) async {
    try {
      final response = await http
          .post(
            Uri.parse(
                '${ApiConstants.baseUrl}${ApiConstants.adminRejectRemoval}'),
            headers: await _getHeaders(),
            body: json.encode({
              'teamId': teamId,
            }),
          )
          .timeout(Duration(seconds: AppConstants.requestTimeout));

      return _handleResponse(response);
    } catch (e) {
      throw Exception('Failed to reject player removal: ${e.toString()}');
    }
  }

  Future<List<dynamic>> getAllMatches() async {
    try {
      final response = await http
          .get(
            Uri.parse('${ApiConstants.baseUrl}${ApiConstants.adminMatches}'),
            headers: await _getHeaders(),
          )
          .timeout(Duration(seconds: AppConstants.requestTimeout));

      return _handleResponse(response);
    } catch (e) {
      throw Exception('Failed to fetch matches: ${e.toString()}');
    }
  }

  Future<dynamic> createMatch(String team1Id, String team2Id,
      DateTime matchDate, String location, String description) async {
    try {
      final response = await http
          .post(
            Uri.parse('${ApiConstants.baseUrl}${ApiConstants.adminMatches}'),
            headers: await _getHeaders(),
            body: json.encode({
              'team1Id': team1Id,
              'team2Id': team2Id,
              'matchDate': matchDate.toIso8601String(),
              'location': location,
              'description': description,
            }),
          )
          .timeout(Duration(seconds: AppConstants.requestTimeout));

      return _handleResponse(response);
    } catch (e) {
      throw Exception('Failed to create match: ${e.toString()}');
    }
  }

  Future<dynamic> updateMatchScore(
      String matchId, String teamId, int score) async {
    try {
      final response = await http
          .post(
            Uri.parse(
                '${ApiConstants.baseUrl}${ApiConstants.adminUpdateScore}'),
            headers: await _getHeaders(),
            body: json.encode({
              'matchId': matchId,
              'teamId': teamId,
              'score': score,
            }),
          )
          .timeout(Duration(seconds: AppConstants.requestTimeout));

      return _handleResponse(response);
    } catch (e) {
      throw Exception('Failed to update match score: ${e.toString()}');
    }
  }

  Future<dynamic> updateMatchStatus(String matchId, String status) async {
    try {
      final response = await http
          .post(
            Uri.parse(
                '${ApiConstants.baseUrl}${ApiConstants.adminUpdateStatus}'),
            headers: await _getHeaders(),
            body: json.encode({
              'matchId': matchId,
              'status': status,
            }),
          )
          .timeout(Duration(seconds: AppConstants.requestTimeout));

      return _handleResponse(response);
    } catch (e) {
      throw Exception('Failed to update match status: ${e.toString()}');
    }
  }

  Future<List<dynamic>> getAllUsers() async {
    try {
      final response = await http
          .get(
            Uri.parse('${ApiConstants.baseUrl}${ApiConstants.adminUsers}'),
            headers: await _getHeaders(),
          )
          .timeout(Duration(seconds: AppConstants.requestTimeout));

      return _handleResponse(response);
    } catch (e) {
      throw Exception('Failed to fetch users: ${e.toString()}');
    }
  }

  Future<dynamic> deleteUser(String userId) async {
    try {
      final response = await http
          .delete(
            Uri.parse(
                '${ApiConstants.baseUrl}${ApiConstants.adminUsers}/$userId'),
            headers: await _getHeaders(),
          )
          .timeout(Duration(seconds: AppConstants.requestTimeout));

      return _handleResponse(response);
    } catch (e) {
      throw Exception('Failed to delete user: ${e.toString()}');
    }
  }

  Future<dynamic> deleteTeam(String teamId) async {
    try {
      final response = await http
          .delete(
            Uri.parse(
                '${ApiConstants.baseUrl}${ApiConstants.adminTeams}/$teamId'),
            headers: await _getHeaders(),
          )
          .timeout(Duration(seconds: AppConstants.requestTimeout));

      return _handleResponse(response);
    } catch (e) {
      throw Exception('Failed to delete team: ${e.toString()}');
    }
  }
}
