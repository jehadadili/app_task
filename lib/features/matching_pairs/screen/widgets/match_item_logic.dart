
import 'package:flutter_task_app/features/matching_pairs/model/game_data.dart';
import 'package:flutter_task_app/features/matching_pairs/model/match_item.dart';

class MatchItemLogic {
  static bool? getItemCorrectness(MatchItem item, GameData gameData) {
    if (!gameData.submitted) return null;
    
    final userConnection = gameData.connections.firstWhere(
      (c) => c.fromId == item.id || c.toId == item.id,
      orElse: () => MatchConnection(fromId: '', toId: ''),
    );
    
    if (userConnection.fromId.isEmpty) return null;
    return gameData.correctConnections.contains(userConnection);
  }
}