import 'package:flutter/material.dart';
import 'package:flutter_task_app/data/models/drag_drop_question_model.dart'; // For ExerciseType enum

class MatchingPairItem {
  final String id; // Unique ID for the item
  final String text;

  MatchingPairItem({required this.id, required this.text});

  // Factory constructor from map (e.g., Firestore sub-collection item)
  factory MatchingPairItem.fromMap(Map<String, dynamic> map, String id) {
    return MatchingPairItem(
      id: id,
      text: map['text'] as String? ?? '',
    );
  }

  // Method to convert to map (if needed)
  Map<String, dynamic> toMap() {
    return {
      'text': text,
    };
  }
}

class MatchingPairsQuestionModel {
  final String id;
  final List<MatchingPairItem> questions; // Left side list
  final List<MatchingPairItem> answers;   // Right side list
  // Map representing correct connections, e.g., {questionId: answerId}
  final Map<String, String> correctMatches;
  final ExerciseType type = ExerciseType.matchingPairs;

  MatchingPairsQuestionModel({
    required this.id,
    required this.questions,
    required this.answers,
    required this.correctMatches,
  });

  // Factory constructor from Firestore data (example)
  factory MatchingPairsQuestionModel.fromMap(Map<String, dynamic> map, String documentId) {
    // Assuming questions and answers are stored as lists of maps or sub-collections
    // And correctMatches is stored as a map
    return MatchingPairsQuestionModel(
      id: documentId,
      questions: (map['questions'] as List<dynamic>? ?? [])
          .map((item) => MatchingPairItem.fromMap(item as Map<String, dynamic>, item['id'] as String? ?? UniqueKey().toString()))
          .toList(),
      answers: (map['answers'] as List<dynamic>? ?? [])
          .map((item) => MatchingPairItem.fromMap(item as Map<String, dynamic>, item['id'] as String? ?? UniqueKey().toString()))
          .toList(),
      correctMatches: Map<String, String>.from(map['correctMatches'] as Map<dynamic, dynamic>? ?? {}),
    );
  }

  // Method to convert to map for Firestore (if needed)
  Map<String, dynamic> toMap() {
    return {
      'questions': questions.map((item) => item.toMap()..['id'] = item.id).toList(),
      'answers': answers.map((item) => item.toMap()..['id'] = item.id).toList(),
      'correctMatches': correctMatches,
      'type': type.name,
    };
  }
}

