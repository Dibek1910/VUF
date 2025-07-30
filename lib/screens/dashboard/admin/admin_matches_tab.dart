import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vishv_umiyadham_foundation/providers/admin_provider.dart';
import 'package:vishv_umiyadham_foundation/utils/app_theme.dart';

class AdminMatchesTab extends StatelessWidget {
  const AdminMatchesTab({super.key});

  @override
  Widget build(BuildContext context) {
    final adminProvider = Provider.of<AdminProvider>(context);

    return RefreshIndicator(
      onRefresh: () async {
        await adminProvider.fetchAllMatches();
      },
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    'Match Management',
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const SizedBox(width: 8),
                ElevatedButton.icon(
                  onPressed: () =>
                      _showCreateMatchDialog(context, adminProvider),
                  icon: const Icon(Icons.add),
                  label: const Text('Create Match'),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Expanded(
              child: DefaultTabController(
                length: 4,
                child: Column(
                  children: [
                    const TabBar(
                      tabs: [
                        Tab(text: 'All'),
                        Tab(text: 'Upcoming'),
                        Tab(text: 'Live'),
                        Tab(text: 'Completed'),
                      ],
                      labelColor: AppTheme.primaryColor,
                      unselectedLabelColor: AppTheme.textLightColor,
                      indicatorColor: AppTheme.primaryColor,
                      isScrollable: true,
                    ),
                    const SizedBox(height: 16),
                    Expanded(
                      child: TabBarView(
                        children: [
                          _buildMatchesList(adminProvider, null),
                          _buildMatchesList(adminProvider, 'Upcoming'),
                          _buildMatchesList(adminProvider, 'Live'),
                          _buildMatchesList(adminProvider, 'Completed'),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMatchesList(AdminProvider adminProvider, String? status) {
    if (adminProvider.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    List<dynamic> filteredMatches = adminProvider.allMatches;
    if (status != null) {
      filteredMatches = adminProvider.allMatches
          .where((match) => match['status'] == status)
          .toList();
    }

    if (filteredMatches.isEmpty) {
      return _buildEmptyMatchesState(status);
    }

    return ListView.builder(
      itemCount: filteredMatches.length,
      itemBuilder: (context, index) {
        final match = filteredMatches[index];
        return _buildMatchCard(context, match, adminProvider);
      },
    );
  }

  Widget _buildEmptyMatchesState(String? status) {
    String message = status == null
        ? 'No matches found'
        : 'No ${status.toLowerCase()} matches';

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.sports_cricket,
            size: 64,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 16),
          Text(
            message,
            style: const TextStyle(
              fontSize: 18,
              color: AppTheme.textLightColor,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMatchCard(
      BuildContext context, dynamic match, AdminProvider adminProvider) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
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
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Match',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: _getMatchStatusColor(match['status'])
                            .withOpacity(0.1),
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
                    PopupMenuButton<String>(
                      onSelected: (value) async {
                        if (value == 'edit_score') {
                          _showEditScoreDialog(context, match, adminProvider);
                        } else if (value == 'change_status') {
                          _showChangeStatusDialog(
                              context, match, adminProvider);
                        }
                      },
                      itemBuilder: (context) => [
                        const PopupMenuItem(
                          value: 'edit_score',
                          child: Row(
                            children: [
                              Icon(Icons.edit),
                              SizedBox(width: 8),
                              Text('Edit Score'),
                            ],
                          ),
                        ),
                        const PopupMenuItem(
                          value: 'change_status',
                          child: Row(
                            children: [
                              Icon(Icons.update),
                              SizedBox(width: 8),
                              Text('Change Status'),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: _buildTeamInfo(
                    match['teams'][0],
                    match['scores'].isNotEmpty
                        ? match['scores']
                            .firstWhere(
                                (score) =>
                                    score['teamId']['_id'] ==
                                    match['teams'][0]['_id'],
                                orElse: () => {'score': 0})['score']
                            .toString()
                        : '0',
                    Colors.blue,
                  ),
                ),
                const Text(
                  'VS',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                    color: AppTheme.textLightColor,
                  ),
                ),
                Expanded(
                  child: _buildTeamInfo(
                    match['teams'].length > 1 ? match['teams'][1] : null,
                    match['scores'].length > 1
                        ? match['scores']
                            .firstWhere(
                                (score) =>
                                    score['teamId']['_id'] ==
                                    match['teams'][1]['_id'],
                                orElse: () => {'score': 0})['score']
                            .toString()
                        : '0',
                    Colors.red,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            const Divider(),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: _buildMatchDetailItem(
                      'Location', match['location'] ?? 'TBD'),
                ),
                Expanded(
                  child: _buildMatchDetailItem(
                      'Date', _formatDate(match['matchDate'])),
                ),
              ],
            ),
            if (match['description'] != null &&
                match['description'].isNotEmpty) ...[
              const SizedBox(height: 8),
              _buildMatchDetailItem('Description', match['description']),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildTeamInfo(dynamic team, String score, Color color) {
    return Column(
      children: [
        CircleAvatar(
          backgroundColor: color,
          radius: 24,
          child: Text(
            team != null ? team['name'][0].toUpperCase() : 'T',
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          team?.name ?? 'TBD',
          style: const TextStyle(
            fontWeight: FontWeight.bold,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 4),
        Text(
          score,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _buildMatchDetailItem(String label, String value) {
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

  void _showCreateMatchDialog(
      BuildContext context, AdminProvider adminProvider) {
    String? selectedTeam1;
    String? selectedTeam2;
    final locationController = TextEditingController();
    final descriptionController = TextEditingController();
    DateTime selectedDate = DateTime.now();

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          title: const Text('Create New Match'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                DropdownButtonFormField<String>(
                  decoration: const InputDecoration(
                    labelText: 'Team 1',
                    border: OutlineInputBorder(),
                  ),
                  value: selectedTeam1,
                  items: adminProvider.allTeams
                      .map<DropdownMenuItem<String>>((team) {
                    return DropdownMenuItem<String>(
                      value: team['_id'],
                      child: Text(team['name']),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      selectedTeam1 = value;
                    });
                  },
                ),
                const SizedBox(height: 16),
                DropdownButtonFormField<String>(
                  decoration: const InputDecoration(
                    labelText: 'Team 2',
                    border: OutlineInputBorder(),
                  ),
                  value: selectedTeam2,
                  items: adminProvider.allTeams
                      .where((team) => team['_id'] != selectedTeam1)
                      .map<DropdownMenuItem<String>>((team) {
                    return DropdownMenuItem<String>(
                      value: team['_id'],
                      child: Text(team['name']),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      selectedTeam2 = value;
                    });
                  },
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: locationController,
                  decoration: const InputDecoration(
                    labelText: 'Location',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: descriptionController,
                  decoration: const InputDecoration(
                    labelText: 'Description (Optional)',
                    border: OutlineInputBorder(),
                  ),
                  maxLines: 3,
                ),
                const SizedBox(height: 16),
                ListTile(
                  title: const Text('Match Date'),
                  subtitle: Text(
                      '${selectedDate.day}/${selectedDate.month}/${selectedDate.year}'),
                  trailing: const Icon(Icons.calendar_today),
                  onTap: () async {
                    final date = await showDatePicker(
                      context: context,
                      initialDate: selectedDate,
                      firstDate: DateTime.now(),
                      lastDate: DateTime.now().add(const Duration(days: 365)),
                    );
                    if (date != null) {
                      setState(() {
                        selectedDate = date;
                      });
                    }
                  },
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: (selectedTeam1 != null && selectedTeam2 != null)
                  ? () async {
                      Navigator.of(context).pop();
                      final success = await adminProvider.createMatch(
                        selectedTeam1!,
                        selectedTeam2!,
                        selectedDate,
                        locationController.text.trim(),
                        descriptionController.text.trim(),
                      );
                      if (success && context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Match created successfully!'),
                            backgroundColor: Colors.green,
                          ),
                        );
                      }
                    }
                  : null,
              child: const Text('Create'),
            ),
          ],
        ),
      ),
    );
  }

  void _showEditScoreDialog(
      BuildContext context, dynamic match, AdminProvider adminProvider) {
    final team1Controller = TextEditingController();
    final team2Controller = TextEditingController();

    if (match['scores'].isNotEmpty) {
      team1Controller.text = match['scores'][0]['score'].toString();
      if (match['scores'].length > 1) {
        team2Controller.text = match['scores'][1]['score'].toString();
      }
    }

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Edit Match Score'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: team1Controller,
              decoration: InputDecoration(
                labelText: '${match['teams'][0]['name']} Score',
                border: const OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 16),
            TextField(
              controller: team2Controller,
              decoration: InputDecoration(
                labelText: '${match['teams'][1]['name']} Score',
                border: const OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.of(context).pop();

              final team1Score = int.tryParse(team1Controller.text) ?? 0;
              final team2Score = int.tryParse(team2Controller.text) ?? 0;

              await adminProvider.updateMatchScore(
                match['_id'],
                match['teams'][0]['_id'],
                team1Score,
              );

              await adminProvider.updateMatchScore(
                match['_id'],
                match['teams'][1]['_id'],
                team2Score,
              );

              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Match scores updated successfully!'),
                    backgroundColor: Colors.green,
                  ),
                );
              }
            },
            child: const Text('Update'),
          ),
        ],
      ),
    );
  }

  void _showChangeStatusDialog(
      BuildContext context, dynamic match, AdminProvider adminProvider) {
    String selectedStatus = match['status'];
    final statuses = ['Upcoming', 'Live', 'Completed', 'Cancelled'];

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          title: const Text('Change Match Status'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: statuses
                .map(
                  (status) => RadioListTile<String>(
                    title: Text(status),
                    value: status,
                    groupValue: selectedStatus,
                    onChanged: (value) {
                      setState(() {
                        selectedStatus = value!;
                      });
                    },
                  ),
                )
                .toList(),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () async {
                Navigator.of(context).pop();
                final success = await adminProvider.updateMatchStatus(
                  match['_id'],
                  selectedStatus,
                );
                if (success && context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Match status updated successfully!'),
                      backgroundColor: Colors.green,
                    ),
                  );
                }
              },
              child: const Text('Update'),
            ),
          ],
        ),
      ),
    );
  }

  String _formatDate(String? dateString) {
    if (dateString == null) return 'N/A';
    try {
      final date = DateTime.parse(dateString);
      return '${date.day}/${date.month}/${date.year}';
    } catch (e) {
      return 'N/A';
    }
  }
}
