import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_task_app/features/quiz/model/question_model.dart';

class QuizDataService {
  final FirebaseFirestore _firestore;

  QuizDataService({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  Future<List<QuestionModel>> loadQuizQuestions() async {
    log("QuizDataService: Loading quiz questions...");

    final snapshot = await _firestore
        .collection('quizzes')
        .doc('quiz_001')
        .collection('questions')
        .orderBy('order')
        .get();

    if (snapshot.docs.isEmpty) {
      log("QuizDataService: No questions found in Firestore.");
      throw Exception('No questions found');
    }

    final List<QuestionModel> questions = [];
    
    for (var doc in snapshot.docs) {
      try {
        questions.add(QuestionModel.fromFirestore(doc.data()));
      } catch (e) {
        log("QuizDataService: Error parsing question ${doc.id}: $e. Skipping this question.");
      }
    }

    if (questions.isEmpty) {
      log("QuizDataService: All questions failed to parse.");
      throw Exception('Failed to load any questions due to format errors.');
    }

    log("QuizDataService: Loaded ${questions.length} questions successfully.");
    return questions;
  }
}