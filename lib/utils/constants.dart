import 'dart:io';

import 'package:flutter/foundation.dart';

class ApiConstants {
  static String get baseUrl {
    // For web
    if (kIsWeb) {
      return 'http://localhost:5001/api';
    }

    // For Android emulator
    if (Platform.isAndroid) {
      return 'http://10.0.2.2:5001/api';
    }

    // For iOS simulator
    if (Platform.isIOS) {
      return 'http://localhost:5001/api';
    }

    // Default fallback
    return 'http://localhost:5001/api';
  }

  // Auth endpoints
  static const String register = '/auth/register';
  static const String login = '/auth/login';
  static const String logout = '/auth/logout';

  // User endpoints
  static const String userProfile = '/user/profile';

  // Team endpoints
  static const String teams = '/teams';
  static const String invitePlayer = '/teams/invite';
  static const String removePlayer = '/teams/remove-player';

  // Match endpoints
  static const String matches = '/matches';
  static const String updateScore = '/matches/score';

  // Payment endpoints
  static const String payments = '/payments';

  // Admin endpoints
  static const String approveCaptain = '/admin/approve-captain';
}

class StorageConstants {
  static const String token = 'auth_token';
  static const String user = 'user_data';
}

enum UserRole { Admin, Captain, Player }
