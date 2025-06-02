
import 'package:flutter/material.dart';
import 'package:flutter_task_app/features/quiz/model/matching_quiz_question.dart';
import 'package:flutter_task_app/features/quiz/view/widgets/matching_quiz/widgets/match_item_widget.dart';
import 'package:flutter_task_app/features/quiz/view/widgets/matching_quiz/widgets/matching_controller.dart';

class MatchingRightColumn extends StatelessWidget {
  final MatchingController controller;
  final MatchingQuestion question;
  final bool isAnswered;
  final Function(String, bool) onTap;

  const MatchingRightColumn({
    super.key,
    required this.controller,
    required this.question,
    required this.isAnswered,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'With this:',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: Colors.purple.shade700,
                ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          ...question.rightItems.map((item) {
            final matchedEntry = controller.userMatches.entries
                .firstWhere(
                  (entry) => entry.value == item,
                  orElse: () => const MapEntry<String, String>('', ''),
                );
            final isMatched = matchedEntry.key.isNotEmpty;
            final matchedKey = matchedEntry.key;
            final isCorrect = isAnswered &&
                isMatched &&
                question.correctMatches[matchedKey] == item;

            return Padding(
              key: controller.rightKeys[item],
              padding: const EdgeInsets.only(bottom: 12),
              child: MatchItemWidget(
                itemText: item,
                isSelected: false,
                isMatched: isMatched,
                isCorrect: isCorrect,
                isAnswered: isAnswered,
                isLeft: false,
                onTap: () => onTap(item, false),
              ),
            );
          }),
        ],
      ),
    );
  }
}