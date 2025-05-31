import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_task_app/features/drag_drop/cubit/drag_drop_cubit.dart';
import 'package:flutter_task_app/features/drag_drop/cubit/drag_drop_state.dart';

class ControlButtonsWidget extends StatelessWidget {
  final DragDropState state;

  const ControlButtonsWidget({
    super.key,
    required this.state,
  });

  @override
  Widget build(BuildContext context) {
    if (state is DragDropCorrect || state is DragDropIncorrect) {
      return _buildTryAgainButton(context);
    }
    return const SizedBox.shrink();
  }

  Widget _buildTryAgainButton(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        ElevatedButton.icon(
          onPressed: () {
            context.read<DragDropCubit>().resetExercise();
          },
          icon: const Icon(Icons.refresh),
          label: const Text('Try Again'),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.orange,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          ),
        ),
      ],
    );
  }
}