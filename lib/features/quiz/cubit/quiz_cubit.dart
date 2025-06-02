
import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_task_app/features/quiz/cubit/quiz_state.dart';
import 'package:flutter_task_app/features/quiz/model/drag_drop_quiz_question.dart';
import 'package:flutter_task_app/features/quiz/model/matching_quiz_question.dart';
import 'package:flutter_task_app/features/quiz/model/multiple_choice_question.dart';
import 'package:flutter_task_app/features/quiz/model/question_model.dart';
import 'package:flutter_task_app/features/quiz/model/quiz_answer.dart';
import 'package:flutter_task_app/features/quiz/model/quiz_result_model.dart';

class QuizCubit extends Cubit<QuizState> {
  final FirebaseFirestore _firestore;
  Timer? _timer;
  DateTime? _questionStartTime;

  QuizCubit({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance,
        super(QuizInitial());

  Future<void> loadQuiz() async {
    try {
      emit(QuizLoading());
      
      final snapshot = await _firestore
          .collection('quizzes')
          .doc('quiz_001')
          .collection('questions')
          .orderBy('order')
          .get();

      if (snapshot.docs.isEmpty) {
        emit(const QuizError(message: 'No questions found'));
        return;
      }

      final questions = snapshot.docs
          .map((doc) => QuestionModel.fromFirestore(doc.data()))
          .toList();

      emit(QuizLoaded(
        questions: questions,
        currentQuestionIndex: 0,
        answers: [],
        remainingTime: questions.first.timeLimit,
      ));

      _startTimer(questions.first.timeLimit);
      _questionStartTime = DateTime.now();
    } catch (e) {
      emit(QuizError(message: 'Failed to load quiz: $e'));
    }
  }

  void _startTimer(int timeLimit) {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      final currentState = state;
      if (currentState is QuizLoaded) {
        if (currentState.remainingTime <= 1) {
          _timeUp();
        } else {
          emit(currentState.copyWith(remainingTime: currentState.remainingTime - 1));
        }
      }
    });
  }

  void _timeUp() {
    final currentState = state;
    if (currentState is QuizLoaded && !currentState.isQuestionAnswered) {
      final currentQuestion = currentState.questions[currentState.currentQuestionIndex];
      final timeTaken = _calculateTimeTaken(currentQuestion.timeLimit);
      
      final answer = AnswerModel(
        questionId: currentQuestion.id,
        answer: null,
        timeTaken: timeTaken,
        isCorrect: false,
      );

      _processAnswer(answer);
    }
  }

  int _calculateTimeTaken(int timeLimit) {
    if (_questionStartTime == null) return timeLimit;
    return DateTime.now().difference(_questionStartTime!).inSeconds;
  }

  void submitAnswer(dynamic answer) {
    final currentState = state;
    if (currentState is! QuizLoaded || currentState.isQuestionAnswered) return;

    final currentQuestion = currentState.questions[currentState.currentQuestionIndex];
    final timeTaken = _calculateTimeTaken(currentQuestion.timeLimit);
    final isCorrect = _checkAnswer(currentQuestion, answer);

    final answerModel = AnswerModel(
      questionId: currentQuestion.id,
      answer: answer,
      timeTaken: timeTaken,
      isCorrect: isCorrect,
    );

    _processAnswer(answerModel);
  }

  void _processAnswer(AnswerModel answer) {
    final currentState = state as QuizLoaded;
    final updatedAnswers = [...currentState.answers, answer];

    emit(currentState.copyWith(
      answers: updatedAnswers,
      isQuestionAnswered: true,
    ));

    _timer?.cancel();

    // Auto-advance after 2 seconds
    Timer(const Duration(seconds: 2), () {
      nextQuestion();
    });
  }

  bool _checkAnswer(QuestionModel question, dynamic answer) {
    switch (question.type) {
      case 'multiple_choice':
        final mcq = question as MultipleChoiceQuestion;
        return mcq.correctAnswer == answer;
      case 'drag_drop':
        final ddq = question as DragDropQuestion;
        if (answer is Map<String, String>) {
          return _mapsEqual(ddq.correctPairs, answer);
        }
        return false;
      case 'matching':
        final mq = question as MatchingQuestion;
        if (answer is Map<String, String>) {
          return _mapsEqual(mq.correctMatches, answer);
        }
        return false;
      default:
        return false;
    }
  }

  bool _mapsEqual(Map<String, String> map1, Map<String, String> map2) {
    if (map1.length != map2.length) return false;
    for (final key in map1.keys) {
      if (map1[key] != map2[key]) return false;
    }
    return true;
  }

  void nextQuestion() {
    final currentState = state;
    if (currentState is! QuizLoaded) return;

    if (currentState.currentQuestionIndex < currentState.questions.length - 1) {
      final nextIndex = currentState.currentQuestionIndex + 1;
      final nextQuestion = currentState.questions[nextIndex];

      emit(currentState.copyWith(
        currentQuestionIndex: nextIndex,
        remainingTime: nextQuestion.timeLimit,
        isQuestionAnswered: false,
      ));

      _startTimer(nextQuestion.timeLimit);
      _questionStartTime = DateTime.now();
    } else {
      _completeQuiz();
    }
  }

  void _completeQuiz() {
    final currentState = state as QuizLoaded;
    final totalScore = currentState.answers.where((a) => a.isCorrect).length;
    final totalQuestions = currentState.questions.length;
    final totalTimeTaken = currentState.answers.fold<int>(0, (sum, a) => sum + a.timeTaken);
    final percentage = (totalScore / totalQuestions) * 100;

    final result = QuizResultModel(
      answers: currentState.answers,
      totalScore: totalScore,
      totalQuestions: totalQuestions,
      totalTimeTaken: totalTimeTaken,
      percentage: percentage,
    );

    _timer?.cancel();
    emit(QuizCompleted(result: result));
  }

  void restartQuiz() {
    _timer?.cancel();
    _questionStartTime = null;
    emit(QuizInitial());
    loadQuiz();
  }

  @override
  Future<void> close() {
    _timer?.cancel();
    return super.close();
  }
}

