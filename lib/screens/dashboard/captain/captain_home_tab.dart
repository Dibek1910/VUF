import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vishv_umiyadham_foundation/providers/auth_provider.dart';
import 'package:vishv_umiyadham_foundation/providers/captain_provider.dart';
import 'package:vishv_umiyadham_foundation/utils/app_theme.dart';

class CaptainHomeTab extends StatelessWidget {
  const CaptainHomeTab({super.key});

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final captainProvider = Provider.of<CaptainProvider>(context);
    final user = authProvider.user;

    return RefreshIndicator(
      onRefresh: () async {
        await captainProvider.fetchCaptainDashboard();
      },
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildCaptainInfoCard(user, captainProvider),
            const SizedBox(height: 24),
            if (!captainProvider.isApproved) ...[
              _buildApprovalPendingCard(),
              const SizedBox(height: 24),
            ],
            if (captainProvider.isApproved) ...[
              _buildStatisticsSection(captainProvider),
              const SizedBox(height: 24),
              _buildTeamSection(context, captainProvider),
              const SizedBox(height: 24),
              _buildRecentMatchesSection(context, captainProvider),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildCaptainInfoCard(user, CaptainProvider captainProvider) {
    final dashboardData = captainProvider.dashboardData;
    final captain = dashboardData['captain'] ?? {};

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  backgroundColor: AppTheme.primaryColor,
                  radius: 30,
                  child: Text(
                    (captain['name'] ?? user?.name ?? 'C')
                        .substring(0, 1)
                        .toUpperCase(),
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        captain['name'] ?? user?.name ?? 'Captain',
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        captain['email'] ??
                            user?.email ??
                            'captain@example.com',
                        style: const TextStyle(
                          fontSize: 14,
                          color: AppTheme.textLightColor,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: AppTheme.primaryColor.withAlpha(25),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Text(
                              'Captain',
                              style: TextStyle(
                                fontSize: 12,
                                color: AppTheme.primaryColor,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: (captain['isApproved'] ?? false)
                                  ? Colors.green.withAlpha(25)
                                  : Colors.orange.withAlpha(25),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              (captain['isApproved'] ?? false)
                                  ? 'Approved'
                                  : 'Pending',
                              style: TextStyle(
                                fontSize: 12,
                                color: (captain['isApproved'] ?? false)
                                    ? Colors.green
                                    : Colors.orange,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            const Divider(),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildInfoItem('Unique ID',
                    captain['uniqueId'] ?? user?.uniqueId ?? 'Loading...'),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildApprovalPendingCard() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.orange.withAlpha(25),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.orange.withAlpha(77)),
        ),
        child: const Column(
          children: [
            Icon(
              Icons.hourglass_empty,
              size: 48,
              color: Colors.orange,
            ),
            SizedBox(height: 16),
            Text(
              'Approval Pending',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.orange,
              ),
            ),
            SizedBox(height: 8),
            Text(
              'Your captain registration is pending admin approval. You will be able to create teams and manage players once approved.',
              style: TextStyle(
                color: Colors.orange,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatisticsSection(CaptainProvider captainProvider) {
    final statistics = captainProvider.dashboardData['statistics'] ?? {};

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Statistics',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        GridView.count(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisCount: 2,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          childAspectRatio: 1.2,
          children: [
            _buildStatCard(
              'Teams',
              '${statistics['totalTeams'] ?? 0}',
              Icons.group,
              Colors.blue,
            ),
            _buildStatCard(
              'Players',
              '${statistics['totalPlayers'] ?? 0}',
              Icons.people,
              Colors.green,
            ),
            _buildStatCard(
              'Matches',
              '${statistics['totalMatches'] ?? 0}',
              Icons.sports_cricket,
              Colors.orange,
            ),
            _buildStatCard(
              'Pending Invites',
              '${statistics['pendingInvitations'] ?? 0}',
              Icons.mail_outline,
              Colors.purple,
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildStatCard(
      String title, String value, IconData icon, Color color) {
    return Card(
      elevation: 2,
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

  Widget _buildTeamSection(
      BuildContext context, CaptainProvider captainProvider) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'My Team',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            if (captainProvider.currentTeam == null &&
                !captainProvider.isLoading)
              ElevatedButton.icon(
                onPressed: () =>
                    _showCreateTeamDialog(context, captainProvider),
                icon: const Icon(Icons.add),
                label: const Text('Create Team'),
              ),
          ],
        ),
        const SizedBox(height: 16),
        if (captainProvider.isLoading)
          const Center(child: CircularProgressIndicator())
        else if (captainProvider.currentTeam == null)
          _buildNoTeamCard(context, captainProvider)
        else
          _buildTeamCard(captainProvider.currentTeam!),
      ],
    );
  }

  Widget _buildNoTeamCard(
      BuildContext context, CaptainProvider captainProvider) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Center(
          child: Column(
            children: [
              const Icon(
                Icons.group_add,
                size: 64,
                color: AppTheme.textLightColor,
              ),
              const SizedBox(height: 16),
              const Text(
                'No Team Created',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Create your team to start managing players and matches',
                style: TextStyle(
                  color: AppTheme.textLightColor,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              ElevatedButton.icon(
                onPressed: () =>
                    _showCreateTeamDialog(context, captainProvider),
                icon: const Icon(Icons.add),
                label: const Text('Create Team'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTeamCard(team) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    color: Colors.blue,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Center(
                    child: Text(
                      team.name[0].toUpperCase(),
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 24,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        team.name,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${team.players.length} Players',
                        style: const TextStyle(
                          fontSize: 14,
                          color: AppTheme.textLightColor,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            const Divider(),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Captain: ${team.captain.name}',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRecentMatchesSection(
      BuildContext context, CaptainProvider captainProvider) {
    final recentMatches = captainProvider.dashboardData['recentMatches'] ?? [];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Recent Matches',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            TextButton.icon(
              onPressed: () {},
              icon: const Icon(Icons.arrow_forward),
              label: const Text('View All'),
            ),
          ],
        ),
        const SizedBox(height: 16),
        if (captainProvider.isLoading)
          const Center(child: CircularProgressIndicator())
        else if (recentMatches.isEmpty)
          Card(
            elevation: 2,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Padding(
              padding: EdgeInsets.all(16),
              child: Center(
                child: Column(
                  children: [
                    Icon(
                      Icons.sports_cricket,
                      size: 48,
                      color: AppTheme.textLightColor,
                    ),
                    SizedBox(height: 8),
                    Text(
                      'No matches found',
                      style: TextStyle(
                        color: AppTheme.textLightColor,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          )
        else
          ...recentMatches.take(3).map((match) => _buildMatchCard(match)),
      ],
    );
  }

  Widget _buildMatchCard(dynamic match) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  match['matchDate'] != null
                      ? DateTime.parse(match['matchDate'])
                          .toString()
                          .split(' ')[0]
                      : 'TBD',
                  style: const TextStyle(
                    color: AppTheme.textLightColor,
                    fontSize: 12,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: _getMatchStatusColor(match['status']).withAlpha(25),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    match['status'],
                    style: TextStyle(
                      fontSize: 12,
                      color: _getMatchStatusColor(match['status']),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    children: [
                      CircleAvatar(
                        backgroundColor: Colors.blue,
                        radius: 20,
                        child: Text(
                          (match['teams'][0]['name'] ?? 'T')[0].toUpperCase(),
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        match['teams'][0]['name'] ?? 'Team 1',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                const Text(
                  'VS',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: AppTheme.textLightColor,
                  ),
                ),
                Expanded(
                  child: Column(
                    children: [
                      CircleAvatar(
                        backgroundColor: Colors.red,
                        radius: 20,
                        child: Text(
                          match['teams'].length > 1
                              ? (match['teams'][1]['name'] ?? 'T')[0]
                                  .toUpperCase()
                              : 'T',
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        match['teams'].length > 1
                            ? match['teams'][1]['name'] ?? 'Team 2'
                            : 'TBD',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Color _getMatchStatusColor(String? status) {
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

  Widget _buildInfoItem(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            color: AppTheme.textLightColor,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  void _showCreateTeamDialog(
      BuildContext context, CaptainProvider captainProvider) {
    final teamNameController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Create Team'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Enter your team name to create a new team.',
              style: TextStyle(
                color: AppTheme.textLightColor,
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: teamNameController,
              decoration: const InputDecoration(
                labelText: 'Team Name',
                hintText: 'Enter team name',
                prefixIcon: Icon(Icons.group),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              if (teamNameController.text.isNotEmpty) {
                Navigator.of(context).pop();
                final success = await captainProvider
                    .createTeam(teamNameController.text.trim());
                if (success && context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Team created successfully!'),
                      backgroundColor: Colors.green,
                    ),
                  );
                } else if (context.mounted && captainProvider.error != null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(captainProvider.error!),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              }
            },
            child: const Text('Create Team'),
          ),
        ],
      ),
    );
  }
}
