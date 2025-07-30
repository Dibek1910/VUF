import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vishv_umiyadham_foundation/providers/player_provider.dart';
import 'package:vishv_umiyadham_foundation/utils/app_theme.dart';

class PlayerTeamTab extends StatelessWidget {
  const PlayerTeamTab({super.key});

  @override
  Widget build(BuildContext context) {
    final playerProvider = Provider.of<PlayerProvider>(context);

    return RefreshIndicator(
      onRefresh: () async {
        await playerProvider.fetchPlayerTeam();
      },
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (playerProvider.isLoading)
              const Center(child: CircularProgressIndicator())
            else if (playerProvider.playerTeam == null)
              _buildNoTeamCard()
            else ...[
              _buildTeamInfoCard(playerProvider.playerTeam!),
              const SizedBox(height: 24),
              _buildTeamMembersSection(playerProvider.playerTeam!),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildNoTeamCard() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: const Padding(
        padding: EdgeInsets.all(32),
        child: Center(
          child: Column(
            children: [
              Icon(
                Icons.group_off,
                size: 64,
                color: AppTheme.textLightColor,
              ),
              SizedBox(height: 16),
              Text(
                'You are not part of any team yet',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 8),
              Text(
                'Wait for team invitations from captains',
                style: TextStyle(
                  color: AppTheme.textLightColor,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTeamInfoCard(team) {
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
                  width: 60,
                  height: 60,
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
                        fontSize: 30,
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
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      const Text(
                        'Joined team',
                        style: TextStyle(
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
                _buildTeamInfoItem('Captain', team.captain.name),
                _buildTeamInfoItem('Total Players', '${team.players.length}'),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTeamInfoItem(String label, String value) {
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

  Widget _buildTeamMembersSection(team) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Team Members',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        ...team.players.map<Widget>((player) {
          final isCaptain = player.id == team.captain.id;
          return Card(
            margin: const EdgeInsets.only(bottom: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: ListTile(
              contentPadding: const EdgeInsets.all(16),
              leading: CircleAvatar(
                backgroundColor:
                    isCaptain ? AppTheme.primaryColor : Colors.blue,
                child: Text(
                  player.name[0].toUpperCase(),
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              title: Text(
                isCaptain ? '${player.name} (Captain)' : player.name,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 4),
                  Text('Email: ${player.email}'),
                  if (player.phone != null) ...[
                    const SizedBox(height: 4),
                    Text('Phone: ${player.phone}'),
                  ],
                  const SizedBox(height: 4),
                  Text('ID: ${player.uniqueId}'),
                ],
              ),
              trailing: isCaptain
                  ? Container(
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
                    )
                  : null,
            ),
          );
        }).toList(),
      ],
    );
  }
}
