
abstract class QuizState {}

class QuizInitial extends QuizState {}

class QuizLoading extends QuizState {}

class QuizLoaded extends QuizState {
  final List<dynamic> questions; 
  final int currentQuestionIndex;
  

  QuizLoaded({required this.questions, this.currentQuestionIndex = 0});

 
}

class QuizFinished extends QuizState {
  final int score;
  final int totalQuestions;
  final Duration timeTaken;

  QuizFinished({
    required this.score,
    required this.totalQuestions,
    required this.timeTaken,
  });
}

class QuizError extends QuizState {
  final String message;

  QuizError(this.message);
}

