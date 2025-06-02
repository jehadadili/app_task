import 'package:flutter/material.dart';
import 'package:flutter_task_app/features/quiz/model/matching_quiz_question.dart';
import 'package:flutter_task_app/features/quiz/view/widgets/matching_quiz/widgets/matching_controller.dart';
import 'package:flutter_task_app/features/quiz/view/widgets/matching_quiz/widgets/matching_left_column.dart';
import 'package:flutter_task_app/features/quiz/view/widgets/matching_quiz/widgets/matching_right_column.dart';

class MatchingColumns extends StatelessWidget {
  final MatchingController controller;
  final MatchingQuestion question;
  final bool isAnswered;
  final Function(String, bool) onTap;

  const MatchingColumns({
    super.key,
    required this.controller,
    required this.question,
    required this.isAnswered,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          MatchingLeftColumn(
            controller: controller,
            question: question,
            isAnswered: isAnswered,
            onTap: onTap,
          ),
          const SizedBox(width: 40),
          MatchingRightColumn(
            controller: controller,
            question: question,
            isAnswered: isAnswered,
            onTap: onTap,
          ),
        ],
      ),
    );
  }
}