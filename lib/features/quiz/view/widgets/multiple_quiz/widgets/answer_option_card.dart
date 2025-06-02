import 'package:flutter/material.dart';
import 'package:flutter_task_app/features/quiz/view/widgets/multiple_quiz/widgets/answer_feedback_icon.dart';
import 'package:flutter_task_app/features/quiz/view/widgets/multiple_quiz/widgets/option_indicator.dart';

class AnswerOptionCard extends StatelessWidget {
  final int index;
  final String option;
  final bool isSelected;
  final bool isCorrect;
  final bool isAnswered;
  final VoidCallback? onTap;

  const AnswerOptionCard({
    super.key,
    required this.index,
    required this.option,
    required this.isSelected,
    required this.isCorrect,
    required this.isAnswered,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    Color cardColor = Colors.white;
    Color borderColor = Colors.grey.shade300;

    if (isAnswered) {
      if (isCorrect) {
        cardColor = Colors.green.shade50;
        borderColor = Colors.green;
      } else if (isSelected && !isCorrect) {
        cardColor = Colors.red.shade50;
        borderColor = Colors.red;
      }
    } else if (isSelected) {
      cardColor = Colors.blue.shade50;
      borderColor = Colors.blue;
    }

    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      margin: const EdgeInsets.only(bottom: 12),
      child: Material(
        elevation: isSelected ? 4 : 1,
        borderRadius: BorderRadius.circular(12),
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: onTap,
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: cardColor,
              border: Border.all(color: borderColor, width: 2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                OptionIndicator(letter: String.fromCharCode(65 + index), color: borderColor),
                const SizedBox(width: 16),
                Expanded(
                  child: Text(
                    option,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                    ),
                  ),
                ),
                AnswerFeedbackIcon(
                  isCorrect: isCorrect,
                  show: isAnswered && (isCorrect || isSelected),
                  isSelectedWrong: isSelected && !isCorrect,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
