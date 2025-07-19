import 'package:flutter/material.dart';
import 'package:vishv_umiyadham_foundation/models/team_model.dart';
import 'package:vishv_umiyadham_foundation/models/match_model.dart';
import 'package:vishv_umiyadham_foundation/services/player_service.dart';
import 'package:vishv_umiyadham_foundation/services/error_service.dart';

class PlayerProvider with ChangeNotifier {
  final PlayerService _playerService = PlayerService();

  List<dynamic> _teamInvitations = [];
  Team? _playerTeam;
  List<Match> _playerMatches = [];
  Map<String, dynamic> _dashboardData = {};
  bool _isLoading = false;
  String? _error;

  List<dynamic> get teamInvitations => _teamInvitations;
  Team? get playerTeam => _playerTeam;
  List<Match> get playerMatches => _playerMatches;
  Map<String, dynamic> get dashboardData => _dashboardData;
  bool get isLoading => _isLoading;
  String? get error => _error;

  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  void _setError(String? error) {
    _error = error;
    notifyListeners();
  }

  Future<void> fetchTeamInvitations() async {
    _setLoading(true);
    _setError(null);

    try {
      _teamInvitations = await _playerService.getTeamInvitations();
    } catch (e) {
      _setError(ErrorService.getErrorMessage(e));
    } finally {
      _setLoading(false);
    }
  }

  Future<bool> acceptTeamInvitation(String teamId) async {
    _setLoading(true);
    _setError(null);

    try {
      await _playerService.acceptTeamInvitation(teamId);
      await fetchTeamInvitations();
      await fetchPlayerTeam();
      return true;
    } catch (e) {
      _setError(ErrorService.getErrorMessage(e));
      return false;
    } finally {
      _setLoading(false);
    }
  }

  Future<bool> declineTeamInvitation(String teamId) async {
    _setLoading(true);
    _setError(null);

    try {
      await _playerService.declineTeamInvitation(teamId);
      await fetchTeamInvitations();
      return true;
    } catch (e) {
      _setError(ErrorService.getErrorMessage(e));
      return false;
    } finally {
      _setLoading(false);
    }
  }

  Future<void> fetchPlayerTeam() async {
    _setLoading(true);
    _setError(null);

    try {
      _playerTeam = await _playerService.getPlayerTeam();
    } catch (e) {
      _setError(ErrorService.getErrorMessage(e));
    } finally {
      _setLoading(false);
    }
  }

  Future<void> fetchPlayerMatches() async {
    _setLoading(true);
    _setError(null);

    try {
      _playerMatches = await _playerService.getPlayerMatches();
    } catch (e) {
      _setError(ErrorService.getErrorMessage(e));
    } finally {
      _setLoading(false);
    }
  }

  Future<void> fetchPlayerDashboard() async {
    _setLoading(true);
    _setError(null);

    try {
      _dashboardData = await _playerService.getPlayerDashboard();
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
    _teamInvitations = [];
    _playerTeam = null;
    _playerMatches = [];
    _dashboardData = {};
    _error = null;
    _isLoading = false;
    notifyListeners();
  }
}
