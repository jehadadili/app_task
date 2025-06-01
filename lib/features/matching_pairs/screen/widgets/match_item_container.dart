import 'package:flutter/material.dart';
import 'package:flutter_task_app/core/widgets/match_item_styles.dart';
import 'package:flutter_task_app/features/matching_pairs/model/match_item.dart';

class MatchItemContainer extends StatelessWidget {
  final MatchItem item;
  final bool isSelected;
  final bool? isCorrect;

  const MatchItemContainer({
    super.key,
    required this.item,
    required this.isSelected,
    required this.isCorrect,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      decoration: BoxDecoration(
        gradient: MatchItemStyles.getItemGradient(isSelected, isCorrect),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: MatchItemStyles.getBorderColor(isSelected, isCorrect),
          width: isSelected ? 3.0 : 1.5,
        ),
      ),
      child: MatchItemContent(
        item: item,
        isSelected: isSelected,
        isCorrect: isCorrect,
      ),
    );
  }
}


class MatchItemContent extends StatelessWidget {
  final MatchItem item;
  final bool isSelected;
  final bool? isCorrect;

  const MatchItemContent({
    super.key,
    required this.item,
    required this.isSelected,
    required this.isCorrect,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (isCorrect == true) ...[
          const Icon(Icons.check_circle, color: Colors.white, size: 20),
          const SizedBox(width: 8),
        ] else if (isCorrect == false) ...[
          const Icon(Icons.error, color: Colors.white, size: 20),
          const SizedBox(width: 8),
        ],
        Flexible(
          child: Text(
            item.text,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 16,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
              color: MatchItemStyles.getTextColor(isSelected, isCorrect),
            ),
          ),
        ),
      ],
    );
  }
}
