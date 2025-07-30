import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vishv_umiyadham_foundation/providers/auth_provider.dart';
import 'package:vishv_umiyadham_foundation/providers/player_provider.dart';
import 'package:vishv_umiyadham_foundation/screens/auth/login_screen.dart';
import 'package:vishv_umiyadham_foundation/screens/dashboard/player/player_home_tab.dart';
import 'package:vishv_umiyadham_foundation/screens/dashboard/player/player_matches_tab.dart';
import 'package:vishv_umiyadham_foundation/screens/dashboard/player/player_profile_tab.dart';
import 'package:vishv_umiyadham_foundation/screens/dashboard/player/player_team_tab.dart';
import 'package:vishv_umiyadham_foundation/utils/app_theme.dart';
import 'package:vishv_umiyadham_foundation/widgets/dashboard_drawer.dart';

class PlayerDashboard extends StatefulWidget {
  const PlayerDashboard({super.key});

  @override
  State<PlayerDashboard> createState() => _PlayerDashboardState();
}

class _PlayerDashboardState extends State<PlayerDashboard> {
  int _selectedIndex = 0;

  final List<String> _titles = [
    'Dashboard',
    'My Team',
    'Matches',
    'Profile',
  ];

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final playerProvider =
          Provider.of<PlayerProvider>(context, listen: false);
      _initializePlayerData(playerProvider);
    });
  }

  Future<void> _initializePlayerData(PlayerProvider playerProvider) async {
    try {
      await Future.wait([
        playerProvider.fetchPlayerDashboard(),
        playerProvider.fetchTeamInvitations(),
        playerProvider.fetchPlayerTeam(),
        playerProvider.fetchPlayerMatches(),
      ]);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error loading data: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> pages = [
      const PlayerHomeTab(),
      const PlayerTeamTab(),
      const PlayerMatchesTab(),
      const PlayerProfileTab(),
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text(_titles[_selectedIndex]),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              final playerProvider =
                  Provider.of<PlayerProvider>(context, listen: false);
              _initializePlayerData(playerProvider);
            },
          ),
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              final navigator = Navigator.of(context);
              final authProvider =
                  Provider.of<AuthProvider>(context, listen: false);
              await authProvider.logout();
              if (!mounted) return;

              navigator.pushReplacement(
                MaterialPageRoute(builder: (_) => const LoginScreen()),
              );
            },
          ),
        ],
      ),
      drawer: const DashboardDrawer(role: 'Player'),
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
            icon: Icon(Icons.group),
            label: 'Team',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.sports_cricket),
            label: 'Matches',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}
