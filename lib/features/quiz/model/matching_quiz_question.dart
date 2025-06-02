
import 'package:flutter_task_app/features/quiz/model/question_model.dart';

class MatchingQuestion extends QuestionModel {
  final List<String> leftItems;
  final List<String> rightItems;
  final Map<String, String> correctMatches;

  const MatchingQuestion({
    required super.id,
    required super.text,
    required super.order,
    required super.timeLimit,
    required this.leftItems,
    required this.rightItems,
    required this.correctMatches,
  }) : super(type: 'matching');

  factory MatchingQuestion.fromFirestore(Map<String, dynamic> data) {
    return MatchingQuestion(
      id: data['id'] ?? '',
      text: data['text'] ?? '',
      order: data['order'] ?? 0,
      timeLimit: data['timeLimit'] ?? 45,
      leftItems: List<String>.from(data['leftItems'] ?? []),
      rightItems: List<String>.from(data['rightItems'] ?? []),
      correctMatches: Map<String, String>.from(data['correctMatches'] ?? {}),
    );
  }

  @override
  List<Object?> get props => [...super.props, leftItems, rightItems, correctMatches];
}