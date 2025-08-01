import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:vishv_umiyadham_foundation/models/user_model.dart';
import 'package:vishv_umiyadham_foundation/services/api_service.dart';
import 'package:vishv_umiyadham_foundation/services/storage_service.dart';

class AuthProvider with ChangeNotifier {
  final ApiService _apiService = ApiService();
  final StorageService _storageService = StorageService();

  User? _user;
  bool _isLoading = false;
  String? _error;

  User? get user => _user;
  bool get isLoading => _isLoading;
  String? get error => _error;
  bool get isAuthenticated => _user != null;

  Future<bool> checkAuthStatus() async {
    _isLoading = true;
    notifyListeners();

    try {
      final isLoggedIn = await _storageService.isLoggedIn();
      if (isLoggedIn) {
        final userData = await _storageService.getUser();
        if (userData != null) {
          _user = User.fromJson(json.decode(userData));
          _error = null;
          return true;
        } else {
          _user = await _apiService.getUserProfile();
          await _storageService.saveUser(json.encode(_user!.toJson()));
          _error = null;
          return true;
        }
      }
      return false;
    } catch (e) {
      _error = e.toString();
      await _storageService.clearAll();
      _user = null;
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> register(String name, String email, String phone,
      String password, String role) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final data =
          await _apiService.register(name, email, phone, password, role);
      _user = User.fromJson(data['user']);
      _error = null;
      return true;
    } catch (e) {
      _error = e.toString();
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> login(String email, String password) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final data = await _apiService.login(email, password);
      _user = User.fromJson(data['user']);
      _error = null;
      return true;
    } catch (e) {
      _error = e.toString();
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> logout() async {
    _isLoading = true;
    notifyListeners();

    try {
      await _apiService.logout();
    } catch (e) {
      _error = e.toString();
    } finally {
      await _storageService.clearAll();
      _user = null;
      _error = null;
      _isLoading = false;
      notifyListeners();
    }
  }

  void clearError() {
    _error = null;
    notifyListeners();
  }
}
