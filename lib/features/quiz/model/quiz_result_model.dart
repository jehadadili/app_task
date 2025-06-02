

import 'package:equatable/equatable.dart';
import 'package:flutter_task_app/features/quiz/model/quiz_answer.dart';

class QuizResultModel extends Equatable {
  final List<AnswerModel> answers;
  final int totalScore;
  final int totalQuestions;
  final int totalTimeTaken;
  final double percentage;

  const QuizResultModel({
    required this.answers,
    required this.totalScore,
    required this.totalQuestions,
    required this.totalTimeTaken,
    required this.percentage,
  });

  @override
  List<Object?> get props => [answers, totalScore, totalQuestions, totalTimeTaken, percentage];
}