
import 'package:flutter/material.dart';
import 'package:flutter_task_app/features/quiz/model/matching_quiz_question.dart';
import 'package:flutter_task_app/features/quiz/view/widgets/matching_quiz/widgets/matching_columns.dart';
import 'package:flutter_task_app/features/quiz/view/widgets/matching_quiz/widgets/matching_connection_lines.dart';
import 'package:flutter_task_app/features/quiz/view/widgets/matching_quiz/widgets/matching_controller.dart';

class MatchingContent extends StatelessWidget {
  final MatchingController controller;
  final MatchingQuestion question;
  final bool isAnswered;
  final Function(String, bool) onTap;

  const MatchingContent({
    super.key,
    required this.controller,
    required this.question,
    required this.isAnswered,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        MatchingConnectionLines(
          controller: controller,
          question: question,
          isAnswered: isAnswered,
        ),
        MatchingColumns(
          controller: controller,
          question: question,
          isAnswered: isAnswered,
          onTap: onTap,
        ),
      ],
    );
  }
}
