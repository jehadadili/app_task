
import 'package:flutter/material.dart';
import 'package:flutter_task_app/features/quiz/view/widgets/quiz_result/widgets/primary_action_button.dart';
import 'package:flutter_task_app/features/quiz/view/widgets/quiz_result/widgets/second_ary_action_button.dart';

class ActionButtonsBuilder {
  final Animation<double> fadeAnimation;
  
  ActionButtonsBuilder({required this.fadeAnimation});
  
  Widget build(BuildContext context) {
    final primaryButton = PrimaryActionButton();
    final secondaryButton = SecondaryActionButton();
    
    return FadeTransition(
      opacity: fadeAnimation,
      child: Column(
        children: [
          primaryButton.build(context),
          const SizedBox(height: 16),
          secondaryButton.build(context),
        ],
      ),
    );
  }
}
