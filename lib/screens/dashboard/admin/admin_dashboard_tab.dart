import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vishv_umiyadham_foundation/providers/admin_provider.dart';
import 'package:vishv_umiyadham_foundation/utils/app_theme.dart';

class AdminDashboardTab extends StatelessWidget {
  const AdminDashboardTab({super.key});

  @override
  Widget build(BuildContext context) {
    final adminProvider = Provider.of<AdminProvider>(context);

    return RefreshIndicator(
      onRefresh: () async {
        await adminProvider.fetchAdminDashboard();
      },
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'System Overview',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            if (adminProvider.isLoading)
              const Center(child: CircularProgressIndicator())
            else ...[
              _buildStatisticsGrid(adminProvider),
              const SizedBox(height: 24),
              _buildRecentActivities(adminProvider),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildStatisticsGrid(AdminProvider adminProvider) {
    final stats = adminProvider.dashboardData['statistics'] ?? {};

    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      crossAxisSpacing: 16,
      mainAxisSpacing: 16,
      childAspectRatio: 1.2,
      children: [
        _buildStatCard(
          'Total Users',
          '${stats['totalUsers'] ?? 0}',
          Icons.people,
          Colors.blue,
        ),
        _buildStatCard(
          'Pending Captains',
          '${stats['pendingCaptains'] ?? 0}',
          Icons.person_add,
          Colors.orange,
        ),
        _buildStatCard(
          'Total Teams',
          '${stats['totalTeams'] ?? 0}',
          Icons.group,
          Colors.green,
        ),
        _buildStatCard(
          'Live Matches',
          '${stats['liveMatches'] ?? 0}',
          Icons.sports_cricket,
          Colors.red,
        ),
        _buildStatCard(
          'Total Matches',
          '${stats['totalMatches'] ?? 0}',
          Icons.event,
          Colors.purple,
        ),
        _buildStatCard(
          'Pending Removals',
          '${stats['pendingRemovals'] ?? 0}',
          Icons.remove_circle,
          Colors.deepOrange,
        ),
      ],
    );
  }

  Widget _buildStatCard(
      String title, String value, IconData icon, Color color) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 32,
              color: color,
            ),
            const SizedBox(height: 8),
            Text(
              value,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              title,
              style: const TextStyle(
                fontSize: 12,
                color: AppTheme.textLightColor,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRecentActivities(AdminProvider adminProvider) {
    final activities = adminProvider.dashboardData['recentActivities'] ?? {};
    final recentUsers = activities['recentUsers'] ?? [];
    final recentMatches = activities['recentMatches'] ?? [];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Recent Activities',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        Card(
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Recent User Registrations',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 12),
                if (recentUsers.isEmpty)
                  const Text(
                    'No recent user registrations',
                    style: TextStyle(color: AppTheme.textLightColor),
                  )
                else
                  ...recentUsers
                      .take(3)
                      .map<Widget>((user) => _buildUserActivityItem(user))
                      .toList(),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),
        Card(
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Recent Matches',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 12),
                if (recentMatches.isEmpty)
                  const Text(
                    'No recent matches',
                    style: TextStyle(color: AppTheme.textLightColor),
                  )
                else
                  ...recentMatches
                      .take(3)
                      .map<Widget>((match) => _buildMatchActivityItem(match))
                      .toList(),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildUserActivityItem(dynamic user) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: _getRoleColor(user['role']),
            radius: 16,
            child: Text(
              user['name'][0].toUpperCase(),
              style: const TextStyle(
                color: Colors.white,
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  user['name'],
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  '${user['role']} • ${user['email']}',
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppTheme.textLightColor,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: user['isApproved']
                  ? Colors.green.withOpacity(0.1)
                  : Colors.orange.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              user['isApproved'] ? 'Approved' : 'Pending',
              style: TextStyle(
                fontSize: 10,
                color: user['isApproved'] ? Colors.green : Colors.orange,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMatchActivityItem(dynamic match) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          const Icon(
            Icons.sports_cricket,
            color: AppTheme.primaryColor,
            size: 24,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  match['teams'].length >= 2
                      ? '${match['teams'][0]['name']} vs ${match['teams'][1]['name']}'
                      : 'Match',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  'Status: ${match['status']}',
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppTheme.textLightColor,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: _getMatchStatusColor(match['status']).withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              match['status'],
              style: TextStyle(
                fontSize: 10,
                color: _getMatchStatusColor(match['status']),
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Color _getRoleColor(String role) {
    switch (role) {
      case 'Admin':
        return Colors.red;
      case 'Captain':
        return Colors.blue;
      case 'Player':
        return Colors.green;
      default:
        return Colors.grey;
    }
  }

  Color _getMatchStatusColor(String status) {
    switch (status) {
      case 'Live':
        return Colors.green;
      case 'Upcoming':
        return Colors.blue;
      case 'Completed':
        return Colors.grey;
      case 'Cancelled':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }
}
