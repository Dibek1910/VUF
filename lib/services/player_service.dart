import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:vishv_umiyadham_foundation/models/team_model.dart';
import 'package:vishv_umiyadham_foundation/models/match_model.dart';
import 'package:vishv_umiyadham_foundation/services/storage_service.dart';
import 'package:vishv_umiyadham_foundation/utils/constants.dart';

class PlayerService {
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

  Future<List<dynamic>> getTeamInvitations() async {
    try {
      final response = await http
          .get(
            Uri.parse(
                '${ApiConstants.baseUrl}${ApiConstants.playerInvitations}'),
            headers: await _getHeaders(),
          )
          .timeout(const Duration(seconds: AppConstants.requestTimeout));

      return _handleResponse(response);
    } catch (e) {
      throw Exception('Failed to fetch team invitations: ${e.toString()}');
    }
  }

  Future<dynamic> acceptTeamInvitation(String teamId) async {
    try {
      final response = await http
          .post(
            Uri.parse(
                '${ApiConstants.baseUrl}${ApiConstants.playerAcceptInvitation}'),
            headers: await _getHeaders(),
            body: json.encode({
              'teamId': teamId,
            }),
          )
          .timeout(const Duration(seconds: AppConstants.requestTimeout));

      return _handleResponse(response);
    } catch (e) {
      throw Exception('Failed to accept team invitation: ${e.toString()}');
    }
  }

  Future<dynamic> declineTeamInvitation(String teamId) async {
    try {
      final response = await http
          .post(
            Uri.parse(
                '${ApiConstants.baseUrl}${ApiConstants.playerDeclineInvitation}'),
            headers: await _getHeaders(),
            body: json.encode({
              'teamId': teamId,
            }),
          )
          .timeout(const Duration(seconds: AppConstants.requestTimeout));

      return _handleResponse(response);
    } catch (e) {
      throw Exception('Failed to decline team invitation: ${e.toString()}');
    }
  }

  Future<Team?> getPlayerTeam() async {
    try {
      final response = await http
          .get(
            Uri.parse('${ApiConstants.baseUrl}${ApiConstants.playerTeam}'),
            headers: await _getHeaders(),
          )
          .timeout(const Duration(seconds: AppConstants.requestTimeout));

      final data = _handleResponse(response);
      return Team.fromJson(data);
    } catch (e) {
      if (e.toString().contains('not part of any team')) {
        return null;
      }
      throw Exception('Failed to fetch player team: ${e.toString()}');
    }
  }

  Future<List<Match>> getPlayerMatches() async {
    try {
      final response = await http
          .get(
            Uri.parse('${ApiConstants.baseUrl}${ApiConstants.playerMatches}'),
            headers: await _getHeaders(),
          )
          .timeout(const Duration(seconds: AppConstants.requestTimeout));

      final data = _handleResponse(response);
      return (data as List).map((match) => Match.fromJson(match)).toList();
    } catch (e) {
      throw Exception('Failed to fetch player matches: ${e.toString()}');
    }
  }

  Future<Map<String, dynamic>> getPlayerDashboard() async {
    try {
      final response = await http
          .get(
            Uri.parse('${ApiConstants.baseUrl}${ApiConstants.playerDashboard}'),
            headers: await _getHeaders(),
          )
          .timeout(const Duration(seconds: AppConstants.requestTimeout));

      return _handleResponse(response);
    } catch (e) {
      throw Exception('Failed to fetch player dashboard: ${e.toString()}');
    }
  }
}
