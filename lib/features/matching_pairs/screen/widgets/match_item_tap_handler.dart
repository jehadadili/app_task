
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_task_app/features/matching_pairs/cubit/matching_pairs_cubit.dart';
import 'package:flutter_task_app/features/matching_pairs/model/game_data.dart';
import 'package:flutter_task_app/features/matching_pairs/model/match_item.dart';

class MatchItemTapHandler extends StatelessWidget {
  final MatchItem item;
  final GameData gameData;
  final Widget child;

  const MatchItemTapHandler({
    super.key,
    required this.item,
    required this.gameData,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: gameData.submitted ? null : () => _onItemTap(context),
      borderRadius: BorderRadius.circular(12),
      child: child,
    );
  }

  void _onItemTap(BuildContext context) {
    context.read<MatchingPairsCubit>().itemSelected(item.id);
  }
}