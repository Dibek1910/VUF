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

  Future<List<Team>> getCaptainTeams() async {
    try {
      final response = await http
          .get(
            Uri.parse('${ApiConstants.baseUrl}${ApiConstants.captainTeams}'),
            headers: await _getHeaders(),
          )
          .timeout(Duration(seconds: AppConstants.requestTimeout));

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
            Uri.parse('${ApiConstants.baseUrl}${ApiConstants.teams}'),
            headers: await _getHeaders(),
            body: json.encode({
              'name': name,
              'captainId': await _getCurrentUserId(),
            }),
          )
          .timeout(Duration(seconds: AppConstants.requestTimeout));

      final data = _handleResponse(response);
      return Team.fromJson(data);
    } catch (e) {
      throw Exception('Failed to create team: ${e.toString()}');
    }
  }

  Future<dynamic> invitePlayer(String teamId, String playerUniqueId) async {
    try {
      final response = await http
          .post(
            Uri.parse('${ApiConstants.baseUrl}${ApiConstants.invitePlayer}'),
            headers: await _getHeaders(),
            body: json.encode({
              'teamId': teamId,
              'playerUniqueId': playerUniqueId,
            }),
          )
          .timeout(Duration(seconds: AppConstants.requestTimeout));

      return _handleResponse(response);
    } catch (e) {
      throw Exception('Failed to invite player: ${e.toString()}');
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
          .timeout(Duration(seconds: AppConstants.requestTimeout));

      return _handleResponse(response);
    } catch (e) {
      throw Exception('Failed to request player removal: ${e.toString()}');
    }
  }

  Future<Team> updateTeam(
      String teamId, String name, List<int>? jerseyNumbers) async {
    try {
      final response = await http
          .put(
            Uri.parse('${ApiConstants.baseUrl}${ApiConstants.teams}/$teamId'),
            headers: await _getHeaders(),
            body: json.encode({
              'name': name,
              'jerseyNumbers': jerseyNumbers,
            }),
          )
          .timeout(Duration(seconds: AppConstants.requestTimeout));

      final data = _handleResponse(response);
      return Team.fromJson(data);
    } catch (e) {
      throw Exception('Failed to update team: ${e.toString()}');
    }
  }

  Future<List<Match>> getCaptainMatches() async {
    try {
      final response = await http
          .get(
            Uri.parse('${ApiConstants.baseUrl}${ApiConstants.matches}'),
            headers: await _getHeaders(),
          )
          .timeout(Duration(seconds: AppConstants.requestTimeout));

      final data = _handleResponse(response);
      return (data as List).map((match) => Match.fromJson(match)).toList();
    } catch (e) {
      throw Exception('Failed to fetch captain matches: ${e.toString()}');
    }
  }

  Future<String?> _getCurrentUserId() async {
    final userData = await _storageService.getUser();
    if (userData != null) {
      final user = json.decode(userData);
      return user['_id'] ?? user['id'];
    }
    return null;
  }
}
