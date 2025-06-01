import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_task_app/features/matching_pairs/cubit/matching_pairs_state.dart';
import 'package:flutter_task_app/features/matching_pairs/model/match_item.dart';


class MatchingPairsCubit extends Cubit<MatchingPairsState> {
  final Map<String, String> _correctPairs = {
    'l1': 'r3',
    'l2': 'r2', 
    'l3': 'r1', 
  };

  MatchingPairsCubit() : super(MatchingPairsInitial());

  void itemSelected(String itemId) {
    if (state is MatchingPairsInitial) {
      final initialState = state as MatchingPairsInitial;
      emit(MatchingPairsInProgress(
        leftItems: initialState.leftItems,
        rightItems: initialState.rightItems,
        connections: initialState.connections,
        selectedItemId: itemId,
      ));
    } else if (state is MatchingPairsInProgress) {
      final currentState = state as MatchingPairsInProgress;
      if (currentState.selectedItemId == null) {
        emit(MatchingPairsInProgress(
          leftItems: currentState.leftItems,
          rightItems: currentState.rightItems,
          connections: currentState.connections,
          selectedItemId: itemId,
        ));
      } else {
        final firstItem = _findItem(currentState.leftItems, currentState.rightItems, currentState.selectedItemId!);
        final secondItem = _findItem(currentState.leftItems, currentState.rightItems, itemId);

        if (firstItem != null && secondItem != null && firstItem.group != secondItem.group) {
          final newConnection = MatchConnection(fromId: firstItem.id, toId: secondItem.id);
          List<MatchConnection> updatedConnections = List.from(currentState.connections);

          updatedConnections.removeWhere((conn) => conn.fromId == firstItem.id || conn.toId == firstItem.id || conn.fromId == secondItem.id || conn.toId == secondItem.id);

          updatedConnections.add(newConnection);

          emit(MatchingPairsInProgress(
            leftItems: currentState.leftItems,
            rightItems: currentState.rightItems,
            connections: updatedConnections,
            selectedItemId: null, 
          ));
        } else {
          emit(MatchingPairsInProgress(
            leftItems: currentState.leftItems,
            rightItems: currentState.rightItems,
            connections: currentState.connections,
            selectedItemId: itemId,
          ));
        }
      }
    }
     else if (state is MatchingPairsSubmitted) {
     }
  }

  void submitAnswers() {
    if (state is MatchingPairsInProgress) {
      final currentState = state as MatchingPairsInProgress;
      final correctConnections = _getCorrectConnections();
      int score = 0;
      for (var userConn in currentState.connections) {
        if (correctConnections.contains(userConn)) {
          score++;
        }
      }

      emit(MatchingPairsSubmitted(
        leftItems: currentState.leftItems,
        rightItems: currentState.rightItems,
        userConnections: currentState.connections,
        correctConnections: correctConnections,
        score: score,
        total: correctConnections.length,
      ));
    }
  }

  void resetExercise() {
    emit(MatchingPairsInitial());
  }

  MatchItem? _findItem(List<MatchItem> left, List<MatchItem> right, String id) {
    try {
      return left.firstWhere((item) => item.id == id);
    } catch (e) {
      try {
        return right.firstWhere((item) => item.id == id);
      } catch (e) {
        return null;
      }
    }
  }

  List<MatchConnection> _getCorrectConnections() {
    return _correctPairs.entries.map((entry) => MatchConnection(fromId: entry.key, toId: entry.value)).toList();
  }
}
