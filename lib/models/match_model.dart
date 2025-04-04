import 'package:vishv_umiyadham_foundation/models/team_model.dart';

class Match {
  final String id;
  final String status;
  final List<Team> teams;
  final Map<String, int> scores;

  Match({
    required this.id,
    required this.status,
    required this.teams,
    required this.scores,
  });

  factory Match.fromJson(Map<String, dynamic> json) {
    return Match(
      id: json['id'].toString(),
      status: json['status'],
      teams:
          (json['teams'] as List).map((team) => Team.fromJson(team)).toList(),
      scores: Map<String, int>.from(json['score']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'status': status,
      'teams': teams.map((team) => team.toJson()).toList(),
      'score': scores,
    };
  }
}
