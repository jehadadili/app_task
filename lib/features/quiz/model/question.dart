import 'dart:developer';

import 'package:flutter_task_app/features/quiz/model/drag_drop_quiz_question.dart';
import 'package:flutter_task_app/features/quiz/model/matching_quiz_question.dart';
import 'package:flutter_task_app/features/quiz/model/multiple_choice_question.dart';

abstract class Question {
  final String id;
  final String type; 
  final String questionText;
  final int timeLimitSeconds; 

  Question({
    required this.id,
    required this.type,
    required this.questionText,
    required this.timeLimitSeconds,
  });

  factory Question.fromFirestore(Map<String, dynamic> data, String id) {
    String type = data["type"] ?? "unknown";
    switch (type) {
      case "multiple_choice":
        return MultipleChoiceQuestion.fromFirestore(data, id);
      case "drag_drop":
        return DragDropQuizQuestion.fromFirestore(data, id);
      case "matching":
        return MatchingQuizQuestion.fromFirestore(data, id);
      default:
        log("Warning: Unknown question type 	'$type' for ID $id");
        return MultipleChoiceQuestion( 
            id: id,
            questionText: data["questionText"] ?? "Invalid Question",
            options: [],
            correctAnswerIndex: -1,
            timeLimitSeconds: data["timeLimitSeconds"] ?? 60,
         );
    }
  }
}
