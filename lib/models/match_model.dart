import 'package:vishv_umiyadham_foundation/models/team_model.dart';

class Match {
  final String id;
  final String status;
  final List<Team> teams;
  final Map<String, int> scores;
  final DateTime? matchDate;
  final String? location;
  final String? description;

  Match({
    required this.id,
    required this.status,
    required this.teams,
    required this.scores,
    this.matchDate,
    this.location,
    this.description,
  });

  factory Match.fromJson(Map<String, dynamic> json) {
    Map<String, int> scoresMap = {};
    if (json['scores'] != null) {
      for (var score in json['scores']) {
        scoresMap[score['teamId']['_id'] ?? score['teamId']['id']] =
            score['score'] ?? 0;
      }
    }

    return Match(
      id: json['_id']?.toString() ?? json['id']?.toString() ?? '',
      status: json['status'] ?? 'Upcoming',
      teams: (json['teams'] as List? ?? [])
          .map((team) => Team.fromJson(team))
          .toList(),
      scores: scoresMap,
      matchDate:
          json['matchDate'] != null ? DateTime.parse(json['matchDate']) : null,
      location: json['location'],
      description: json['description'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'status': status,
      'teams': teams.map((team) => team.toJson()).toList(),
      'scores': scores,
      'matchDate': matchDate?.toIso8601String(),
      'location': location,
      'description': description,
    };
  }
}
