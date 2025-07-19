import 'package:flutter/material.dart';
import 'package:vishv_umiyadham_foundation/utils/constants.dart';

class ErrorService {
  static String getErrorMessage(dynamic error) {
    String errorString = error.toString().toLowerCase();

    if (errorString.contains('network') || errorString.contains('connection')) {
      return ErrorMessages.networkError;
    } else if (errorString.contains('server') || errorString.contains('500')) {
      return ErrorMessages.serverError;
    } else if (errorString.contains('invalid credentials') ||
        errorString.contains('401')) {
      return ErrorMessages.invalidCredentials;
    } else if (errorString.contains('user not found') ||
        errorString.contains('404')) {
      return ErrorMessages.userNotFound;
    } else if (errorString.contains('email already exists') ||
        errorString.contains('409')) {
      return ErrorMessages.emailAlreadyExists;
    } else if (errorString.contains('timeout')) {
      return 'Request timeout. Please try again.';
    } else {
      if (errorString.startsWith('exception: ')) {
        return error.toString().substring(11);
      }
      return ErrorMessages.unknownError;
    }
  }

  static void showErrorSnackBar(BuildContext context, dynamic error) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(getErrorMessage(error)),
        backgroundColor: Colors.red,
        duration: const Duration(seconds: 4),
        action: SnackBarAction(
          label: 'Dismiss',
          textColor: Colors.white,
          onPressed: () {
            ScaffoldMessenger.of(context).hideCurrentSnackBar();
          },
        ),
      ),
    );
  }

  static void showSuccessSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.green,
        duration: const Duration(seconds: 3),
      ),
    );
  }

  static void showInfoSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.blue,
        duration: const Duration(seconds: 3),
      ),
    );
  }
}
