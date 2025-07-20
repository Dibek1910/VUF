import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vishv_umiyadham_foundation/providers/auth_provider.dart';
import 'package:vishv_umiyadham_foundation/providers/admin_provider.dart';
import 'package:vishv_umiyadham_foundation/screens/auth/login_screen.dart';
import 'package:vishv_umiyadham_foundation/screens/dashboard/admin/admin_captains_tab.dart';
import 'package:vishv_umiyadham_foundation/screens/dashboard/admin/admin_dashboard_tab.dart';
import 'package:vishv_umiyadham_foundation/screens/dashboard/admin/admin_matches_tab.dart';
import 'package:vishv_umiyadham_foundation/screens/dashboard/admin/admin_teams_tab.dart';
import 'package:vishv_umiyadham_foundation/screens/dashboard/admin/admin_users_tab.dart';
import 'package:vishv_umiyadham_foundation/utils/app_theme.dart';
import 'package:vishv_umiyadham_foundation/widgets/dashboard_drawer.dart';

class AdminDashboard extends StatefulWidget {
  const AdminDashboard({super.key});

  @override
  State<AdminDashboard> createState() => _AdminDashboardState();
}

class _AdminDashboardState extends State<AdminDashboard> {
  int _selectedIndex = 0;

  final List<String> _titles = [
    'Admin Dashboard',
    'Captain Approvals',
    'Team Management',
    'Match Management',
    'User Management',
  ];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final adminProvider = Provider.of<AdminProvider>(context, listen: false);
      _initializeAdminData(adminProvider);
    });
  }

  Future<void> _initializeAdminData(AdminProvider adminProvider) async {
    try {
      await Future.wait([
        adminProvider.fetchAdminDashboard(),
        adminProvider.fetchPendingCaptains(),
        adminProvider.fetchAllTeams(),
        adminProvider.fetchAllMatches(),
        adminProvider.fetchAllUsers(),
        adminProvider.fetchPendingRemovals(),
      ]);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error loading admin data: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> pages = [
      const AdminDashboardTab(),
      const AdminCaptainsTab(),
      const AdminTeamsTab(),
      const AdminMatchesTab(),
      const AdminUsersTab(),
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text(_titles[_selectedIndex]),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              final adminProvider =
                  Provider.of<AdminProvider>(context, listen: false);
              _initializeAdminData(adminProvider);
            },
          ),
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              final authProvider =
                  Provider.of<AuthProvider>(context, listen: false);
              await authProvider.logout();
              if (!mounted) return;

              Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (_) => const LoginScreen()),
              );
            },
          ),
        ],
      ),
      drawer: const DashboardDrawer(role: 'Admin'),
      body: pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        type: BottomNavigationBarType.fixed,
        selectedItemColor: AppTheme.primaryColor,
        unselectedItemColor: AppTheme.textLightColor,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard),
            label: 'Dashboard',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_add),
            label: 'Captains',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.group),
            label: 'Teams',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.sports_cricket),
            label: 'Matches',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.people),
            label: 'Users',
          ),
        ],
      ),
    );
  }
}
