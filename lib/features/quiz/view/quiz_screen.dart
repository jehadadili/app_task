import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:flutter_task_app/features/quiz/cubit/quiz_cubit.dart';

import 'package:flutter_task_app/features/quiz/view/widgets/quiz_start_view.dart';

class QuizScreen extends StatelessWidget {
  const QuizScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => QuizCubit()..loadQuiz(),
      child: const QuizStartView(),
    );
  }
}
