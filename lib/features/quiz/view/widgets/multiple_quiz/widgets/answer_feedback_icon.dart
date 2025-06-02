import 'package:flutter/material.dart';

class AnswerFeedbackIcon extends StatelessWidget {
  final bool show;
  final bool isCorrect;
  final bool isSelectedWrong;

  const AnswerFeedbackIcon({
    super.key,
    required this.show,
    required this.isCorrect,
    this.isSelectedWrong = false,
  });

  @override
  Widget build(BuildContext context) {
    if (!show) return const SizedBox();

    if (isCorrect) {
      return const Icon(Icons.check_circle, color: Colors.green);
    } else if (isSelectedWrong) {
      return const Icon(Icons.cancel, color: Colors.red);
    }

    return const SizedBox();
  }
}
