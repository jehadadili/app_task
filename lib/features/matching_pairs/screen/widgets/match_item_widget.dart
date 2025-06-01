import 'package:flutter/material.dart';
import 'package:flutter_task_app/features/matching_pairs/model/game_data.dart';
import 'package:flutter_task_app/features/matching_pairs/model/match_item.dart';
import 'package:flutter_task_app/features/matching_pairs/screen/widgets/match_item_container.dart';
import 'package:flutter_task_app/features/matching_pairs/screen/widgets/match_item_tap_handler.dart';
import 'match_item_logic.dart';

class MatchItemWidget extends StatelessWidget {
  final MatchItem item;
  final GameData gameData;

  const MatchItemWidget({
    super.key,
    required this.item,
    required this.gameData,
  });

  @override
  Widget build(BuildContext context) {
    final isSelected = item.id == gameData.selectedItemId;
    final isCorrect = MatchItemLogic.getItemCorrectness(item, gameData);

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: Material(
        elevation: isSelected ? 8 : 2,
        borderRadius: BorderRadius.circular(12),
        child: MatchItemTapHandler(
          item: item,
          gameData: gameData,
          child: MatchItemContainer(
            item: item,
            isSelected: isSelected,
            isCorrect: isCorrect,
          ),
        ),
      ),
    );
  }
}
