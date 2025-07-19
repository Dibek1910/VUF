import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vishv_umiyadham_foundation/providers/player_provider.dart';
import 'package:vishv_umiyadham_foundation/utils/app_theme.dart';

class PlayerMatchesTab extends StatelessWidget {
  const PlayerMatchesTab({super.key});

  @override
  Widget build(BuildContext context) {
    final playerProvider = Provider.of<PlayerProvider>(context);

    return RefreshIndicator(
      onRefresh: () async {
        await playerProvider.fetchPlayerMatches();
      },
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Team Matches',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: DefaultTabController(
                length: 3,
                child: Column(
                  children: [
                    const TabBar(
                      tabs: [
                        Tab(text: 'Upcoming'),
                        Tab(text: 'Live'),
                        Tab(text: 'Completed'),
                      ],
                      labelColor: AppTheme.primaryColor,
                      unselectedLabelColor: AppTheme.textLightColor,
                      indicatorColor: AppTheme.primaryColor,
                    ),
                    const SizedBox(height: 16),
                    Expanded(
                      child: TabBarView(
                        children: [
                          _buildMatchesList(playerProvider, 'Upcoming'),
                          _buildMatchesList(playerProvider, 'Live'),
                          _buildMatchesList(playerProvider, 'Completed'),
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

  Widget _buildMatchesList(PlayerProvider playerProvider, String status) {
    if (playerProvider.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    final filteredMatches = playerProvider.playerMatches
        .where((match) => match.status == status)
        .toList();

    if (filteredMatches.isEmpty) {
      return _buildEmptyMatchesState(status);
    }

    return ListView.builder(
      itemCount: filteredMatches.length,
      itemBuilder: (context, index) {
        final match = filteredMatches[index];
        return _buildMatchCard(match, status);
      },
    );
  }

  Widget _buildEmptyMatchesState(String status) {
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
            'No $status matches',
            style: const TextStyle(
              fontSize: 18,
              color: AppTheme.textLightColor,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            _getEmptyStateMessage(status),
            style: const TextStyle(
              fontSize: 14,
              color: AppTheme.textLightColor,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  String _getEmptyStateMessage(String status) {
    switch (status) {
      case 'Upcoming':
        return 'No upcoming matches scheduled for your team';
      case 'Live':
        return 'No live matches at the moment';
      case 'Completed':
        return 'No completed matches to show';
      default:
        return 'No matches found';
    }
  }

  Widget _buildMatchCard(match, String status) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildMatchHeader(match, status),
            const SizedBox(height: 16),
            _buildMatchTeams(match, status),
            if (status == 'Upcoming') ...[
              const SizedBox(height: 16),
              _buildMatchDetails(match),
            ],
            if (status == 'Live') ...[
              const SizedBox(height: 16),
              _buildLiveMatchIndicator(),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildMatchHeader(match, String status) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text(
          'Match',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(
            horizontal: 8,
            vertical: 4,
          ),
          decoration: BoxDecoration(
            color: _getStatusColor(status).withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            status,
            style: TextStyle(
              fontSize: 12,
              color: _getStatusColor(status),
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'Upcoming':
        return Colors.blue;
      case 'Live':
        return Colors.green;
      case 'Completed':
        return Colors.grey;
      default:
        return Colors.grey;
    }
  }

  Widget _buildMatchTeams(match, String status) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: _buildTeamInfo(
            match.teams[0],
            status != 'Upcoming' && match.scores.isNotEmpty
                ? '${match.scores[match.teams[0].id] ?? 0}'
                : null,
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
            match.teams.length > 1 ? match.teams[1] : null,
            status != 'Upcoming' &&
                    match.scores.isNotEmpty &&
                    match.teams.length > 1
                ? '${match.scores[match.teams[1].id] ?? 0}'
                : null,
            Colors.red,
          ),
        ),
      ],
    );
  }

  Widget _buildTeamInfo(team, String? score, Color color) {
    return Column(
      children: [
        CircleAvatar(
          backgroundColor: color,
          radius: 24,
          child: Text(
            team != null ? team.name[0].toUpperCase() : 'T',
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
        if (score != null) ...[
          const SizedBox(height: 4),
          Text(
            score,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildMatchDetails(match) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            const Icon(
              Icons.calendar_today,
              size: 16,
              color: AppTheme.textLightColor,
            ),
            const SizedBox(width: 4),
            Text(
              'Date: ${DateTime.now().day}/${DateTime.now().month}/${DateTime.now().year}',
              style: const TextStyle(
                color: AppTheme.textLightColor,
              ),
            ),
          ],
        ),
        Row(
          children: [
            const Icon(
              Icons.access_time,
              size: 16,
              color: AppTheme.textLightColor,
            ),
            const SizedBox(width: 4),
            const Text(
              'Time: TBD',
              style: TextStyle(
                color: AppTheme.textLightColor,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildLiveMatchIndicator() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.green.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.green.withOpacity(0.3)),
      ),
      child: Row(
        children: [
          Container(
            width: 8,
            height: 8,
            decoration: const BoxDecoration(
              color: Colors.green,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 8),
          const Text(
            'Match is currently live',
            style: TextStyle(
              color: Colors.green,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
