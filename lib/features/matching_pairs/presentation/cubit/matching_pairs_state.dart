import 'package:equatable/equatable.dart';
import 'package:flutter_task_app/data/models/matching_pairs_question_model.dart'; // Import the model

abstract class MatchingPairsState extends Equatable {
  const MatchingPairsState();

  @override
  List<Object?> get props => [];
}

class MatchingPairsInitial extends MatchingPairsState {}

class MatchingPairsLoading extends MatchingPairsState {}

class MatchingPairsLoaded extends MatchingPairsState {
  final MatchingPairsQuestionModel question; // Hold the current question
  // Add state for user connections, e.g., Map<String, String?> userConnections
  final Map<String, String?> userConnections; // Key: questionId, Value: answerId or null
  final bool? showResult; // Null initially, true after submission
  final bool? isCorrect; // Null initially, true/false after checking result

  const MatchingPairsLoaded({
    required this.question,
    required this.userConnections,
    this.showResult,
    this.isCorrect,
  });

  @override
  List<Object?> get props => [question, userConnections, showResult, isCorrect];

  // Helper to update state with new connections or results
  MatchingPairsLoaded copyWith({
    MatchingPairsQuestionModel? question,
    Map<String, String?>? userConnections,
    bool? showResult,
    bool? isCorrect,
    bool clearResult = false, // Flag to explicitly clear result state
  }) {
    return MatchingPairsLoaded(
      question: question ?? this.question,
      userConnections: userConnections ?? this.userConnections,
      showResult: clearResult ? null : (showResult ?? this.showResult),
      isCorrect: clearResult ? null : (isCorrect ?? this.isCorrect),
    );
  }
}

class MatchingPairsError extends MatchingPairsState {
  final String message;

  const MatchingPairsError(this.message);

  @override
  List<Object?> get props => [message];
}

