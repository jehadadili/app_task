import 'package:equatable/equatable.dart';
import 'package:flutter_task_app/data/models/quiz_question_model.dart'; // Import the base model

abstract class QuizState extends Equatable {
  const QuizState();

  @override
  List<Object?> get props => [];
}

class QuizInitial extends QuizState {}

class QuizLoading extends QuizState {}

class QuizLoaded extends QuizState {
  final List<QuizQuestionModel> allQuestions;
  final int currentQuestionIndex;
  final Map<String, dynamic> userAnswers; // Store user answers (flexible structure)
  final Map<String, int> timeTakenPerQuestion; // Store time taken in seconds
  final bool quizCompleted;
  final int? finalScore; // Null until quiz is completed

  const QuizLoaded({
    required this.allQuestions,
    this.currentQuestionIndex = 0,
    this.userAnswers = const {},
    this.timeTakenPerQuestion = const {},
    this.quizCompleted = false,
    this.finalScore,
  });

  // Helper to get the current question
  QuizQuestionModel get currentQuestion => allQuestions[currentQuestionIndex];

  @override
  List<Object?> get props => [
        allQuestions,
        currentQuestionIndex,
        userAnswers,
        timeTakenPerQuestion,
        quizCompleted,
        finalScore,
      ];

  // Helper to update state
  QuizLoaded copyWith({
    List<QuizQuestionModel>? allQuestions,
    int? currentQuestionIndex,
    Map<String, dynamic>? userAnswers,
    Map<String, int>? timeTakenPerQuestion,
    bool? quizCompleted,
    int? finalScore,
    bool clearScore = false, // Flag to explicitly clear score
  }) {
    return QuizLoaded(
      allQuestions: allQuestions ?? this.allQuestions,
      currentQuestionIndex: currentQuestionIndex ?? this.currentQuestionIndex,
      userAnswers: userAnswers ?? this.userAnswers,
      timeTakenPerQuestion: timeTakenPerQuestion ?? this.timeTakenPerQuestion,
      quizCompleted: quizCompleted ?? this.quizCompleted,
      finalScore: clearScore ? null : (finalScore ?? this.finalScore),
    );
  }
}

// State for showing the final result summary
class QuizResultState extends QuizState {
  final int score;
  final int totalQuestions;
  final Map<String, int> timeTakenPerQuestion;
  // Add more details if needed, like list of correct/incorrect answers

  const QuizResultState({
    required this.score,
    required this.totalQuestions,
    required this.timeTakenPerQuestion,
  });

  @override
  List<Object?> get props => [score, totalQuestions, timeTakenPerQuestion];
}

class QuizError extends QuizState {
  final String message;

  const QuizError(this.message);

  @override
  List<Object?> get props => [message];
}

