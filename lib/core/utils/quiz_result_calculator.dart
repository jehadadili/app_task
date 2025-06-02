import 'package:flutter_task_app/features/quiz/model/quiz_answer.dart';
import 'package:flutter_task_app/features/quiz/model/quiz_result_model.dart';

class QuizResultCalculator {
  QuizResultModel calculateResult(List<AnswerModel> answers, int totalQuestions) {
    final totalScore = answers.where((a) => a.isCorrect).length;
    final totalTimeTaken = answers.fold<int>(0, (sum, a) => sum + a.timeTaken);
    final percentage = totalQuestions > 0 ? (totalScore / totalQuestions) * 100 : 0.0;

    return QuizResultModel(
      answers: answers,
      totalScore: totalScore,
      totalQuestions: totalQuestions,
      totalTimeTaken: totalTimeTaken,
      percentage: percentage,
    );
  }
}