
import 'package:flutter_task_app/features/matching_pairs/model/match_item.dart';

class GameData {
  final List<MatchItem> leftItems;
  final List<MatchItem> rightItems;
  final List<MatchConnection> connections;
  final String? selectedItemId;
  final List<MatchConnection> correctConnections;
  final bool submitted;
  final int score;
  final int total;

  const GameData({
    required this.leftItems,
    required this.rightItems,
    required this.connections,
    this.selectedItemId,
    required this.correctConnections,
    required this.submitted,
    required this.score,
    required this.total,
  });

  factory GameData.empty() {
    return const GameData(
      leftItems: [],
      rightItems: [],
      connections: [],
      correctConnections: [],
      submitted: false,
      score: 0,
      total: 0,
    );
  }
}