import 'dart:async';
import 'dart:developer';
import 'package:bloc/bloc.dart';
import 'package:flutter_task_app/features/quiz/presentation/cubit/quiz_state.dart';


class QuizCubit extends Cubit<QuizState> {
  List<dynamic> _questions = []; 
  int _currentQuestionIndex = 0;
  int _score = 0;
  Timer? _questionTimer;
  final Stopwatch _quizStopwatch = Stopwatch();
  Duration _currentQuestionTime = Duration.zero;

  final Duration _timePerQuestion = const Duration(seconds: 30);

  QuizCubit() : super(QuizInitial());

  @override
  Future<void> close() {
    _questionTimer?.cancel();
    _quizStopwatch.stop();
    return super.close();
  }

  Future<void> loadQuestions() async {
    emit(QuizLoading());
    try {
   
      log("--- Placeholder: Fetching quiz questions from Firestore ---");
    
      await Future.delayed(const Duration(seconds: 1)); 
      _questions = [
        {
          'id': 'q1',
          'type': 'multiple_choice',
          'question': 'What is Flutter?',
          'options': ['UI Framework', 'Game Engine', 'OS', 'Database'],
          'answer': 'UI Framework',
        },
        {
          'id': 'q2',
          'type': 'drag_drop', 
          'sentence': 'Dart is a _____ language.',
          'options': ['compiled', 'interpreted', 'client-optimized', 'scripting'],
          'answer': 'client-optimized',
        },
        {
          'id': 'q3',
          'type': 'matching', 
          'pairs': [
            {'left': 'Firebase', 'right': 'Backend'}, 
            {'left': 'Bloc', 'right': 'State Management'}
          ],
          'matches': {'Firebase': 'Backend', 'Bloc': 'State Management'}
        },
         {
          'id': 'q4',
          'type': 'multiple_choice',
          'question': 'Which widget is used for layout?',
          'options': ['Text', 'Column', 'Image', 'Button'],
          'answer': 'Column',
        },
      ];
      log("Mock questions loaded: ${_questions.length}");
      // --- End Mock Implementation ---

      if (_questions.isNotEmpty) {
        _currentQuestionIndex = 0;
        _score = 0;
        _quizStopwatch.reset();
        _quizStopwatch.start();
        _startQuestionTimer();
        emit(QuizLoaded(questions: _questions, currentQuestionIndex: _currentQuestionIndex));
      } else {
        emit(QuizError("No questions found for the quiz."));
      }
    } catch (e) {
      log("Error loading questions: ${e.toString()}");
      emit(QuizError("Failed to load quiz questions: ${e.toString()}"));
    }
  }

  void _startQuestionTimer() {
    _questionTimer?.cancel(); 
    _currentQuestionTime = _timePerQuestion;
    _questionTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_currentQuestionTime.inSeconds <= 0) {
        timer.cancel();
      
        log("Time up for question ${_currentQuestionIndex + 1}");
      
      } else {
        _currentQuestionTime -= const Duration(seconds: 1);
      }
    });
  }

  void submitAnswer(dynamic answer) { 
    _questionTimer?.cancel(); 
    final currentQuestion = _questions[_currentQuestionIndex];
    bool isCorrect = false;

    log("--- Placeholder: Checking answer for question ${_currentQuestionIndex + 1} ---");
    log("Submitted Answer: $answer");
    log("Correct Answer: ${currentQuestion['answer']}");

    if (currentQuestion['type'] == 'multiple_choice') {
      if (answer == currentQuestion['answer']) {
        isCorrect = true;
      }
    }

    if (isCorrect) {
      _score++;
      log("Answer Correct! Score: $_score");
    } else {
      log("Answer Incorrect. Score: $_score");
    }

    if (_currentQuestionIndex < _questions.length - 1) {
      _currentQuestionIndex++;
      _startQuestionTimer();
      emit(QuizLoaded(questions: _questions, currentQuestionIndex: _currentQuestionIndex));
    } else {
      _quizStopwatch.stop();
      log("Quiz Finished!");
      log("Final Score: $_score / ${_questions.length}");
      log("Total Time: ${_quizStopwatch.elapsed}");
      emit(QuizFinished(
        score: _score,
        totalQuestions: _questions.length,
        timeTaken: _quizStopwatch.elapsed,
      ));
    }
  }

}

