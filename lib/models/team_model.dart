import 'package:vishv_umiyadham_foundation/models/user_model.dart';

class Team {
  final String id;
  final String name;
  final User captain;
  final List<User> players;
  final String? removalRequested;

  Team({
    required this.id,
    required this.name,
    required this.captain,
    required this.players,
    this.removalRequested,
  });

  factory Team.fromJson(Map<String, dynamic> json) {
    return Team(
      id: json['_id']?.toString() ?? json['id']?.toString() ?? '',
      name: json['name'] ?? '',
      captain: User.fromJson(json['captainId'] ?? {}),
      players: (json['players'] as List? ?? [])
          .map((player) => User.fromJson(player))
          .toList(),
      removalRequested: json['removalRequested']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'captain': captain.toJson(),
      'players': players.map((player) => player.toJson()).toList(),
      'removalRequested': removalRequested,
    };
  }
}
