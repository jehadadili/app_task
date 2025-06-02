

import 'package:flutter_task_app/features/quiz/model/question_model.dart';

class DragDropQuestion extends QuestionModel {
  final List<String> leftItems;
  final List<String> rightItems;
  final Map<String, String> correctPairs;

  const DragDropQuestion({
    required super.id,
    required super.text,
    required super.order,
    required super.timeLimit,
    required this.leftItems,
    required this.rightItems,
    required this.correctPairs,
  }) : super(type: 'drag_drop');

  factory DragDropQuestion.fromFirestore(Map<String, dynamic> data) {
    return DragDropQuestion(
      id: data['id'] ?? '',
      text: data['text'] ?? '',
      order: data['order'] ?? 0,
      timeLimit: data['timeLimit'] ?? 60,
      leftItems: List<String>.from(data['leftItems'] ?? []),
      rightItems: List<String>.from(data['rightItems'] ?? []),
      correctPairs: Map<String, String>.from(data['correctPairs'] ?? {}),
    );
  }

  @override
  List<Object?> get props => [...super.props, leftItems, rightItems, correctPairs];
}