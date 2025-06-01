import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_task_app/features/matching_pairs/cubit/matching_pairs_cubit.dart';
import 'package:flutter_task_app/features/matching_pairs/screen/widgets/matching_game_widget.dart';

class MatchingScreen extends StatelessWidget {
  const MatchingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => MatchingPairsCubit(),
      child: const MatchingGameWidget(),
    );
  }
}
