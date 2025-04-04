import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vishv_umiyadham_foundation/providers/auth_provider.dart';
import 'package:vishv_umiyadham_foundation/screens/auth/onboarding_screen.dart';
import 'package:vishv_umiyadham_foundation/screens/dashboard/admin_dashboard.dart';
import 'package:vishv_umiyadham_foundation/screens/dashboard/captain_dashboard.dart';
import 'package:vishv_umiyadham_foundation/screens/dashboard/player_dashboard.dart';
import 'package:vishv_umiyadham_foundation/utils/constants.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:vishv_umiyadham_foundation/utils/app_theme.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _initializeApp();
  }

  Future<void> _initializeApp() async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    await authProvider.initAuth();

    // Navigate based on authentication status
    if (!mounted) return;

    if (authProvider.isAuthenticated) {
      _navigateToDashboard(authProvider);
    } else {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const OnboardingScreen()),
      );
    }
  }

  void _navigateToDashboard(AuthProvider authProvider) {
    final user = authProvider.user;
    if (user == null) return;

    Widget dashboard;

    switch (user.role) {
      case 'Admin':
        dashboard = const AdminDashboard();
        break;
      case 'Captain':
        dashboard = const CaptainDashboard();
        break;
      case 'Player':
        dashboard = const PlayerDashboard();
        break;
      default:
        dashboard = const OnboardingScreen();
    }

    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (_) => dashboard),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Logo or app name
            const Text(
              'Vishv Umiyadham',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: AppTheme.primaryColor,
              ),
            ),
            const Text(
              'Foundation',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w500,
                color: AppTheme.secondaryColor,
              ),
            ),
            const SizedBox(height: 30),
            // Loading indicator
            const SpinKitDoubleBounce(
              color: AppTheme.primaryColor,
              size: 50.0,
            ),
            const SizedBox(height: 20),
            Text(
              'Loading...',
              style: TextStyle(
                fontSize: 16,
                color: Theme.of(context).textTheme.bodyLarge?.color,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
