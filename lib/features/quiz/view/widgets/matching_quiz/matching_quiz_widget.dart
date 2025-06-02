import 'package:flutter/material.dart';
import 'package:flutter_task_app/features/quiz/model/matching_quiz_question.dart';

import 'package:flutter_task_app/features/quiz/view/widgets/matching_quiz/widgets/matching_animation_controller.dart';
import 'package:flutter_task_app/features/quiz/view/widgets/matching_quiz/widgets/matching_content.dart';
import 'package:flutter_task_app/features/quiz/view/widgets/matching_quiz/widgets/matching_controller.dart';

class MatchingWidget extends StatefulWidget {
  final MatchingQuestion question;
  final bool isAnswered;
  final Function(Map<String, String>) onAnswerSelected;

  const MatchingWidget({
    super.key,
    required this.question,
    required this.isAnswered,
    required this.onAnswerSelected,
  });

  @override
  State<MatchingWidget> createState() => _MatchingWidgetState();
}

class _MatchingWidgetState extends State<MatchingWidget>
    with TickerProviderStateMixin {
  late MatchingController _controller;
  late MatchingAnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _controller = MatchingController(
      question: widget.question,
      onAnswerSelected: widget.onAnswerSelected,
    );
    _animationController = MatchingAnimationController(this);
    _animationController.startAnimation();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Listener(
      onPointerMove: (event) {
        _controller.handlePointerMove(event, setState);
      },
      child: ScaleTransition(
        scale: _animationController.scaleAnimation,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            MatchingHeader(question: widget.question),
            Expanded(
              child: MatchingContent(
                controller: _controller,
                question: widget.question,
                isAnswered: widget.isAnswered,
                onTap: (item, isLeft) => _controller.handleTap(
                  item,
                  isLeft,
                  widget.isAnswered,
                  setState,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
