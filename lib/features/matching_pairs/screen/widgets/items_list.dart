import 'package:flutter/material.dart';
import 'package:flutter_task_app/features/matching_pairs/model/game_data.dart';
import 'package:flutter_task_app/features/matching_pairs/model/match_item.dart';
import 'match_item_widget.dart';

class ItemsList extends StatelessWidget {
  final List<MatchItem> items;
  final Map<String, GlobalKey> itemKeys;
  final GameData gameData;
  final bool isLeftSide;

  const ItemsList({
    super.key,
    required this.items,
    required this.itemKeys,
    required this.gameData,
    required this.isLeftSide,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ListView.builder(
        padding: const EdgeInsets.all(20),
        itemCount: items.length,
        itemBuilder: (context, index) {
          final item = items[index];
          return MatchItemWidget(
            key: itemKeys[item.id],
            item: item,
            gameData: gameData,
          );
        },
      ),
    );
  }
}

