import 'package:flutter/material.dart';
import 'package:flutter_task_app/features/quiz/model/matching_quiz_question.dart';
import 'package:flutter_task_app/features/quiz/view/widgets/matching_quiz/widgets/match_item_widget.dart';
import 'package:flutter_task_app/features/quiz/view/widgets/matching_quiz/widgets/matching_controller.dart';

class MatchingLeftColumn extends StatelessWidget {
  final MatchingController controller;
  final MatchingQuestion question;
  final bool isAnswered;
  final Function(String, bool) onTap;

  const MatchingLeftColumn({
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
            'Connect these items:',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: Colors.blue.shade700,
                ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          ...question.leftItems.map((item) {
            final isSelected = controller.selectedLeft == item;
            final isMatched = controller.userMatches.containsKey(item);
            final matchedValue = controller.userMatches[item];
            final isCorrect = isAnswered &&
                question.correctMatches[item] == matchedValue;

            return Padding(
              key: controller.leftKeys[item],
              padding: const EdgeInsets.only(bottom: 12),
              child: MatchItemWidget(
                itemText: item,
                isSelected: isSelected,
                isMatched: isMatched,
                isCorrect: isCorrect,
                isAnswered: isAnswered,
                isLeft: true,
                onTap: () => onTap(item, true),
              ),
            );
          }),
        ],
      ),
    );
  }
}