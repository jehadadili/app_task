

import 'package:flutter/material.dart';
import 'package:flutter_task_app/features/quiz/model/matching_quiz_question.dart';
import 'package:flutter_task_app/features/quiz/view/widgets/matching_quiz/widgets/connection_line_painter.dart';
import 'package:flutter_task_app/features/quiz/view/widgets/matching_quiz/widgets/matching_controller.dart';

class MatchingConnectionLines extends StatelessWidget {
  final MatchingController controller;
  final MatchingQuestion question;
  final bool isAnswered;

  const MatchingConnectionLines({
    super.key,
    required this.controller,
    required this.question,
    required this.isAnswered,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        CustomPaint(
          painter: ConnectionLinePainter(
            matches: controller.userMatches,
            leftKeys: controller.leftKeys,
            rightKeys: controller.rightKeys,
            correctMatches: question.correctMatches,
            isAnswered: isAnswered,
            lineStartPoint: null,
            lineEndPoint: null,
          ),
          child: Container(),
        ),
        if (controller.lineStartPoint != null && controller.lineEndPoint != null)
          CustomPaint(
            painter: ConnectionLinePainter(
              matches: const {},
              leftKeys: controller.leftKeys,
              rightKeys: controller.rightKeys,
              correctMatches: const {},
              isAnswered: false,
              lineStartPoint: controller.lineStartPoint,
              lineEndPoint: controller.lineEndPoint,
            ),
            child: Container(),
          ),
      ],
    );
  }
}
