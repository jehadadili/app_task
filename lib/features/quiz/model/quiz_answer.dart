class QuizAnswer {
  final String questionId;
  final dynamic answer; 
  final bool isCorrect;
  final int timeTakenSeconds;

  QuizAnswer({
    required this.questionId,
    required this.answer,
    required this.isCorrect,
    required this.timeTakenSeconds,
  });
}