import 'package:flutter/material.dart';
import 'package:vishv_umiyadham_foundation/services/admin_service.dart';
import 'package:vishv_umiyadham_foundation/services/error_service.dart';

class AdminProvider with ChangeNotifier {
  final AdminService _adminService = AdminService();

  Map<String, dynamic> _dashboardData = {};
  List<dynamic> _pendingCaptains = [];
  List<dynamic> _allTeams = [];
  List<dynamic> _pendingRemovals = [];
  List<dynamic> _allMatches = [];
  List<dynamic> _allUsers = [];
  bool _isLoading = false;
  String? _error;

  Map<String, dynamic> get dashboardData => _dashboardData;
  List<dynamic> get pendingCaptains => _pendingCaptains;
  List<dynamic> get allTeams => _allTeams;
  List<dynamic> get pendingRemovals => _pendingRemovals;
  List<dynamic> get allMatches => _allMatches;
  List<dynamic> get allUsers => _allUsers;
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

  Future<void> fetchAdminDashboard() async {
    _setLoading(true);
    _setError(null);

    try {
      _dashboardData = await _adminService.getAdminDashboard();
    } catch (e) {
      _setError(ErrorService.getErrorMessage(e));
    } finally {
      _setLoading(false);
    }
  }

  Future<void> fetchPendingCaptains() async {
    _setLoading(true);
    _setError(null);

    try {
      _pendingCaptains = await _adminService.getPendingCaptains();
    } catch (e) {
      _setError(ErrorService.getErrorMessage(e));
    } finally {
      _setLoading(false);
    }
  }

  Future<bool> approveCaptain(String captainId) async {
    _setLoading(true);
    _setError(null);

    try {
      await _adminService.approveCaptain(captainId);
      await fetchPendingCaptains();
      return true;
    } catch (e) {
      _setError(ErrorService.getErrorMessage(e));
      return false;
    } finally {
      _setLoading(false);
    }
  }

  Future<bool> rejectCaptain(String captainId) async {
    _setLoading(true);
    _setError(null);

    try {
      await _adminService.rejectCaptain(captainId);
      await fetchPendingCaptains();
      return true;
    } catch (e) {
      _setError(ErrorService.getErrorMessage(e));
      return false;
    } finally {
      _setLoading(false);
    }
  }

  Future<void> fetchAllTeams() async {
    _setLoading(true);
    _setError(null);

    try {
      _allTeams = await _adminService.getAllTeams();
    } catch (e) {
      _setError(ErrorService.getErrorMessage(e));
    } finally {
      _setLoading(false);
    }
  }

  Future<void> fetchPendingRemovals() async {
    _setLoading(true);
    _setError(null);

    try {
      _pendingRemovals = await _adminService.getPendingRemovals();
    } catch (e) {
      _setError(ErrorService.getErrorMessage(e));
    } finally {
      _setLoading(false);
    }
  }

  Future<bool> approvePlayerRemoval(String teamId) async {
    _setLoading(true);
    _setError(null);

    try {
      await _adminService.approvePlayerRemoval(teamId);
      await fetchPendingRemovals();
      await fetchAllTeams();
      return true;
    } catch (e) {
      _setError(ErrorService.getErrorMessage(e));
      return false;
    } finally {
      _setLoading(false);
    }
  }

  Future<bool> rejectPlayerRemoval(String teamId) async {
    _setLoading(true);
    _setError(null);

    try {
      await _adminService.rejectPlayerRemoval(teamId);
      await fetchPendingRemovals();
      return true;
    } catch (e) {
      _setError(ErrorService.getErrorMessage(e));
      return false;
    } finally {
      _setLoading(false);
    }
  }

  Future<void> fetchAllMatches() async {
    _setLoading(true);
    _setError(null);

    try {
      _allMatches = await _adminService.getAllMatches();
    } catch (e) {
      _setError(ErrorService.getErrorMessage(e));
    } finally {
      _setLoading(false);
    }
  }

  Future<bool> createMatch(String team1Id, String team2Id, DateTime matchDate,
      String location, String description) async {
    _setLoading(true);
    _setError(null);

    try {
      await _adminService.createMatch(
          team1Id, team2Id, matchDate, location, description);
      await fetchAllMatches();
      return true;
    } catch (e) {
      _setError(ErrorService.getErrorMessage(e));
      return false;
    } finally {
      _setLoading(false);
    }
  }

  Future<bool> updateMatchScore(
      String matchId, String teamId, int score) async {
    _setLoading(true);
    _setError(null);

    try {
      await _adminService.updateMatchScore(matchId, teamId, score);
      await fetchAllMatches();
      return true;
    } catch (e) {
      _setError(ErrorService.getErrorMessage(e));
      return false;
    } finally {
      _setLoading(false);
    }
  }

  Future<bool> updateMatchStatus(String matchId, String status) async {
    _setLoading(true);
    _setError(null);

    try {
      await _adminService.updateMatchStatus(matchId, status);
      await fetchAllMatches();
      return true;
    } catch (e) {
      _setError(ErrorService.getErrorMessage(e));
      return false;
    } finally {
      _setLoading(false);
    }
  }

  Future<void> fetchAllUsers() async {
    _setLoading(true);
    _setError(null);

    try {
      _allUsers = await _adminService.getAllUsers();
    } catch (e) {
      _setError(ErrorService.getErrorMessage(e));
    } finally {
      _setLoading(false);
    }
  }

  Future<bool> deleteUser(String userId) async {
    _setLoading(true);
    _setError(null);

    try {
      await _adminService.deleteUser(userId);
      await fetchAllUsers();
      return true;
    } catch (e) {
      _setError(ErrorService.getErrorMessage(e));
      return false;
    } finally {
      _setLoading(false);
    }
  }

  Future<bool> deleteTeam(String teamId) async {
    _setLoading(true);
    _setError(null);

    try {
      await _adminService.deleteTeam(teamId);
      await fetchAllTeams();
      return true;
    } catch (e) {
      _setError(ErrorService.getErrorMessage(e));
      return false;
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
    _pendingCaptains = [];
    _allTeams = [];
    _pendingRemovals = [];
    _allMatches = [];
    _allUsers = [];
    _error = null;
    _isLoading = false;
    notifyListeners();
  }
}
