
import 'package:flutter_task_app/features/quiz/model/question.dart';

class DragDropQuizQuestion extends Question {
  final String sentenceTemplate; 
  final List<String> draggableOptions;
  final String correctAnswer;

  DragDropQuizQuestion({
    required super.id,
    required this.sentenceTemplate,
    required this.draggableOptions,
    required this.correctAnswer,
    required super.timeLimitSeconds,
  }) : super(
            type: "drag_drop",
            questionText: sentenceTemplate);

   factory DragDropQuizQuestion.fromFirestore(Map<String, dynamic> data, String id) {
    return DragDropQuizQuestion(
      id: id,
      sentenceTemplate: data["sentenceTemplate"] ?? "_____",
      draggableOptions: List<String>.from(data["draggableOptions"] ?? []),
      correctAnswer: data["correctAnswer"] ?? "",
      timeLimitSeconds: data["timeLimitSeconds"] ?? 90, // Default 90 seconds
    );
  }
}
