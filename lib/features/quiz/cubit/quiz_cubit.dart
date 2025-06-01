import 'dart:async';
import 'dart:developer' show log;
import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_task_app/features/quiz/cubit/quiz_state.dart';
import 'package:flutter_task_app/features/quiz/model/drag_drop_quiz_question.dart';
import 'package:flutter_task_app/features/quiz/model/matching_quiz_question.dart';
import 'package:flutter_task_app/features/quiz/model/multiple_choice_question.dart';
import 'package:flutter_task_app/features/quiz/model/question.dart';
import 'package:flutter_task_app/features/quiz/model/quiz_answer.dart';

class QuizCubit extends Cubit<QuizState> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  Timer? _questionTimer;

  QuizCubit() : super(QuizInitial());

  @override
  Future<void> close() {
    _questionTimer?.cancel();
    return super.close();
  }

  Future<void> startQuiz(String quizId) async {
    emit(QuizLoading());
    try {
      QuerySnapshot questionSnapshot = await _firestore
          .collection('quizzes')
          .doc(quizId)
          .collection('questions')
          .orderBy('order')
          .get();

      if (questionSnapshot.docs.isEmpty) {
        emit(QuizError("No questions found for this quiz."));
        return;
      }

      List<Question> questions = questionSnapshot.docs
          .map(
            (doc) => Question.fromFirestore(
              doc.data() as Map<String, dynamic>,
              doc.id,
            ),
          )
          .toList();

      if (questions.isEmpty) {
        emit(QuizError("Failed to parse questions."));
        return;
      }

      _startQuestionTimer(questions[0].timeLimitSeconds);
      emit(
        QuizInProgress(
          questions: questions,
          currentQuestionIndex: 0,
          userAnswers: {},
          remainingTimeSeconds: questions[0].timeLimitSeconds,
        ),
      );
    } catch (e) {
      emit(QuizError("Failed to load quiz: ${e.toString()}"));
    }
  }

  void _startQuestionTimer(int seconds) {
    _questionTimer?.cancel();
    int remaining = seconds;
    _questionTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (state is QuizInProgress) {
        final currentState = state as QuizInProgress;
        if (remaining > 0) {
          remaining--;
          emit(
            QuizInProgress(
              questions: currentState.questions,
              currentQuestionIndex: currentState.currentQuestionIndex,
              userAnswers: currentState.userAnswers,
              remainingTimeSeconds: remaining,
              answerSubmitted: currentState.answerSubmitted,
            ),
          );
        } else {
          timer.cancel();
          submitAnswer(null);
        }
      } else {
        timer.cancel();
      }
    });
  }

  void submitAnswer(dynamic userAnswer) {
    if (state is QuizInProgress) {
      final currentState = state as QuizInProgress;
      _questionTimer?.cancel();

      final currentQuestion = currentState.currentQuestion;
      bool isCorrect = false;
      int timeTaken =
          currentQuestion.timeLimitSeconds - currentState.remainingTimeSeconds;

      if (userAnswer != null) {
        if (currentQuestion is MultipleChoiceQuestion) {
          isCorrect = userAnswer == currentQuestion.correctAnswerIndex;
        } else if (currentQuestion is DragDropQuizQuestion) {
          isCorrect = userAnswer == currentQuestion.correctAnswer;
        } else if (currentQuestion is MatchingQuizQuestion) {
          if (userAnswer is Map<String, String>) {
            Map<String, String> userPairs = userAnswer;
            Map<String, String> correctPairs = currentQuestion.correctPairs;
            if (userPairs.length == correctPairs.length) {
              isCorrect = userPairs.entries.every(
                (entry) => correctPairs[entry.key] == entry.value,
              );
            } else {
              isCorrect = false;
            }
          } else {
            isCorrect = false;
          }
        }
      }

      final answer = QuizAnswer(
        questionId: currentQuestion.id,
        answer: userAnswer,
        isCorrect: isCorrect,
        timeTakenSeconds: timeTaken,
      );

      Map<String, QuizAnswer> updatedAnswers = Map.from(
        currentState.userAnswers,
      );
      updatedAnswers[currentQuestion.id] = answer;

      emit(
        QuizInProgress(
          questions: currentState.questions,
          currentQuestionIndex: currentState.currentQuestionIndex,
          userAnswers: updatedAnswers,
          remainingTimeSeconds: currentState.remainingTimeSeconds,
          answerSubmitted: true,
        ),
      );
    } else {
      log("Cannot submit answer: Quiz not in progress.");
    }
  }

  void moveToNextQuestion() {
    if (state is QuizInProgress) {
      final currentState = state as QuizInProgress;

      if (!currentState.answerSubmitted) {
        log("Warning: Moving to next question before submitting answer.");
      }

      int nextIndex = currentState.currentQuestionIndex + 1;
      if (nextIndex < currentState.questions.length) {
        final nextQuestion = currentState.questions[nextIndex];
        _startQuestionTimer(nextQuestion.timeLimitSeconds);
        emit(
          QuizInProgress(
            questions: currentState.questions,
            currentQuestionIndex: nextIndex,
            userAnswers: currentState.userAnswers,
            remainingTimeSeconds: nextQuestion.timeLimitSeconds,
            answerSubmitted: false,
          ),
        );
      } else {
        _finishQuiz(currentState.questions, currentState.userAnswers);
      }
    } else {
      log("Cannot move to next question: Quiz not in progress.");
    }
  }

  void _finishQuiz(
    List<Question> questions,
    Map<String, QuizAnswer> userAnswers,
  ) {
    _questionTimer?.cancel();
    int score = 0;
    userAnswers.forEach((_, answer) {
      if (answer.isCorrect) {
        score++;
      }
    });

    emit(
      QuizFinished(
        questions: questions,
        userAnswers: userAnswers,
        finalScore: score,
        totalQuestions: questions.length,
      ),
    );
  }
}
