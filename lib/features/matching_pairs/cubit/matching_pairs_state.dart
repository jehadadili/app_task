
import 'package:flutter_task_app/features/matching_pairs/model/match_item.dart';

abstract class MatchingPairsState {}

class MatchingPairsInitial extends MatchingPairsState {
  final List<MatchItem> leftItems = [
    MatchItem(id: 'l1', text: 'Flutter', group: 'left'),
    MatchItem(id: 'l2', text: 'Firebase', group: 'left'),
    MatchItem(id: 'l3', text: 'Dart', group: 'left'),
  ];
  final List<MatchItem> rightItems = [
    MatchItem(id: 'r1', text: 'Programming Language', group: 'right'),
    MatchItem(id: 'r2', text: 'Cloud Backend', group: 'right'),
    MatchItem(id: 'r3', text: 'UI Framework', group: 'right'),
  ];
  final List<MatchConnection> connections;
  final String? selectedItemId;

  MatchingPairsInitial({this.connections = const [], this.selectedItemId});
}

class MatchingPairsInProgress extends MatchingPairsState {
  final List<MatchItem> leftItems;
  final List<MatchItem> rightItems;
  final List<MatchConnection> connections;
  final String? selectedItemId;

  MatchingPairsInProgress({
    required this.leftItems,
    required this.rightItems,
    required this.connections,
    this.selectedItemId,
  });
}

class MatchingPairsSubmitted extends MatchingPairsState {
  final List<MatchItem> leftItems;
  final List<MatchItem> rightItems;
  final List<MatchConnection> userConnections;
  final List<MatchConnection> correctConnections;
  final int score;
  final int total;

  MatchingPairsSubmitted({
    required this.leftItems,
    required this.rightItems,
    required this.userConnections,
    required this.correctConnections,
    required this.score,
    required this.total,
  });
}
