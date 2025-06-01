import 'package:flutter/material.dart';

class MatchItemStyles {
  static LinearGradient getItemGradient(bool isSelected, bool? isCorrect) {
    if (isSelected) {
      return LinearGradient(
        colors: [Colors.blue.shade400, Colors.blue.shade600],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      );
    } else if (isCorrect == true) {
      return LinearGradient(
        colors: [Colors.green.shade400, Colors.green.shade600],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      );
    } else if (isCorrect == false) {
      return LinearGradient(
        colors: [Colors.red.shade400, Colors.red.shade600],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      );
    }
    return LinearGradient(
      colors: [Colors.grey.shade100, Colors.grey.shade200],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    );
  }

  static Color getBorderColor(bool isSelected, bool? isCorrect) {
    if (isSelected) return Colors.blue.shade700;
    if (isCorrect == true) return Colors.green.shade700;
    if (isCorrect == false) return Colors.red.shade700;
    return Colors.grey.shade300;
  }

  static Color getTextColor(bool isSelected, bool? isCorrect) {
    if (isSelected || isCorrect != null) return Colors.white;
    return Colors.grey.shade800;
  }
}