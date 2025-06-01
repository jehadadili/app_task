
import 'package:flutter_task_app/features/quiz/model/question.dart';

class MultipleChoiceQuestion extends Question {
  final List<String> options;
  final int correctAnswerIndex; // Index of the correct option

  MultipleChoiceQuestion({
    required super.id,
    required super.questionText,
    required this.options,
    required this.correctAnswerIndex,
    required super.timeLimitSeconds,
  }) : super(
            type: "multiple_choice");

  factory MultipleChoiceQuestion.fromFirestore(Map<String, dynamic> data, String id) {
    return MultipleChoiceQuestion(
      id: id,
      questionText: data["questionText"] ?? "Missing question text",
      options: List<String>.from(data["options"] ?? []),
      correctAnswerIndex: data["correctAnswerIndex"] ?? -1,
      timeLimitSeconds: data["timeLimitSeconds"] ?? 60, 
    );
  }
}