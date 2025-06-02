
import 'package:equatable/equatable.dart';
import 'package:flutter_task_app/features/quiz/model/question_model.dart';
import 'package:flutter_task_app/features/quiz/model/quiz_answer.dart';
import 'package:flutter_task_app/features/quiz/model/quiz_result_model.dart';

abstract class QuizState extends Equatable {
  const QuizState();

  @override
  List<Object?> get props => [];
}

class QuizInitial extends QuizState {}

class QuizLoading extends QuizState {}

class QuizLoaded extends QuizState {
  final List<QuestionModel> questions;
  final int currentQuestionIndex;
  final List<AnswerModel> answers;
  final int remainingTime;
  final bool isQuestionAnswered;

  const QuizLoaded({
    required this.questions,
    required this.currentQuestionIndex,
    required this.answers,
    required this.remainingTime,
    this.isQuestionAnswered = false,
  });

  QuizLoaded copyWith({
    List<QuestionModel>? questions,
    int? currentQuestionIndex,
    List<AnswerModel>? answers,
    int? remainingTime,
    bool? isQuestionAnswered,
  }) {
    return QuizLoaded(
      questions: questions ?? this.questions,
      currentQuestionIndex: currentQuestionIndex ?? this.currentQuestionIndex,
      answers: answers ?? this.answers,
      remainingTime: remainingTime ?? this.remainingTime,
      isQuestionAnswered: isQuestionAnswered ?? this.isQuestionAnswered,
    );
  }

  @override
  List<Object?> get props => [questions, currentQuestionIndex, answers, remainingTime, isQuestionAnswered];
}

class QuizCompleted extends QuizState {
  final QuizResultModel result;

  const QuizCompleted({required this.result});

  @override
  List<Object?> get props => [result];
}

class QuizError extends QuizState {
  final String message;

  const QuizError({required this.message});

  @override
  List<Object?> get props => [message];
}
