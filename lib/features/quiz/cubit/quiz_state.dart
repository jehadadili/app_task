
import 'package:flutter_task_app/features/quiz/model/question.dart';
import 'package:flutter_task_app/features/quiz/model/quiz_answer.dart';



abstract class QuizState {}

class QuizInitial extends QuizState {}

class QuizLoading extends QuizState {}

class QuizError extends QuizState {
  final String message;
  QuizError(this.message);
}

class QuizInProgress extends QuizState {
  final List<Question> questions;
  final int currentQuestionIndex;
  final Map<String, QuizAnswer> userAnswers; 
  final int remainingTimeSeconds; 
  final bool answerSubmitted; 

  QuizInProgress({
    required this.questions,
    required this.currentQuestionIndex,
    required this.userAnswers,
    required this.remainingTimeSeconds,
    this.answerSubmitted = false,
  });

  Question get currentQuestion => questions[currentQuestionIndex];
  double get progress => (currentQuestionIndex + 1) / questions.length;
}

class QuizFinished extends QuizState {
  final List<Question> questions;
  final Map<String, QuizAnswer> userAnswers;
  final int finalScore;
  final int totalQuestions;

  QuizFinished({
    required this.questions,
    required this.userAnswers,
    required this.finalScore,
    required this.totalQuestions,
  });
}
