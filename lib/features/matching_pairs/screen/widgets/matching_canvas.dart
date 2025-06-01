import 'package:flutter/material.dart';
import 'package:flutter_task_app/features/matching_pairs/model/game_data.dart';
import 'package:flutter_task_app/features/matching_pairs/screen/widgets/connections_painter.dart';
import 'items_list.dart';

class MatchingCanvas extends StatelessWidget {
  final GlobalKey canvasKey;
  final Map<String, GlobalKey> itemKeys;
  final GameData gameData;

  const MatchingCanvas({
    super.key,
    required this.canvasKey,
    required this.itemKeys,
    required this.gameData,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Stack(
        key: canvasKey,
        children: [
          CustomPaint(
            size: Size.infinite,
            painter: ConnectionsPainter(
              itemKeys: itemKeys,
              canvasKey: canvasKey,
              connections: gameData.connections,
              selectedItemId: gameData.selectedItemId,
              submitted: gameData.submitted,
              correctConnections: gameData.correctConnections,
            ),
          ),
          Row(
            children: [
              ItemsList(
                items: gameData.leftItems,
                itemKeys: itemKeys,
                gameData: gameData,
                isLeftSide: true,
              ),
              Container(
                width: 1,
                color: Colors.grey.shade200,
                margin: const EdgeInsets.symmetric(vertical: 20),
              ),
              ItemsList(
                items: gameData.rightItems,
                itemKeys: itemKeys,
                gameData: gameData,
                isLeftSide: false,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

