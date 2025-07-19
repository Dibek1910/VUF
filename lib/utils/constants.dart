import 'dart:io';
import 'package:flutter/foundation.dart';

class ApiConstants {
  static String get baseUrl {
    if (kIsWeb) {
      return 'http://localhost:5000/api';
    }
    if (Platform.isAndroid) {
      return 'http://10.0.2.2:5000/api';
    }
    if (Platform.isIOS) {
      return 'http://localhost:5000/api';
    }
    return 'http://localhost:5000/api';
  }

  // static const String baseUrl = 'https://vuf-backend.onrender.com/api';

  static const String register = '/auth/register';
  static const String login = '/auth/login';
  static const String logout = '/auth/logout';
  static const String userProfile = '/user/profile';

  static const String teams = '/teams';
  static const String invitePlayer = '/teams/invite';
  static const String removePlayer = '/teams/remove-player';

  static const String matches = '/matches';
  static const String updateScore = '/matches/score';

  static const String payments = '/payments';

  static const String approveCaptain = '/admin/approve-captain';

  static const String playerInvitations = '/player/invitations';
  static const String playerAcceptInvitation = '/player/accept-invitation';
  static const String playerDeclineInvitation = '/player/decline-invitation';
  static const String playerTeam = '/player/team';
  static const String playerMatches = '/player/matches';
  static const String playerDashboard = '/player/dashboard';

  static const String captainTeams = '/captain/teams';
  static const String captainMatches = '/captain/matches';
  static const String captainDashboard = '/captain/dashboard';

  static const String adminUsers = '/admin/users';
  static const String adminTeams = '/admin/teams';
  static const String adminMatches = '/admin/matches';
  static const String adminDashboard = '/admin/dashboard';
}

class StorageConstants {
  static const String token = 'auth_token';
  static const String user = 'user_data';
  static const String theme = 'app_theme';
  static const String language = 'app_language';
}

class AppConstants {
  static const String appName = 'Vishv Umiyadham Foundation';
  static const String appVersion = '1.0.0';
  static const int requestTimeout = 30;
  static const int maxRetries = 3;
}

enum UserRole { Admin, Captain, Player }

enum MatchStatus { Upcoming, Live, Completed, Cancelled }

enum TeamInvitationStatus { Pending, Accepted, Declined }

enum PaymentStatus { Pending, Completed, Failed, Refunded }

class ValidationConstants {
  static const int minPasswordLength = 6;
  static const int maxPasswordLength = 50;
  static const int minNameLength = 2;
  static const int maxNameLength = 50;
  static const int phoneNumberLength = 10;

  static const String emailRegex = r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$';
  static const String phoneRegex = r'^[0-9]{10}$';
  static const String nameRegex = r'^[a-zA-Z\s]+$';
}

class UIConstants {
  static const double defaultPadding = 16.0;
  static const double smallPadding = 8.0;
  static const double largePadding = 24.0;

  static const double defaultBorderRadius = 12.0;
  static const double smallBorderRadius = 8.0;
  static const double largeBorderRadius = 16.0;

  static const double defaultElevation = 2.0;
  static const double highElevation = 8.0;

  static const int animationDuration = 300;
}

class ErrorMessages {
  static const String networkError =
      'Network error. Please check your connection.';
  static const String serverError = 'Server error. Please try again later.';
  static const String unknownError = 'Something went wrong. Please try again.';
  static const String invalidCredentials = 'Invalid email or password.';
  static const String userNotFound = 'User not found.';
  static const String emailAlreadyExists = 'Email already exists.';
  static const String invalidEmail = 'Please enter a valid email address.';
  static const String passwordTooShort =
      'Password must be at least 6 characters.';
  static const String fieldsRequired = 'All fields are required.';
  static const String phoneInvalid = 'Please enter a valid phone number.';
  static const String nameInvalid = 'Please enter a valid name.';
}

class SuccessMessages {
  static const String loginSuccess = 'Login successful!';
  static const String registerSuccess = 'Registration successful!';
  static const String logoutSuccess = 'Logout successful!';
  static const String profileUpdated = 'Profile updated successfully!';
  static const String passwordChanged = 'Password changed successfully!';
  static const String invitationSent = 'Invitation sent successfully!';
  static const String invitationAccepted = 'Invitation accepted successfully!';
  static const String invitationDeclined = 'Invitation declined successfully!';
  static const String teamCreated = 'Team created successfully!';
  static const String matchCreated = 'Match created successfully!';
  static const String scoreUpdated = 'Score updated successfully!';
}
