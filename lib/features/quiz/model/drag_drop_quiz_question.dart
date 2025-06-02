import 'dart:developer';

import 'package:flutter_task_app/features/quiz/model/question_model.dart';

class FillBlankDragDropQuestion extends QuestionModel {
  final List<String> options;
  final String correctAnswer;

  const FillBlankDragDropQuestion({
    required super.id,
    required super.text,
    required super.order,
    required super.timeLimit,
    required this.options,
    required this.correctAnswer,
  }) : super(type: 'drag_drop');

  factory FillBlankDragDropQuestion.fromFirestore(Map<String, dynamic> data) {
    if (data['options'] == null || data['correctAnswer'] == null) {
      log("Error: Missing 'options' or 'correctAnswer' for drag_drop question ID: ${data['id']}");
      return FillBlankDragDropQuestion(
        id: data['id'] ?? 'unknown_id',
        text: data['text'] ?? 'Error: Invalid question format',
        order: data['order'] ?? 0,
        timeLimit: data['timeLimit'] ?? 30,
        options: [],
        correctAnswer: '',
      );
    }

    return FillBlankDragDropQuestion(
      id: data['id'] ?? '',
      text: data['text'] ?? '',
      order: data['order'] ?? 0,
      timeLimit: data['timeLimit'] ?? 30, 
      options: List<String>.from(data['options'] ?? []),
      correctAnswer: data['correctAnswer'] ?? '',
    );
  }

  @override
  List<Object?> get props => [...super.props, options, correctAnswer];
}

