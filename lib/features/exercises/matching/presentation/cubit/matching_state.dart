

abstract class MatchingState {}

class MatchingInitial extends MatchingState {}

class MatchingLoaded extends MatchingState {
  final List<String> leftItems; 
  final List<String> rightItems;

  MatchingLoaded({required this.leftItems, required this.rightItems});
}

class MatchingChecking extends MatchingState {}

class MatchingResult extends MatchingState {
  final int correctMatches;
  final int totalPairs;

  MatchingResult({required this.correctMatches, required this.totalPairs});
}

class MatchingError extends MatchingState {
  final String message;
  MatchingError(this.message);
}

