
import 'package:equatable/equatable.dart';
import 'package:flutter_task_app/features/quiz/model/drag_drop_quiz_question.dart';
import 'package:flutter_task_app/features/quiz/model/matching_quiz_question.dart';
import 'package:flutter_task_app/features/quiz/model/multiple_choice_question.dart';

abstract class QuestionModel extends Equatable {
  final String id;
  final String text;
  final int order;
  final String type;
  final int timeLimit; 

  const QuestionModel({
    required this.id,
    required this.text,
    required this.order,
    required this.type,
    required this.timeLimit,
  });

  factory QuestionModel.fromFirestore(Map<String, dynamic> data) {
    switch (data['type']) {
      case 'multiple_choice':
        return MultipleChoiceQuestion.fromFirestore(data);
      case 'drag_drop':
        return FillBlankDragDropQuestion.fromFirestore(data);
      case 'matching':
        return MatchingQuestion.fromFirestore(data);
      default:
        throw Exception('Unknown question type: ${data['type']}');
    }
  }

  @override
  List<Object?> get props => [id, text, order, type, timeLimit];
}