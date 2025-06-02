import 'dart:async';
import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_task_app/core/utils/quiz_answer_validator.dart';
import 'package:flutter_task_app/core/utils/quiz_result_calculator.dart';
import 'package:flutter_task_app/features/quiz/cubit/quiz_state.dart';
import 'package:flutter_task_app/features/quiz/model/quiz_answer.dart';
import 'package:flutter_task_app/features/quiz/services/quiz_answer_checker.dart';
import 'package:flutter_task_app/features/quiz/services/quiz_data_service.dart';
import 'package:flutter_task_app/features/quiz/services/quiz_timer_service.dart';



class QuizCubit extends Cubit<QuizState> {
  final QuizTimerService _timerService;
  final QuizAnswerChecker _answerChecker;
  final QuizDataService _dataService;
  final QuizResultCalculator _resultCalculator;
  final QuizAnswerValidator _answerValidator;

  QuizCubit({
    FirebaseFirestore? firestore,
    QuizTimerService? timerService,
    QuizAnswerChecker? answerChecker,
    QuizDataService? dataService,
    QuizResultCalculator? resultCalculator,
    QuizAnswerValidator? answerValidator,
  })  : _timerService = timerService ?? QuizTimerService(),
        _answerChecker = answerChecker ?? QuizAnswerChecker(),
        _dataService = dataService ?? QuizDataService(firestore: firestore),
        _resultCalculator = resultCalculator ?? QuizResultCalculator(),
        _answerValidator = answerValidator ?? QuizAnswerValidator(),
        super(QuizInitial()) {
    _setupTimerCallbacks();
  }

  void _setupTimerCallbacks() {
    _timerService.onTimeUp = _timeUp;
    _timerService.onTick = (remainingTime) {
      final currentState = state;
      if (currentState is QuizLoaded) {
        emit(currentState.copyWith(remainingTime: remainingTime));
      }
    };
  }

  Future<void> loadQuiz() async {
    try {
      emit(QuizLoading());
      
      final questions = await _dataService.loadQuizQuestions();
      
      emit(QuizLoaded(
        questions: questions,
        currentQuestionIndex: 0,
        answers: [],
        remainingTime: questions.first.timeLimit,
      ));

      _timerService.startTimer(questions.first.timeLimit);
    } catch (e) {
      log("QuizCubit: Failed to load quiz: $e");
      emit(QuizError(message: 'Failed to load quiz: $e'));
    }
  }

  void _timeUp() {
    final currentState = state;
    if (currentState is QuizLoaded && !currentState.isQuestionAnswered) {
      log("QuizCubit: Time up for question ${currentState.currentQuestionIndex}");
      
      final currentQuestion = currentState.questions[currentState.currentQuestionIndex];
      final timeTaken = currentQuestion.timeLimit;

      final answer = AnswerModel(
        questionId: currentQuestion.id,
        answer: null,
        timeTaken: timeTaken,
        isCorrect: false,
      );

      _processAnswer(answer);
    }
  }

  void submitAnswer(dynamic answer) {
    final currentState = state;
    if (currentState is! QuizLoaded || currentState.isQuestionAnswered) return;

    log("QuizCubit: Submitting answer for question ${currentState.currentQuestionIndex}. Answer: $answer");
    
    final currentQuestion = currentState.questions[currentState.currentQuestionIndex];
    
    if (!_answerValidator.shouldProcessAnswer(currentQuestion, answer)) {
      return; 
    }

    final timeTaken = _timerService.calculateTimeTaken(currentQuestion.timeLimit);
    final isCorrect = _answerChecker.checkAnswer(currentQuestion, answer);
    
    log("QuizCubit: Answer checked. Correct: $isCorrect, Time taken: $timeTaken seconds");

    final answerModel = AnswerModel(
      questionId: currentQuestion.id,
      answer: answer,
      timeTaken: timeTaken,
      isCorrect: isCorrect,
    );
    
    _processAnswer(answerModel);
  }

  void _processAnswer(AnswerModel answer) {
    final currentState = state;
    if (currentState is! QuizLoaded) return;

    final updatedAnswers = [...currentState.answers, answer];

    emit(currentState.copyWith(
      answers: updatedAnswers,
      isQuestionAnswered: true,
    ));

    _timerService.cancelTimer();

    Timer(const Duration(seconds: 2), () {
      final latestState = state;
      if (latestState is QuizLoaded &&
          latestState.currentQuestionIndex == currentState.currentQuestionIndex) {
        nextQuestion();
      }
    });
  }

  void nextQuestion() {
    final currentState = state;
    if (currentState is! QuizLoaded) return;

    if (currentState.currentQuestionIndex < currentState.questions.length - 1) {
      final nextIndex = currentState.currentQuestionIndex + 1;
      final nextQuestion = currentState.questions[nextIndex];
      
      log("QuizCubit: Moving to next question: Index $nextIndex, ID: ${nextQuestion.id}");

      emit(currentState.copyWith(
        currentQuestionIndex: nextIndex,
        remainingTime: nextQuestion.timeLimit,
        isQuestionAnswered: false,
      ));

      _timerService.startTimer(nextQuestion.timeLimit);
    } else {
      log("QuizCubit: Reached end of quiz. Completing...");
      _completeQuiz();
    }
  }

  void _completeQuiz() {
    final currentState = state;
    if (currentState is! QuizLoaded) return;

    final result = _resultCalculator.calculateResult(
      currentState.answers,
      currentState.questions.length,
    );

    log("QuizCubit: Quiz completed. Score: ${result.totalScore}/${result.totalQuestions}, Percentage: ${result.percentage.toStringAsFixed(1)}%");
    
    _timerService.cancelTimer();
    emit(QuizCompleted(result: result));
  }

  void restartQuiz() {
    log("QuizCubit: Restarting quiz...");
    _timerService.dispose();
    emit(QuizInitial());
    loadQuiz();
  }

  @override
  Future<void> close() {
    log("QuizCubit: Closing cubit and disposing services.");
    _timerService.dispose();
    return super.close();
  }
}