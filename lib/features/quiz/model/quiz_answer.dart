import 'package:equatable/equatable.dart';

class AnswerModel extends Equatable {
  final String questionId;
  final dynamic answer;
  final int timeTaken; 
  final bool isCorrect;

  const AnswerModel({
    required this.questionId,
    required this.answer,
    required this.timeTaken,
    required this.isCorrect,
  });

  @override
  List<Object?> get props => [questionId, answer, timeTaken, isCorrect];
}