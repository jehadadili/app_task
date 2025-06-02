
import 'package:flutter/material.dart';
import 'package:flutter_task_app/features/quiz/model/matching_quiz_question.dart';

class MatchingAnimationController {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;

  Animation<double> get scaleAnimation => _scaleAnimation;

  MatchingAnimationController(TickerProvider vsync) {
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: vsync,
    );
    _scaleAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.elasticOut),
    );
  }

  void startAnimation() {
    _animationController.forward();
  }

  void dispose() {
    _animationController.dispose();
  }
}

class MatchingHeader extends StatelessWidget {
  final MatchingQuestion question;

  const MatchingHeader({
    super.key,
    required this.question,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: Text(
        question.text,
        style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
        textAlign: TextAlign.center,
      ),
    );
  }
}
