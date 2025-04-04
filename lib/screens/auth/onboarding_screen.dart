import 'package:flutter/material.dart';
import 'package:vishv_umiyadham_foundation/screens/auth/login_screen.dart';
import 'package:vishv_umiyadham_foundation/screens/auth/signup_screen.dart';
import 'package:vishv_umiyadham_foundation/utils/app_theme.dart';

class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // App logo or image
              const Spacer(),
              const Icon(
                Icons.sports_cricket,
                size: 100,
                color: AppTheme.primaryColor,
              ),
              const SizedBox(height: 24),

              // App name and tagline
              const Text(
                'Vishv Umiyadham Foundation',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              const Text(
                'Manage teams, matches, and players all in one place',
                style: TextStyle(
                  fontSize: 16,
                  color: AppTheme.textLightColor,
                ),
                textAlign: TextAlign.center,
              ),
              const Spacer(),

              // Login button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(builder: (_) => const LoginScreen()),
                    );
                  },
                  child: const Text('Login'),
                ),
              ),
              const SizedBox(height: 16),

              // Sign up button
              SizedBox(
                width: double.infinity,
                child: OutlinedButton(
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(builder: (_) => const SignupScreen()),
                    );
                  },
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: AppTheme.primaryColor),
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text(
                    'Sign Up',
                    style: TextStyle(color: AppTheme.primaryColor),
                  ),
                ),
              ),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }
}
