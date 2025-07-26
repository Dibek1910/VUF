import 'package:flutter/material.dart';
import 'package:vishv_umiyadham_foundation/models/team_model.dart';
import 'package:vishv_umiyadham_foundation/models/match_model.dart';
import 'package:vishv_umiyadham_foundation/services/captain_service.dart';
import 'package:vishv_umiyadham_foundation/services/error_service.dart';

class CaptainProvider with ChangeNotifier {
  final CaptainService _captainService = CaptainService();

  List<Team> _captainTeams = [];
  List<Match> _captainMatches = [];
  bool _isLoading = false;
  String? _error;

  List<Team> get captainTeams => _captainTeams;
  List<Match> get captainMatches => _captainMatches;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Team? get currentTeam =>
      _captainTeams.isNotEmpty ? _captainTeams.first : null;

  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  void _setError(String? error) {
    _error = error;
    notifyListeners();
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
      String teamId, String name, List<int>? jerseyNumbers) async {
    _setLoading(true);
    _setError(null);

    try {
      final updatedTeam =
          await _captainService.updateTeam(teamId, name, jerseyNumbers);
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

      if (_captainTeams.isNotEmpty) {
        final teamIds = _captainTeams.map((team) => team.id).toList();
        _captainMatches = _captainMatches.where((match) {
          return match.teams.any((team) => teamIds.contains(team.id));
        }).toList();
      }
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
    _captainTeams = [];
    _captainMatches = [];
    _error = null;
    _isLoading = false;
    notifyListeners();
  }
}
