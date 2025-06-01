
import 'package:flutter_task_app/features/quiz/model/matching_quiz_item.dart';
import 'package:flutter_task_app/features/quiz/model/question.dart';

class MatchingQuizQuestion extends Question {
  final List<MatchingQuizItem> leftItems;
  final List<MatchingQuizItem> rightItems;
  final Map<String, String> correctPairs;

  MatchingQuizQuestion({
    required super.id,
    required super.questionText, 
    required this.leftItems,
    required this.rightItems,
    required this.correctPairs,
    required super.timeLimitSeconds,
  }) : super(
            type: "matching");

  factory MatchingQuizQuestion.fromFirestore(Map<String, dynamic> data, String id) {
     List<MatchingQuizItem> parseItems(List<dynamic>? itemList) {
        if (itemList == null) return [];
        return itemList.map((item) => MatchingQuizItem.fromMap(Map<String, dynamic>.from(item))).toList();
     }

    return MatchingQuizQuestion(
      id: id,
      questionText: data["questionText"] ?? "Match the pairs",
      leftItems: parseItems(data["leftItems"]),
      rightItems: parseItems(data["rightItems"]),
      correctPairs: Map<String, String>.from(data["correctPairs"] ?? {}),
      timeLimitSeconds: data["timeLimitSeconds"] ?? 120, 
    );
  }
}