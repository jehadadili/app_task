import 'package:flutter_task_app/features/quiz/model/question_model.dart';

class MultipleChoiceQuestion extends QuestionModel {
  final List<String> options;
  final String correctAnswer;

  const MultipleChoiceQuestion({
    required super.id,
    required super.text,
    required super.order,
    required super.timeLimit,
    required this.options,
    required this.correctAnswer,
  }) : super(type: 'multiple_choice');

  factory MultipleChoiceQuestion.fromFirestore(Map<String, dynamic> data) {
    return MultipleChoiceQuestion(
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