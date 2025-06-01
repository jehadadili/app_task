import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_task_app/features/matching_pairs/cubit/matching_pairs_cubit.dart';
import 'package:flutter_task_app/features/matching_pairs/cubit/matching_pairs_state.dart';
import 'package:flutter_task_app/features/matching_pairs/model/game_data.dart';
import 'package:flutter_task_app/features/matching_pairs/model/match_item.dart';
import 'package:flutter_task_app/features/matching_pairs/screen/widgets/game_data_extractor.dart';
import 'matching_canvas.dart';
import 'game_controls.dart';

class MatchingGameWidget extends StatefulWidget {
  const MatchingGameWidget({super.key});

  @override
  State<MatchingGameWidget> createState() => _MatchingGameWidgetState();
}

class _MatchingGameWidgetState extends State<MatchingGameWidget> {
  final Map<String, GlobalKey> _itemKeys = {};
  final GlobalKey _canvasKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: _buildAppBar(),
      body: BlocBuilder<MatchingPairsCubit, MatchingPairsState>(
        builder: (context, state) {
          final gameData = GameDataExtractor.extract(state);
          _initializeKeys(gameData.leftItems, gameData.rightItems);

          return Column(
            children: [
              _buildHeader(gameData),
              Expanded(
                child: MatchingCanvas(
                  canvasKey: _canvasKey,
                  itemKeys: _itemKeys,
                  gameData: gameData,
                ),
              ),
              GameControls(gameData: gameData),
            ],
          );
        },
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      title: const Text(
        'Matching Pairs Game',
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
      backgroundColor: Colors.indigo.shade600,
      foregroundColor: Colors.white,
      elevation: 0,
      centerTitle: true,
    );
  }

  Widget _buildHeader(GameData gameData) {
    if (!gameData.submitted) return const SizedBox.shrink();

    return Container(
      width: double.infinity,
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.indigo.shade600, Colors.blue.shade400],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.indigo.withValues(alpha: 0.3),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Icon(
            gameData.score == gameData.total ? Icons.celebration : Icons.score,
            color: Colors.white,
            size: 32,
          ),
          const SizedBox(height: 8),
          Text(
            'Score: ${gameData.score} / ${gameData.total}',
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          if (gameData.score == gameData.total)
            const Text(
              '🎉 Perfect Score! 🎉',
              style: TextStyle(
                fontSize: 16,
                color: Colors.white70,
                fontWeight: FontWeight.w500,
              ),
            ),
        ],
      ),
    );
  }

  void _initializeKeys(List<MatchItem> left, List<MatchItem> right) {
    for (var item in [...left, ...right]) {
      _itemKeys.putIfAbsent(item.id, () => GlobalKey());
    }
  }
}
