import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:flutter_task_app/features/quiz/cubit/quiz_cubit.dart';
import 'package:flutter_task_app/features/quiz/cubit/quiz_state.dart';
import 'package:flutter_task_app/features/quiz/model/drag_drop_quiz_question.dart';
import 'package:flutter_task_app/features/quiz/model/matching_quiz_question.dart';
import 'package:flutter_task_app/features/quiz/model/multiple_choice_question.dart';
import 'package:flutter_task_app/features/quiz/model/question.dart';
import 'package:flutter_task_app/features/quiz/view/widgets/drag_drop_quiz_widget.dart';
import 'package:flutter_task_app/features/quiz/view/widgets/matching_quiz_widget.dart';
import 'package:flutter_task_app/features/quiz/view/widgets/multiple_choice_widget.dart';
import 'package:flutter_task_app/features/quiz/view/widgets/quiz_results_page.dart'; 

class QuizScreen extends StatelessWidget {
  final String quizId;

  const QuizScreen({super.key, required this.quizId});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => QuizCubit()..startQuiz(quizId),
      child: const QuizView(),
    );
  }
}

class QuizView extends StatelessWidget {
  const QuizView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Quiz'),
        actions: [
          BlocBuilder<QuizCubit, QuizState>(
            builder: (context, state) {
              if (state is QuizInProgress) {
                return Padding(
                  padding: const EdgeInsets.only(right: 16.0),
                  child: Center(
                    child: Text(
                      '${state.currentQuestionIndex + 1} / ${state.questions.length}',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(color: Colors.white),
                    ),
                  ),
                );
              }
              return const SizedBox.shrink();
            },
          ),
        ],
      ),
      body: BlocConsumer<QuizCubit, QuizState>(
        listener: (context, state) {
          if (state is QuizError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Error: ${state.message}'), backgroundColor: Colors.red),
            );
            Navigator.of(context).pop();
          }
          if (state is QuizFinished) {
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(
                builder: (_) => QuizResultsPage(
                  questions: state.questions,
                  userAnswers: state.userAnswers,
                  finalScore: state.finalScore,
                  totalQuestions: state.totalQuestions,
                ),
              ),
            );
          }
        },
        builder: (context, state) {
          if (state is QuizLoading || state is QuizInitial) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state is QuizInProgress) {
            final question = state.currentQuestion;
            final progress = state.progress;
            final time = state.remainingTimeSeconds;

            return Column(
              children: [
                // Progress Indicator
                LinearProgressIndicator(value: progress, minHeight: 8.0),
                // Timer Display
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 12.0),
                  child: Text(
                    'Time Left: ${time}s', // Needs localization
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
                  ),
                ),
                Expanded(
                  child: AnimatedSwitcher(
                     duration: const Duration(milliseconds: 500), // Animation between questions
                     transitionBuilder: (Widget child, Animation<double> animation) {
                       // Example animation: Fade and Scale
                       return FadeTransition(opacity: animation, child: ScaleTransition(scale: animation, child: child));
                     },
                     child: Padding(
                       // Use a Key based on question ID to ensure AnimatedSwitcher detects change
                       key: ValueKey<String>(question.id),
                       padding: const EdgeInsets.all(16.0),
                       child: _buildQuestionWidget(context, question, state.answerSubmitted),
                     ),
                  ),
                ),
                // Submit/Next Button
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(minimumSize: const Size(double.infinity, 50)),
                    onPressed: state.answerSubmitted ? null : () {
                      
                      log("Submit/Next button pressed - Logic handled in question widget");
                    },
                    child: Text(state.answerSubmitted ? 'Next Question' : 'Submit Answer'), 
                  ),
                ),
              ],
            );
          }
          return const Center(child: Text('Starting Quiz...'));
        },
      ),
    );
  }

  Widget _buildQuestionWidget(BuildContext context, Question question, bool answerSubmitted) {
    final quizCubit = context.read<QuizCubit>();

    if (question is MultipleChoiceQuestion) {
      return MultipleChoiceWidget(
        key: ValueKey(question.id), 
        question: question,
        onAnswerSelected: (answerIndex) {
           if (!answerSubmitted) { // Prevent submitting multiple times
             quizCubit.submitAnswer(answerIndex);
           }
        },
        answerSubmitted: answerSubmitted,
        userAnswer: answerSubmitted ? quizCubit.state is QuizInProgress ? (quizCubit.state as QuizInProgress).userAnswers[question.id]?.answer : null : null,
      );
    } else if (question is DragDropQuizQuestion) {
      return DragDropQuizWidget(
         key: ValueKey(question.id),
         question: question,
         onAnswerDropped: (answer) {
            if (!answerSubmitted) {
               quizCubit.submitAnswer(answer);
            }
         },
         answerSubmitted: answerSubmitted,
         userAnswer: answerSubmitted ? quizCubit.state is QuizInProgress ? (quizCubit.state as QuizInProgress).userAnswers[question.id]?.answer : null : null,
      );
    } else if (question is MatchingQuizQuestion) {
      return MatchingQuizWidget(
         key: ValueKey(question.id),
         question: question,
         onPairsSubmitted: (pairs) {
           if (!answerSubmitted) {
              quizCubit.submitAnswer(pairs);
           }
         },
         answerSubmitted: answerSubmitted,
         userAnswer: answerSubmitted ? quizCubit.state is QuizInProgress ? (quizCubit.state as QuizInProgress).userAnswers[question.id]?.answer : null : null,
      );
    } else {
      return Center(child: Text('Unsupported question type: ${question.type}'));
    }
  }
}
