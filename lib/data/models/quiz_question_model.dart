import 'package:flutter/material.dart'; // Required for UniqueKey
import 'package:flutter_task_app/data/models/drag_drop_question_model.dart'; // For ExerciseType enum
import 'package:flutter_task_app/data/models/matching_pairs_question_model.dart'; // For MatchingPairItem

// Base class or interface for Quiz Questions
abstract class QuizQuestionModel {
  final String id;
  final ExerciseType type;
  final String questionText; // Common field for question text/prompt
  final int timeLimitSeconds; // Timer per question

  QuizQuestionModel({
    required this.id,
    required this.type,
    required this.questionText,
    required this.timeLimitSeconds,
  });

  factory QuizQuestionModel.fromMap(Map<String, dynamic> map, String documentId) {
    final typeString = map['type'] as String?;
    final type = ExerciseType.values.firstWhere(
      (e) => e.name == typeString,
      orElse: () => ExerciseType.multipleChoice, // Default or throw error
    );
    final questionText = map['questionText'] as String? ?? '';
    final timeLimit = map['timeLimitSeconds'] as int? ?? 30; // Default time limit

    switch (type) {
      case ExerciseType.multipleChoice:
        return MultipleChoiceQuestionModel.fromMap(map, documentId);
      case ExerciseType.dragAndDrop:
         return DragDropQuizQuestionModel.fromMap(map, documentId); // Use specific quiz version
      case ExerciseType.matchingPairs:
         return MatchingPairsQuizQuestionModel.fromMap(map, documentId); // Use specific quiz version
      default:
        // Fallback or error handling
        throw UnimplementedError('Unsupported quiz question type: $type');
    }
  }

  Map<String, dynamic> toMap();
}

// Multiple Choice Question Model
class MultipleChoiceQuestionModel extends QuizQuestionModel {
  final List<String> options;
  final String correctAnswer; // Could be index or value

  MultipleChoiceQuestionModel({
    required String id,
    required String questionText,
    required this.options,
    required this.correctAnswer,
    required int timeLimitSeconds,
  }) : super(
          id: id,
          type: ExerciseType.multipleChoice,
          questionText: questionText,
          timeLimitSeconds: timeLimitSeconds,
        );

  factory MultipleChoiceQuestionModel.fromMap(Map<String, dynamic> map, String documentId) {
    return MultipleChoiceQuestionModel(
      id: documentId,
      questionText: map['questionText'] as String? ?? '',
      options: List<String>.from(map['options'] as List<dynamic>? ?? []),
      correctAnswer: map['correctAnswer'] as String? ?? '',
      timeLimitSeconds: map['timeLimitSeconds'] as int? ?? 30,
    );
  }

  @override
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'type': type.name,
      'questionText': questionText,
      'options': options,
      'correctAnswer': correctAnswer,
      'timeLimitSeconds': timeLimitSeconds,
    };
  }
}


// Specific DragDrop model for Quiz
class DragDropQuizQuestionModel extends QuizQuestionModel {
  final String sentenceTemplate;
  final List<String> draggableOptions;
  final String correctAnswer;

   DragDropQuizQuestionModel({
    required String id,
    required String questionText, // General question prompt
    required this.sentenceTemplate,
    required this.draggableOptions,
    required this.correctAnswer,
    required int timeLimitSeconds,
  }) : super(
          id: id,
          type: ExerciseType.dragAndDrop,
          questionText: questionText, // Use the common field
          timeLimitSeconds: timeLimitSeconds,
        );

  factory DragDropQuizQuestionModel.fromMap(Map<String, dynamic> map, String documentId) {
     return DragDropQuizQuestionModel(
      id: documentId,
      questionText: map['questionText'] as String? ?? '', // General prompt
      sentenceTemplate: map['sentenceTemplate'] as String? ?? '',
      draggableOptions: List<String>.from(map['draggableOptions'] as List<dynamic>? ?? []),
      correctAnswer: map['correctAnswer'] as String? ?? '',
      timeLimitSeconds: map['timeLimitSeconds'] as int? ?? 60, // Different default?
    );
  }

   @override
  Map<String, dynamic> toMap() {
     return {
      'id': id,
      'type': type.name,
      'questionText': questionText,
      'sentenceTemplate': sentenceTemplate,
      'draggableOptions': draggableOptions,
      'correctAnswer': correctAnswer,
      'timeLimitSeconds': timeLimitSeconds,
    };
  }
}

// Specific Matching Pairs model for Quiz
class MatchingPairsQuizQuestionModel extends QuizQuestionModel {
    final List<MatchingPairItem> questions;
    final List<MatchingPairItem> answers;
    final Map<String, String> correctMatches;

    MatchingPairsQuizQuestionModel({
      required String id,
      required String questionText, // General question prompt
      required this.questions,
      required this.answers,
      required this.correctMatches,
      required int timeLimitSeconds,
    }) : super(
            id: id,
            type: ExerciseType.matchingPairs,
            questionText: questionText, // Use the common field
            timeLimitSeconds: timeLimitSeconds,
          );

    factory MatchingPairsQuizQuestionModel.fromMap(Map<String, dynamic> map, String documentId) {
      return MatchingPairsQuizQuestionModel(
        id: documentId,
        questionText: map['questionText'] as String? ?? '', // General prompt
        questions: (map['questions'] as List<dynamic>? ?? [])
            .map((item) => MatchingPairItem.fromMap(item as Map<String, dynamic>, item['id'] as String? ?? UniqueKey().toString()))
            .toList(),
        answers: (map['answers'] as List<dynamic>? ?? [])
            .map((item) => MatchingPairItem.fromMap(item as Map<String, dynamic>, item['id'] as String? ?? UniqueKey().toString()))
            .toList(),
        correctMatches: Map<String, String>.from(map['correctMatches'] as Map<dynamic, dynamic>? ?? {}),
        timeLimitSeconds: map['timeLimitSeconds'] as int? ?? 90, // Different default?
      );
    }

    @override
    Map<String, dynamic> toMap() {
      return {
        'id': id,
        'type': type.name,
        'questionText': questionText,
        'questions': questions.map((item) => item.toMap()..['id'] = item.id).toList(),
        'answers': answers.map((item) => item.toMap()..['id'] = item.id).toList(),
        'correctMatches': correctMatches,
        'timeLimitSeconds': timeLimitSeconds,
      };
    }
}

