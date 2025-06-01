import 'package:flutter_task_app/features/matching_pairs/cubit/matching_pairs_state.dart';
import 'package:flutter_task_app/features/matching_pairs/model/game_data.dart';

class GameDataExtractor {
  static GameData extract(MatchingPairsState state) {
    if (state is MatchingPairsInitial) {
      return GameData(
        leftItems: state.leftItems,
        rightItems: state.rightItems,
        connections: state.connections,
        selectedItemId: state.selectedItemId,
        correctConnections: [],
        submitted: false,
        score: 0,
        total: 0,
      );
    } else if (state is MatchingPairsInProgress) {
      return GameData(
        leftItems: state.leftItems,
        rightItems: state.rightItems,
        connections: state.connections,
        selectedItemId: state.selectedItemId,
        correctConnections: [],
        submitted: false,
        score: 0,
        total: 0,
      );
    } else if (state is MatchingPairsSubmitted) {
      return GameData(
        leftItems: state.leftItems,
        rightItems: state.rightItems,
        connections: state.userConnections,
        selectedItemId: null,
        correctConnections: state.correctConnections,
        submitted: true,
        score: state.score,
        total: state.total,
      );
    }
    return GameData.empty();
  }
}