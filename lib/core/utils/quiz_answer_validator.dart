import 'dart:developer';
import 'package:flutter_task_app/features/quiz/model/matching_quiz_question.dart';
import 'package:flutter_task_app/features/quiz/model/question_model.dart';

class QuizAnswerValidator {
  bool shouldProcessAnswer(QuestionModel question, dynamic answer) {
    if (question is MatchingQuestion) {
      return _validateMatchingAnswer(question, answer);
    }
    
    return true;
  }

  bool _validateMatchingAnswer(MatchingQuestion question, dynamic answer) {
    if (answer is Map<String, String>) {
      if (answer.length == question.leftItems.length) {
        log("QuizAnswerValidator: All pairs matched for MatchingQuestion. Ready to process.");
        return true;
      } else {
        log("QuizAnswerValidator: MatchingQuestion - Not all pairs matched yet (${answer.length}/${question.leftItems.length}). Waiting...");
        return false;
      }
    } else {
      log("QuizAnswerValidator: Error - Expected Map<String, String> for MatchingQuestion answer, got ${answer.runtimeType}");
      return false;
    }
  }
}