import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:vishv_umiyadham_foundation/models/team_model.dart';
import 'package:vishv_umiyadham_foundation/models/match_model.dart';
import 'package:vishv_umiyadham_foundation/services/storage_service.dart';
import 'package:vishv_umiyadham_foundation/utils/constants.dart';

class CaptainService {
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

  Future<Map<String, dynamic>> getCaptainDashboard() async {
    try {
      final response = await http
          .get(
            Uri.parse(
                '${ApiConstants.baseUrl}${ApiConstants.captainDashboard}'),
            headers: await _getHeaders(),
          )
          .timeout(const Duration(seconds: AppConstants.requestTimeout));

      return _handleResponse(response);
    } catch (e) {
      throw Exception('Failed to fetch captain dashboard: ${e.toString()}');
    }
  }

  Future<List<Team>> getCaptainTeams() async {
    try {
      final response = await http
          .get(
            Uri.parse('${ApiConstants.baseUrl}${ApiConstants.captainTeams}'),
            headers: await _getHeaders(),
          )
          .timeout(const Duration(seconds: AppConstants.requestTimeout));

      final data = _handleResponse(response);
      return (data as List).map((team) => Team.fromJson(team)).toList();
    } catch (e) {
      throw Exception('Failed to fetch captain teams: ${e.toString()}');
    }
  }

  Future<Team> createTeam(String name) async {
    try {
      final response = await http
          .post(
            Uri.parse(
                '${ApiConstants.baseUrl}${ApiConstants.captainCreateTeam}'),
            headers: await _getHeaders(),
            body: json.encode({
              'name': name,
            }),
          )
          .timeout(const Duration(seconds: AppConstants.requestTimeout));

      final data = _handleResponse(response);
      return Team.fromJson(data['team']);
    } catch (e) {
      throw Exception('Failed to create team: ${e.toString()}');
    }
  }

  Future<dynamic> invitePlayer(String teamId, String playerUniqueId) async {
    try {
      final response = await http
          .post(
            Uri.parse(
                '${ApiConstants.baseUrl}${ApiConstants.captainInvitePlayer}'),
            headers: await _getHeaders(),
            body: json.encode({
              'teamId': teamId,
              'playerUniqueId': playerUniqueId,
            }),
          )
          .timeout(const Duration(seconds: AppConstants.requestTimeout));

      return _handleResponse(response);
    } catch (e) {
      throw Exception('Failed to invite player: ${e.toString()}');
    }
  }

  Future<dynamic> assignJerseyNumber(
      String teamId, String playerId, int jerseyNumber) async {
    try {
      final response = await http
          .post(
            Uri.parse(
                '${ApiConstants.baseUrl}${ApiConstants.captainAssignJersey}'),
            headers: await _getHeaders(),
            body: json.encode({
              'teamId': teamId,
              'playerId': playerId,
              'jerseyNumber': jerseyNumber,
            }),
          )
          .timeout(const Duration(seconds: AppConstants.requestTimeout));

      return _handleResponse(response);
    } catch (e) {
      throw Exception('Failed to assign jersey number: ${e.toString()}');
    }
  }

  Future<dynamic> requestPlayerRemoval(String teamId, String playerId) async {
    try {
      final response = await http
          .post(
            Uri.parse('${ApiConstants.baseUrl}${ApiConstants.removePlayer}'),
            headers: await _getHeaders(),
            body: json.encode({
              'teamId': teamId,
              'playerId': playerId,
            }),
          )
          .timeout(const Duration(seconds: AppConstants.requestTimeout));

      return _handleResponse(response);
    } catch (e) {
      throw Exception('Failed to request player removal: ${e.toString()}');
    }
  }

  Future<Team> updateTeam(
      String teamId, String name, String? description) async {
    try {
      final response = await http
          .put(
            Uri.parse(
                '${ApiConstants.baseUrl}${ApiConstants.captainUpdateTeam}/$teamId'),
            headers: await _getHeaders(),
            body: json.encode({
              'name': name,
              'description': description,
            }),
          )
          .timeout(const Duration(seconds: AppConstants.requestTimeout));

      final data = _handleResponse(response);
      return Team.fromJson(data['team']);
    } catch (e) {
      throw Exception('Failed to update team: ${e.toString()}');
    }
  }

  Future<List<Match>> getCaptainMatches() async {
    try {
      final response = await http
          .get(
            Uri.parse('${ApiConstants.baseUrl}${ApiConstants.captainMatches}'),
            headers: await _getHeaders(),
          )
          .timeout(const Duration(seconds: AppConstants.requestTimeout));

      final data = _handleResponse(response);
      return (data as List).map((match) => Match.fromJson(match)).toList();
    } catch (e) {
      throw Exception('Failed to fetch captain matches: ${e.toString()}');
    }
  }
}
