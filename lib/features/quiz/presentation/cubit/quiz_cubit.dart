import 'dart:async';
import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_task_app/data/models/drag_drop_question_model.dart';
import 'package:flutter_task_app/data/models/quiz_question_model.dart';
import 'package:flutter_task_app/features/quiz/presentation/cubit/quiz_state.dart';

class QuizCubit extends Cubit<QuizState> {
  QuizCubit() : super(QuizInitial()) {
    // Load questions when the cubit is created
    loadQuizQuestions();
  }

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  Timer? _questionTimer;
  int _currentTime = 0;

  // Assuming questions are stored in a 'quiz_questions' collection
  Future<void> loadQuizQuestions() async {
    emit(QuizLoading());
    try {
      log("QuizCubit: Loading quiz questions...");
      QuerySnapshot querySnapshot = await _firestore.collection('quiz_questions').get(); // Fetch all questions

      if (querySnapshot.docs.isEmpty) {
        throw Exception('No Quiz questions found in Firestore.');
      }

      List<QuizQuestionModel> questions = querySnapshot.docs.map((doc) {
        return QuizQuestionModel.fromMap(doc.data() as Map<String, dynamic>, doc.id);
      }).toList();

      // Optionally shuffle questions
      // questions.shuffle();

      log("QuizCubit: Loaded ${questions.length} quiz questions successfully.");
      emit(QuizLoaded(allQuestions: questions));
      _startQuestionTimer(); // Start timer for the first question

    } catch (e, stackTrace) {
      log('QuizCubit: Error loading quiz questions: $e', error: e, stackTrace: stackTrace);
      emit(QuizError('Failed to load quiz: ${e.toString()}'));
    }
  }

  void _startQuestionTimer() {
    _questionTimer?.cancel(); // Cancel any existing timer
    if (state is QuizLoaded) {
      final currentState = state as QuizLoaded;
      _currentTime = currentState.currentQuestion.timeLimitSeconds;
      log("QuizCubit: Starting timer for question ${currentState.currentQuestionIndex + 1} (${_currentTime}s)");

      _questionTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
        if (_currentTime > 0) {
          _currentTime--;
          // Optionally emit state updates for timer UI
          // emit(currentState.copyWith(...)); // Be careful with frequent updates
        } else {
          log("QuizCubit: Time up for question ${currentState.currentQuestionIndex + 1}");
          timer.cancel();
          // Automatically move to the next question or handle timeout
          // For simplicity, let's assume moving next is handled by UI or answer submission
          // recordAnswer(null, 0); // Record timeout as incorrect/skipped
        }
      });
    }
  }

  void recordAnswer(dynamic answer, {bool fromTimeout = false}) {
    if (state is QuizLoaded) {
      final currentState = state as QuizLoaded;
      _questionTimer?.cancel(); // Stop timer for the current question

      final questionId = currentState.currentQuestion.id;
      final timeTaken = fromTimeout ? currentState.currentQuestion.timeLimitSeconds : currentState.currentQuestion.timeLimitSeconds - _currentTime;

      log("QuizCubit: Recording answer for question $questionId. Answer: $answer, Time taken: ${timeTaken}s");

      final updatedAnswers = Map<String, dynamic>.from(currentState.userAnswers);
      updatedAnswers[questionId] = answer; // Store the actual answer provided by the user

      final updatedTimeTaken = Map<String, int>.from(currentState.timeTakenPerQuestion);
      updatedTimeTaken[questionId] = timeTaken;

      emit(currentState.copyWith(
        userAnswers: updatedAnswers,
        timeTakenPerQuestion: updatedTimeTaken,
      ));

      // Don't move to next question here, let UI trigger it
    } else {
      log("QuizCubit: Cannot record answer when quiz is not loaded.");
    }
  }

  void nextQuestion() {
    if (state is QuizLoaded) {
      final currentState = state as QuizLoaded;
      if (currentState.currentQuestionIndex < currentState.allQuestions.length - 1) {
        log("QuizCubit: Moving to next question (${currentState.currentQuestionIndex + 2})");
        emit(currentState.copyWith(currentQuestionIndex: currentState.currentQuestionIndex + 1));
        _startQuestionTimer(); // Start timer for the new question
      } else {
        log("QuizCubit: Reached end of quiz. Calculating results...");
        // Last question answered, calculate results
        _calculateResults();
      }
    } else {
      log("QuizCubit: Cannot move to next question when quiz is not loaded.");
    }
  }

  void _calculateResults() {
    if (state is QuizLoaded) {
      final currentState = state as QuizLoaded;
      int score = 0;

      currentState.allQuestions.asMap().forEach((index, question) {
        final userAnswer = currentState.userAnswers[question.id];
        bool isCorrect = false;

        // --- Answer Checking Logic (Needs to be specific per question type) ---
        switch (question.type) {
          case ExerciseType.multipleChoice:
            if (question is MultipleChoiceQuestionModel) {
              isCorrect = userAnswer == question.correctAnswer;
            }
            break;
          case ExerciseType.dragAndDrop:
             if (question is DragDropQuizQuestionModel) {
               // Assuming userAnswer is the dropped string
               isCorrect = userAnswer?.toString().trim().toLowerCase() == question.correctAnswer.trim().toLowerCase();
             }
            break;
          case ExerciseType.matchingPairs:
             if (question is MatchingPairsQuizQuestionModel) {
                // Assuming userAnswer is Map<String, String?> representing connections
                if (userAnswer is Map<String, String?>) {
                    bool allMatch = true;
                    question.correctMatches.forEach((qId, correctAId) {
                       if (userAnswer[qId] != correctAId) {
                          allMatch = false;
                       }
                    });
                    // Check if all required connections were made
                    if (userAnswer.length != question.correctMatches.length) {
                       allMatch = false;
                    }
                    isCorrect = allMatch;
                } else {
                   isCorrect = false; // Invalid answer format
                }
             }
            break;
        }
        // --- End Answer Checking Logic ---

        if (isCorrect) {
          score++;
        }
        log("QuizCubit: Q${index + 1} (${question.type.name}) - User Answer: $userAnswer - Correct: $isCorrect");
      });

      log("QuizCubit: Quiz finished. Final Score: $score / ${currentState.allQuestions.length}");
      emit(currentState.copyWith(quizCompleted: true, finalScore: score));

      // Optionally, emit a dedicated result state after a delay or user action
      // emit(QuizResultState(
      //   score: score,
      //   totalQuestions: currentState.allQuestions.length,
      //   timeTakenPerQuestion: currentState.timeTakenPerQuestion,
      // ));

    } else {
      log("QuizCubit: Cannot calculate results when quiz is not loaded.");
    }
  }

  @override
  Future<void> close() {
    _questionTimer?.cancel();
    return super.close();
  }
}

