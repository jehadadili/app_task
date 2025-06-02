
import 'package:flutter/material.dart';

class MatchItemWidget extends StatelessWidget {
  final String itemText;
  final bool isSelected;
  final bool isMatched;
  final bool isCorrect;
  final bool isAnswered;
  final bool isLeft;
  final VoidCallback onTap;

  const MatchItemWidget({
    super.key,
    required this.itemText,
    required this.isSelected,
    required this.isMatched,
    required this.isCorrect,
    required this.isAnswered,
    required this.isLeft,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    Color bgColor;
    Color borderColor;
    double borderWidth = 1.5;
    List<BoxShadow>? boxShadow;
    IconData? trailingIconData;
    Color? trailingIconColor;
    IconData? leadingIconData;
    Color? leadingIconColor;

    final Color primarySelectColor = isLeft ? Colors.blue : Colors.purple;
    final Color primarySelectShade = isLeft
        ? Colors.blue.shade100
        : Colors.purple.shade100;

    if (isSelected) {
      bgColor = primarySelectShade;
      borderColor = primarySelectColor;
      borderWidth = 2.5;
      boxShadow = [
        BoxShadow(
          color: primarySelectColor.withValues(alpha: 0.3),
          blurRadius: 6,
          offset: const Offset(0, 3),
        ),
      ];
      if (isLeft) {
        trailingIconData = Icons.radio_button_checked;
        trailingIconColor = primarySelectColor;
      } else {
        leadingIconData = Icons.radio_button_checked;
        leadingIconColor = primarySelectColor;
      }
    } else if (isMatched) {
      if (isAnswered) {
        bgColor = isCorrect ? Colors.green.shade50 : Colors.red.shade50;
        borderColor = isCorrect ? Colors.green.shade300 : Colors.red.shade300;
        if (isLeft) {
          trailingIconData = isCorrect
              ? Icons.check_circle_outline
              : Icons.highlight_off;
          trailingIconColor = isCorrect ? Colors.green : Colors.red;
        } else {
          leadingIconData = isCorrect
              ? Icons.check_circle_outline
              : Icons.highlight_off;
          leadingIconColor = isCorrect ? Colors.green : Colors.red;
        }
      } else {
        bgColor = Colors.orange.shade50;
        borderColor = Colors.orange.shade300;
        if (isLeft) {
          trailingIconData = Icons.link;
          trailingIconColor = Colors.orange;
        } else {
          leadingIconData = Icons.link;
          leadingIconColor = Colors.orange;
        }
      }
    } else {
      bgColor = Colors.white;
      borderColor = Colors.grey.shade300;
      if (isLeft) {
        trailingIconData = Icons.radio_button_unchecked;
        trailingIconColor = Colors.grey.shade400;
      } else {
        leadingIconData = Icons.radio_button_unchecked;
        leadingIconColor = Colors.grey.shade400;
      }
    }

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: borderColor, width: borderWidth),
          boxShadow: boxShadow,
        ),
        child: Row(
          children: [
            if (leadingIconData != null)
              Padding(
                padding: const EdgeInsets.only(right: 8.0),
                child: Icon(leadingIconData, color: leadingIconColor, size: 20),
              ),
            Expanded(
              child: Text(
                itemText,
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                  color: isSelected || isMatched
                      ? Colors.black87
                      : Colors.grey.shade700,
                ),
                textAlign: isLeft ? TextAlign.left : TextAlign.right,
              ),
            ),
            if (trailingIconData != null)
              Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: Icon(
                  trailingIconData,
                  color: trailingIconColor,
                  size: 20,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
