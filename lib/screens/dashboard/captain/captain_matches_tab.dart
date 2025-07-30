import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vishv_umiyadham_foundation/providers/captain_provider.dart';
import 'package:vishv_umiyadham_foundation/utils/app_theme.dart';

class CaptainMatchesTab extends StatelessWidget {
  const CaptainMatchesTab({super.key});

  @override
  Widget build(BuildContext context) {
    final captainProvider = Provider.of<CaptainProvider>(context);

    return RefreshIndicator(
      onRefresh: () async {
        await captainProvider.fetchCaptainMatches();
      },
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'My Matches',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 24),
            if (captainProvider.isLoading)
              const Center(child: CircularProgressIndicator())
            else if (!captainProvider.isApproved)
              _buildNotApprovedCard()
            else if (captainProvider.captainMatches.isEmpty)
              _buildNoMatchesCard()
            else
              _buildMatchesList(captainProvider),
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
          color: Colors.orange.withAlpha(25),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.orange.withAlpha(77)),
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
                'Please wait for admin approval to view your matches.',
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

  Widget _buildNoMatchesCard() {
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
                Icons.sports_cricket,
                size: 64,
                color: AppTheme.textLightColor,
              ),
              SizedBox(height: 16),
              Text(
                'No Matches Found',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 8),
              Text(
                'Your team matches will appear here once scheduled by the admin.',
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

  Widget _buildMatchesList(CaptainProvider captainProvider) {
    return Column(
      children: captainProvider.captainMatches
          .map((match) => _buildMatchCard(match))
          .toList(),
    );
  }

  Widget _buildMatchCard(dynamic match) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.only(bottom: 16),
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
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        match.title ?? 'Match',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        match.matchDate != null
                            ? match.matchDate.toString().split(' ')[0]
                            : 'TBD',
                        style: const TextStyle(
                          color: AppTheme.textLightColor,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: _getMatchStatusColor(match.status).withAlpha(25),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    match.status ?? 'Unknown',
                    style: TextStyle(
                      fontSize: 12,
                      color: _getMatchStatusColor(match.status),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            const Divider(),
            const SizedBox(height: 16),
            if (match.teams != null && match.teams.isNotEmpty)
              Row(
                children: [
                  Expanded(
                    child: _buildTeamInfo(match.teams[0]),
                  ),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    child: Text(
                      'VS',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: AppTheme.textLightColor,
                      ),
                    ),
                  ),
                  Expanded(
                    child: match.teams.length > 1
                        ? _buildTeamInfo(match.teams[1])
                        : _buildTBDTeam(),
                  ),
                ],
              )
            else
              const Center(
                child: Text(
                  'Teams not assigned yet',
                  style: TextStyle(
                    color: AppTheme.textLightColor,
                  ),
                ),
              ),
            if (match.description != null && match.description.isNotEmpty) ...[
              const SizedBox(height: 16),
              const Divider(),
              const SizedBox(height: 8),
              const Text(
                'Description:',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                match.description,
                style: const TextStyle(
                  color: AppTheme.textLightColor,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildTeamInfo(dynamic team) {
    return Column(
      children: [
        CircleAvatar(
          backgroundColor: Colors.blue,
          radius: 24,
          child: Text(
            (team.name ?? 'T')[0].toUpperCase(),
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          team.name ?? 'Team',
          style: const TextStyle(
            fontWeight: FontWeight.bold,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildTBDTeam() {
    return const Column(
      children: [
        CircleAvatar(
          backgroundColor: AppTheme.textLightColor,
          radius: 24,
          child: Text(
            '?',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
        ),
        SizedBox(height: 8),
        Text(
          'TBD',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: AppTheme.textLightColor,
          ),
          textAlign: TextAlign.center,
        ),
      ],
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
}
