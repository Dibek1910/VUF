import 'package:flutter/material.dart';
import 'package:vishv_umiyadham_foundation/models/team_model.dart';
import 'package:vishv_umiyadham_foundation/models/match_model.dart';
import 'package:vishv_umiyadham_foundation/services/captain_service.dart';
import 'package:vishv_umiyadham_foundation/services/error_service.dart';

class CaptainProvider with ChangeNotifier {
  final CaptainService _captainService = CaptainService();

  Map<String, dynamic> _dashboardData = {};
  List<Team> _captainTeams = [];
  List<Match> _captainMatches = [];
  bool _isLoading = false;
  String? _error;

  Map<String, dynamic> get dashboardData => _dashboardData;
  List<Team> get captainTeams => _captainTeams;
  List<Match> get captainMatches => _captainMatches;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Team? get currentTeam =>
      _captainTeams.isNotEmpty ? _captainTeams.first : null;

  bool get isApproved => _dashboardData['captain']?['isApproved'] ?? false;

  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  void _setError(String? error) {
    _error = error;
    notifyListeners();
  }

  Future<void> fetchCaptainDashboard() async {
    _setLoading(true);
    _setError(null);

    try {
      _dashboardData = await _captainService.getCaptainDashboard();
      _captainTeams = (_dashboardData['teams'] as List? ?? [])
          .map((team) => Team.fromJson(team))
          .toList();
    } catch (e) {
      _setError(ErrorService.getErrorMessage(e));
    } finally {
      _setLoading(false);
    }
  }

  Future<void> fetchCaptainTeams() async {
    _setLoading(true);
    _setError(null);

    try {
      _captainTeams = await _captainService.getCaptainTeams();
    } catch (e) {
      _setError(ErrorService.getErrorMessage(e));
    } finally {
      _setLoading(false);
    }
  }

  Future<bool> createTeam(String name) async {
    _setLoading(true);
    _setError(null);

    try {
      final newTeam = await _captainService.createTeam(name);
      _captainTeams.add(newTeam);
      await fetchCaptainDashboard();
      return true;
    } catch (e) {
      _setError(ErrorService.getErrorMessage(e));
      return false;
    } finally {
      _setLoading(false);
    }
  }

  Future<bool> invitePlayer(String teamId, String playerUniqueId) async {
    _setLoading(true);
    _setError(null);

    try {
      await _captainService.invitePlayer(teamId, playerUniqueId);
      await fetchCaptainTeams();
      return true;
    } catch (e) {
      _setError(ErrorService.getErrorMessage(e));
      return false;
    } finally {
      _setLoading(false);
    }
  }

  Future<bool> assignJerseyNumber(
      String teamId, String playerId, int jerseyNumber) async {
    _setLoading(true);
    _setError(null);

    try {
      await _captainService.assignJerseyNumber(teamId, playerId, jerseyNumber);
      await fetchCaptainTeams();
      return true;
    } catch (e) {
      _setError(ErrorService.getErrorMessage(e));
      return false;
    } finally {
      _setLoading(false);
    }
  }

  Future<bool> requestPlayerRemoval(String teamId, String playerId) async {
    _setLoading(true);
    _setError(null);

    try {
      await _captainService.requestPlayerRemoval(teamId, playerId);
      await fetchCaptainTeams();
      return true;
    } catch (e) {
      _setError(ErrorService.getErrorMessage(e));
      return false;
    } finally {
      _setLoading(false);
    }
  }

  Future<bool> updateTeam(
      String teamId, String name, String? description) async {
    _setLoading(true);
    _setError(null);

    try {
      final updatedTeam =
          await _captainService.updateTeam(teamId, name, description);
      final index = _captainTeams.indexWhere((team) => team.id == teamId);
      if (index != -1) {
        _captainTeams[index] = updatedTeam;
      }
      return true;
    } catch (e) {
      _setError(ErrorService.getErrorMessage(e));
      return false;
    } finally {
      _setLoading(false);
    }
  }

  Future<void> fetchCaptainMatches() async {
    _setLoading(true);
    _setError(null);

    try {
      _captainMatches = await _captainService.getCaptainMatches();
    } catch (e) {
      _setError(ErrorService.getErrorMessage(e));
    } finally {
      _setLoading(false);
    }
  }

  void clearError() {
    _error = null;
    notifyListeners();
  }

  void clearData() {
    _dashboardData = {};
    _captainTeams = [];
    _captainMatches = [];
    _error = null;
    _isLoading = false;
    notifyListeners();
  }
}
