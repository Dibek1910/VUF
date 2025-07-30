import 'dart:io';
import 'package:flutter/foundation.dart';

class ApiConstants {
  static String get baseUrl {
    if (kIsWeb) {
      return 'http://localhost:5001/api';
    }
    if (Platform.isAndroid) {
      return 'http://10.0.2.2:5001/api';
    }
    if (Platform.isIOS) {
      return 'http://localhost:5001/api';
    }
    return 'http://localhost:5001/api';
  }

  // static const String baseUrl = 'https://vuf-backend.onrender.com/api';

  static const String register = '/auth/register';
  static const String login = '/auth/login';
  static const String logout = '/auth/logout';
  static const String userProfile = '/auth/profile';

  static const String teams = '/teams';
  static const String invitePlayer = '/teams/invite';
  static const String removePlayer = '/teams/remove-player';
  static const String captainTeams = '/teams/captain/my-teams';

  static const String matches = '/matches';
  static const String updateScore = '/matches/score';

  static const String playerInvitations = '/player/invitations';
  static const String playerAcceptInvitation = '/player/accept-invitation';
  static const String playerDeclineInvitation = '/player/decline-invitation';
  static const String playerTeam = '/player/team';
  static const String playerMatches = '/player/matches';
  static const String playerDashboard = '/player/dashboard';

  static const String adminDashboard = '/admin/dashboard';
  static const String adminPendingCaptains = '/admin/pending-captains';
  static const String adminApproveCaptain = '/admin/approve-captain';
  static const String adminRejectCaptain = '/admin/reject-captain';
  static const String adminTeams = '/admin/teams';
  static const String adminPendingRemovals = '/admin/pending-removals';
  static const String adminApproveRemoval = '/admin/approve-removal';
  static const String adminRejectRemoval = '/admin/reject-removal';
  static const String adminMatches = '/admin/matches';
  static const String adminCreateMatch = '/admin/matches';
  static const String adminUpdateScore = '/admin/update-score';
  static const String adminUpdateStatus = '/admin/update-status';
  static const String adminUsers = '/admin/users';

  static const String captainDashboard = '/captain/dashboard';
  static const String captainCreateTeam = '/captain/create-team';
  static const String captainInvitePlayer = '/captain/invite-player';
  static const String captainAssignJersey = '/captain/assign-jersey';
  static const String captainMatches = '/captain/matches';
  static const String captainUpdateTeam = '/captain/team';
}

class StorageConstants {
  static const String token = 'auth_token';
  static const String user = 'user_data';
}

class AppConstants {
  static const String appName = 'Vishv Umiyadham Foundation';
  static const String appVersion = '1.0.0';
  static const int requestTimeout = 30;
}

enum UserRole { admin, captain, player }

enum MatchStatus { upcoming, live, completed, cancelled }

class ErrorMessages {
  static const String networkError =
      'Network error. Please check your connection.';
  static const String serverError = 'Server error. Please try again later.';
  static const String unknownError = 'Something went wrong. Please try again.';
  static const String invalidCredentials = 'Invalid email or password.';
  static const String userNotFound = 'User not found.';
  static const String emailAlreadyExists = 'Email already exists.';
  static const String captainNotApproved =
      'Captain approval pending. Please wait for admin approval.';
}

class SuccessMessages {
  static const String loginSuccess = 'Login successful!';
  static const String registerSuccess = 'Registration successful!';
  static const String logoutSuccess = 'Logout successful!';
  static const String invitationAccepted = 'Invitation accepted successfully!';
  static const String invitationDeclined = 'Invitation declined successfully!';
  static const String teamCreated = 'Team created successfully!';
  static const String playerInvited = 'Player invitation sent successfully!';
  static const String playerRemovalRequested =
      'Player removal request sent to admin';
  static const String jerseyAssigned = 'Jersey number assigned successfully!';
}
