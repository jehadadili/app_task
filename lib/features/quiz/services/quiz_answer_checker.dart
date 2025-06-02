import 'dart:developer';
import 'package:flutter_task_app/features/quiz/model/drag_drop_quiz_question.dart';
import 'package:flutter_task_app/features/quiz/model/matching_quiz_question.dart';
import 'package:flutter_task_app/features/quiz/model/multiple_choice_question.dart';
import 'package:flutter_task_app/features/quiz/model/question_model.dart';

class QuizAnswerChecker {
  bool checkAnswer(QuestionModel question, dynamic answer) {
    log("QuizAnswerChecker: Checking answer for question type: ${question.type}");
    
    switch (question.type) {
      case 'multiple_choice':
        return _checkMultipleChoiceAnswer(question, answer);
      case 'drag_drop':
        return _checkDragDropAnswer(question, answer);
      case 'matching':
        return _checkMatchingAnswer(question, answer);
      default:
        log("Error: Unknown question type: ${question.type}");
        return false;
    }
  }

  bool _checkMultipleChoiceAnswer(QuestionModel question, dynamic answer) {
    if (question is MultipleChoiceQuestion) {
      log("Comparing MCQ answer: ${question.correctAnswer} == $answer");
      return question.correctAnswer == answer;
    } else {
      log("Error: Question type is multiple_choice but model is not MultipleChoiceQuestion");
      return false;
    }
  }

  bool _checkDragDropAnswer(QuestionModel question, dynamic answer) {
    if (question is FillBlankDragDropQuestion) {
      if (answer is String?) {
        log("Comparing FillBlank answer: ${question.correctAnswer} == $answer");
        return answer != null && question.correctAnswer == answer;
      } else {
        log("Error: Answer type for FillBlankDragDropQuestion is not String? Type: ${answer.runtimeType}");
        return false;
      }
    } else {
      log("Warning: Question type is drag_drop but model is not FillBlankDragDropQuestion. Model type: ${question.runtimeType}");
      return false;
    }
  }

  bool _checkMatchingAnswer(QuestionModel question, dynamic answer) {
    if (question is MatchingQuestion) {
      if (answer is Map<String, String>) {
        log("Comparing Matching answer (Map comparison)");
        
        if (answer.length != question.correctMatches.length) {
          log("Matching check failed: Incorrect number of pairs submitted.");
          return false;
        }
        
        return _mapsEqual(question.correctMatches, answer);
      } else {
        log("Error: Answer type for MatchingQuestion is not Map<String, String>. Type: ${answer.runtimeType}");
        return false;
      }
    } else {
      log("Error: Question type is matching but model is not MatchingQuestion");
      return false;
    }
  }

  bool _mapsEqual(Map<String, String> map1, Map<String, String> map2) {
    if (map1.length != map2.length) return false;
    
    for (final key in map1.keys) {
      if (!map2.containsKey(key) || map1[key] != map2[key]) {
        return false;
      }
    }
    return true;
  }
}