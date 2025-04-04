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

  // Initialize auth state
  Future<void> initAuth() async {
    _isLoading = true;
    // Removed the notifyListeners() call here to avoid calling during build phase

    try {
      final isLoggedIn = await _storageService.isLoggedIn();
      if (isLoggedIn) {
        final userData = await _storageService.getUser();
        if (userData != null) {
          _user = User.fromJson(json.decode(userData));
        } else {
          // If we have a token but no user data, fetch the profile
          _user = await _apiService.getUserProfile();
          await _storageService.saveUser(json.encode(_user!.toJson()));
        }
      }
      _error = null;
    } catch (e) {
      _error = e.toString();
      await _storageService.clearAll();
      _user = null;
    } finally {
      _isLoading = false;
      // Use microtask to ensure notifyListeners() is called after the build phase
      Future.microtask(() {
        notifyListeners();
      });
    }
  }

  // Register user
  Future<bool> register(String name, String email, String phone,
      String password, String role) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final data =
          await _apiService.register(name, email, phone, password, role);
      _user = User.fromJson(data['user']);
      return true;
    } catch (e) {
      _error = e.toString();
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Login user
  Future<bool> login(String email, String password) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final data = await _apiService.login(email, password);
      _user = User.fromJson(data['user']);
      return true;
    } catch (e) {
      _error = e.toString();
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Logout user
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
      _isLoading = false;
      notifyListeners();
    }
  }

  // Refresh user profile
  Future<void> refreshProfile() async {
    _isLoading = true;
    notifyListeners();

    try {
      _user = await _apiService.getUserProfile();
      await _storageService.saveUser(json.encode(_user!.toJson()));
      _error = null;
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Clear error
  void clearError() {
    _error = null;
    notifyListeners();
  }
}
