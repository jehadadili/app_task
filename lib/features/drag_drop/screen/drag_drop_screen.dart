import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_task_app/features/drag_drop/cubit/drag_drop_cubit.dart';
import 'package:flutter_task_app/features/drag_drop/screen/widgets/drag_drop_exercise_page.dart';

class DragDropScreen extends StatelessWidget {
  const DragDropScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => DragDropCubit(),
      child: const DragDropExercisePage(),
    );
  }
}
