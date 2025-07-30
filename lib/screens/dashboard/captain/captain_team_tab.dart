import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vishv_umiyadham_foundation/providers/captain_provider.dart';
import 'package:vishv_umiyadham_foundation/utils/app_theme.dart';

class CaptainTeamTab extends StatelessWidget {
  const CaptainTeamTab({super.key});

  @override
  Widget build(BuildContext context) {
    final captainProvider = Provider.of<CaptainProvider>(context);

    return RefreshIndicator(
      onRefresh: () async {
        await captainProvider.fetchCaptainDashboard();
        await captainProvider.fetchCaptainTeams();
      },
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (captainProvider.isLoading)
              const Center(child: CircularProgressIndicator())
            else if (!captainProvider.isApproved)
              _buildNotApprovedCard()
            else if (captainProvider.currentTeam == null)
              _buildNoTeamSection(context, captainProvider)
            else ...[
              _buildTeamInfoCard(
                  context, captainProvider.currentTeam!, captainProvider),
              const SizedBox(height: 24),
              _buildPlayersSection(
                  context, captainProvider.currentTeam!, captainProvider),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildNotApprovedCard() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Container(
        padding: const EdgeInsets.all(32),
        decoration: BoxDecoration(
          color: Colors.orange.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.orange.withOpacity(0.3)),
        ),
        child: const Center(
          child: Column(
            children: [
              Icon(
                Icons.hourglass_empty,
                size: 64,
                color: Colors.orange,
              ),
              SizedBox(height: 16),
              Text(
                'Captain Approval Pending',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.orange,
                ),
              ),
              SizedBox(height: 8),
              Text(
                'Please wait for admin approval before you can create and manage teams.',
                style: TextStyle(
                  color: Colors.orange,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNoTeamSection(
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
                'Create your team to start managing players',
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

  Widget _buildTeamInfoCard(
      BuildContext context, team, CaptainProvider captainProvider) {
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
                        'Your Team',
                        style: TextStyle(
                          fontSize: 14,
                          color: AppTheme.textLightColor,
                        ),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.edit),
                  onPressed: () =>
                      _showEditTeamDialog(context, team, captainProvider),
                ),
              ],
            ),
            const SizedBox(height: 16),
            const Divider(),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildTeamInfoItem('Total Players', '${team.players.length}'),
                _buildTeamInfoItem('Captain', team.captain.name),
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

  Widget _buildPlayersSection(
      BuildContext context, team, CaptainProvider captainProvider) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Expanded(
              child: Text(
                'Players',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Text(
              '(${team.players.length})',
              style: const TextStyle(
                fontSize: 16,
                color: AppTheme.textLightColor,
              ),
            ),
            const SizedBox(width: 16),
            ElevatedButton.icon(
              onPressed: () {
                _showAddPlayerDialog(context, team, captainProvider);
              },
              icon: const Icon(Icons.add),
              label: const Text('Add Player'),
              style: ElevatedButton.styleFrom(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        if (team.players.isEmpty)
          Card(
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
                      Icons.person_add,
                      size: 48,
                      color: AppTheme.textLightColor,
                    ),
                    SizedBox(height: 8),
                    Text(
                      'No players in your team yet',
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
                trailing: !isCaptain
                    ? PopupMenuButton<String>(
                        onSelected: (value) async {
                          if (value == 'jersey') {
                            _showAssignJerseyDialog(
                                context, team, player, captainProvider);
                          } else if (value == 'remove') {
                            _showRemovePlayerDialog(
                                context, team, player, captainProvider);
                          }
                        },
                        itemBuilder: (context) => [
                          const PopupMenuItem(
                            value: 'jersey',
                            child: Row(
                              children: [
                                Icon(Icons.sports_soccer, color: Colors.blue),
                                SizedBox(width: 8),
                                Text('Assign Jersey'),
                              ],
                            ),
                          ),
                          const PopupMenuItem(
                            value: 'remove',
                            child: Row(
                              children: [
                                Icon(Icons.remove_circle, color: Colors.red),
                                SizedBox(width: 8),
                                Text('Request Removal'),
                              ],
                            ),
                          ),
                        ],
                      )
                    : Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: AppTheme.primaryColor.withOpacity(0.1),
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
              ),
            );
          }).toList(),
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

  void _showEditTeamDialog(
      BuildContext context, team, CaptainProvider captainProvider) {
    final teamNameController = TextEditingController(text: team.name);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Edit Team'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
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
                final success = await captainProvider.updateTeam(
                  team.id,
                  teamNameController.text.trim(),
                  null,
                );
                if (success && context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Team updated successfully!'),
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
            child: const Text('Update'),
          ),
        ],
      ),
    );
  }

  void _showAddPlayerDialog(
      BuildContext context, team, CaptainProvider captainProvider) {
    final playerIdController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add Player'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Enter the player\'s unique ID to send them a team invitation.',
              style: TextStyle(
                color: AppTheme.textLightColor,
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: playerIdController,
              decoration: const InputDecoration(
                labelText: 'Player Unique ID',
                hintText: 'Enter player unique ID',
                prefixIcon: Icon(Icons.person),
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
              if (playerIdController.text.isNotEmpty) {
                Navigator.of(context).pop();
                final success = await captainProvider.invitePlayer(
                  team.id,
                  playerIdController.text.trim(),
                );
                if (success && context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Player invitation sent successfully!'),
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
            child: const Text('Send Invitation'),
          ),
        ],
      ),
    );
  }

  void _showAssignJerseyDialog(
      BuildContext context, team, player, CaptainProvider captainProvider) {
    final jerseyController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Assign Jersey Number'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Assign jersey number to ${player.name}',
              style: const TextStyle(
                color: AppTheme.textLightColor,
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: jerseyController,
              decoration: const InputDecoration(
                labelText: 'Jersey Number',
                hintText: 'Enter jersey number (1-99)',
                prefixIcon: Icon(Icons.sports_soccer),
              ),
              keyboardType: TextInputType.number,
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
              final jerseyNumber = int.tryParse(jerseyController.text);
              if (jerseyNumber != null &&
                  jerseyNumber > 0 &&
                  jerseyNumber <= 99) {
                Navigator.of(context).pop();
                final success = await captainProvider.assignJerseyNumber(
                  team.id,
                  player.id,
                  jerseyNumber,
                );
                if (success && context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                          'Jersey number $jerseyNumber assigned to ${player.name}!'),
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
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Please enter a valid jersey number (1-99)'),
                    backgroundColor: Colors.red,
                  ),
                );
              }
            },
            child: const Text('Assign'),
          ),
        ],
      ),
    );
  }

  void _showRemovePlayerDialog(
      BuildContext context, team, player, CaptainProvider captainProvider) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Remove Player'),
        content: Text(
          'Are you sure you want to request removal of "${player.name}" from your team? This request will need admin approval.',
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
              Navigator.of(context).pop();
              final success = await captainProvider.requestPlayerRemoval(
                team.id,
                player.id,
              );
              if (success && context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Player removal request sent to admin'),
                    backgroundColor: Colors.orange,
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
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            child: const Text('Request Removal'),
          ),
        ],
      ),
    );
  }
}
