import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vishv_umiyadham_foundation/providers/auth_provider.dart';
import 'package:vishv_umiyadham_foundation/screens/auth/onboarding_screen.dart';
import 'package:vishv_umiyadham_foundation/screens/dashboard/admin/admin_dashboard.dart';
import 'package:vishv_umiyadham_foundation/screens/dashboard/captain/captain_dashboard.dart';
import 'package:vishv_umiyadham_foundation/screens/dashboard/player/player_dashboard.dart';
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
    Future.microtask(() {
      _initializeApp();
    });
  }

  Future<void> _initializeApp() async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);

    await Future.delayed(const Duration(seconds: 2));

    final isLoggedIn = await authProvider.checkAuthStatus();

    if (!mounted) return;

    if (isLoggedIn && authProvider.user != null) {
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
      backgroundColor: AppTheme.primaryColor,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(30),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 20,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: const Icon(
                Icons.sports_cricket,
                size: 60,
                color: AppTheme.primaryColor,
              ),
            ),
            const SizedBox(height: 30),
            const Text(
              'Vishv Umiyadham\nFoundation',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.white,
                height: 1.2,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 10),
            const Text(
              'Cricket Management System',
              style: TextStyle(
                fontSize: 16,
                color: Colors.white70,
                fontWeight: FontWeight.w400,
              ),
            ),
            const SizedBox(height: 50),
            const CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
              strokeWidth: 3,
            ),
            const SizedBox(height: 20),
            const Text(
              'Loading...',
              style: TextStyle(
                fontSize: 16,
                color: Colors.white70,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
