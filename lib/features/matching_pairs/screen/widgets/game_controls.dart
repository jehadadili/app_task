
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_task_app/features/matching_pairs/cubit/matching_pairs_cubit.dart';
import 'package:flutter_task_app/features/matching_pairs/model/game_data.dart';

class GameControls extends StatelessWidget {
  final GameData gameData;

  const GameControls({super.key, required this.gameData});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: SizedBox(
          width: double.infinity,
          height: 56,
          child: ElevatedButton(
            onPressed: () => _onButtonPressed(context),
            style: ElevatedButton.styleFrom(
              backgroundColor: gameData.submitted ? Colors.green.shade600 : Colors.indigo.shade600,
              foregroundColor: Colors.white,
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  gameData.submitted ? Icons.refresh : Icons.send,
                  size: 24,
                ),
                const SizedBox(width: 12),
                Text(
                  gameData.submitted ? 'Try Again' : 'Submit Answers',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _onButtonPressed(BuildContext context) {
    if (gameData.submitted) {
      context.read<MatchingPairsCubit>().resetExercise();
    } else {
      context.read<MatchingPairsCubit>().submitAnswers();
    }
  }
}

