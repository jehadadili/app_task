
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_task_app/features/quiz/cubit/quiz_cubit.dart';
import 'package:flutter_task_app/features/quiz/cubit/quiz_state.dart';
import 'package:flutter_task_app/features/quiz/model/drag_drop_quiz_question.dart';
import 'package:flutter_task_app/features/quiz/model/matching_quiz_question.dart';
import 'package:flutter_task_app/features/quiz/model/multiple_choice_question.dart';
import 'package:flutter_task_app/features/quiz/model/question_model.dart';
import 'package:flutter_task_app/features/quiz/view/quiz_result_screen.dart';
import 'package:flutter_task_app/features/quiz/view/widgets/drag_drop_quiz_widget.dart';
import 'package:flutter_task_app/features/quiz/view/widgets/matching_quiz_widget.dart';
import 'package:flutter_task_app/features/quiz/view/widgets/multiple_choice_widget.dart';
import 'package:flutter_task_app/features/quiz/view/widgets/progress_indicator_widget.dart';
import 'package:flutter_task_app/features/quiz/view/widgets/quiz_timer_widget.dart';

class QuizView extends StatelessWidget {
  const QuizView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      body: BlocConsumer<QuizCubit, QuizState>(
        listener: (context, state) {
          if (state is QuizError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
        builder: (context, state) {
          if (state is QuizInitial || state is QuizLoading) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 16),
                  Text('Loading Quiz...', style: TextStyle(fontSize: 18)),
                ],
              ),
            );
          }

          if (state is QuizError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.error_outline,
                    size: 64,
                    color: Colors.red.shade400,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Error Loading Quiz',
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    state.message,
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.grey.shade600),
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: () => context.read<QuizCubit>().loadQuiz(),
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }

          if (state is QuizCompleted) {
            return QuizResultScreen(result: state.result);
          }

          if (state is QuizLoaded) {
            final currentQuestion = state.questions[state.currentQuestionIndex];

            return SafeArea(
              child: Column(
                children: [
                  ProgressIndicatorWidget(
                    currentQuestion: state.currentQuestionIndex,
                    totalQuestions: state.questions.length,
                  ),

                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: QuizTimerWidget(
                      remainingTime: state.remainingTime,
                      totalTime: currentQuestion.timeLimit,
                    ),
                  ),

                  // Question Content
                  Expanded(
                    child: AnimatedSwitcher(
                      duration: const Duration(milliseconds: 500),
                      transitionBuilder: (child, animation) {
                        return SlideTransition(
                          position: Tween<Offset>(
                            begin: const Offset(1.0, 0.0),
                            end: Offset.zero,
                          ).animate(animation),
                          child: child,
                        );
                      },
                      child: Container(
                        key: ValueKey(state.currentQuestionIndex),
                        padding: const EdgeInsets.all(16),
                        child: _buildQuestionWidget(
                          currentQuestion,
                          state.isQuestionAnswered,
                          context.read<QuizCubit>(),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }

  Widget _buildQuestionWidget(
    QuestionModel question,
    bool isAnswered,
    QuizCubit cubit,
  ) {
    switch (question.type) {
      case 'multiple_choice':
        return MultipleChoiceWidget(
          question: question as MultipleChoiceQuestion,
          isAnswered: isAnswered,
          onAnswerSelected: cubit.submitAnswer,
        );
      case 'drag_drop':
        return DragDropWidget(
          question: question as DragDropQuestion,
          isAnswered: isAnswered,
          onAnswerSelected: cubit.submitAnswer,
        );
      case 'matching':
        return MatchingWidget(
          question: question as MatchingQuestion,
          isAnswered: isAnswered,
          onAnswerSelected: cubit.submitAnswer,
        );
      default:
        return const Center(child: Text('Unsupported question type'));
    }
  }
}
