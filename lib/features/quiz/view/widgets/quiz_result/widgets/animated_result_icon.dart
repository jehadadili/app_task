
import 'package:flutter/material.dart';
import 'package:flutter_task_app/features/quiz/view/widgets/quiz_result/widgets/quiz_result_analyzer.dart';

class AnimatedResultIcon {
  final Animation<double> scaleAnimation;
  final QuizResultAnalyzer resultAnalyzer;
  
  AnimatedResultIcon({
    required this.scaleAnimation,
    required this.resultAnalyzer,
  });
  
  Widget build() {
    return ScaleTransition(
      scale: scaleAnimation,
      child: Container(
        width: 120,
        height: 120,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: LinearGradient(
            colors: resultAnalyzer.gradientColors,
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          boxShadow: [
            BoxShadow(
              color: resultAnalyzer.shadowColor.withValues(alpha: 0.3),
              blurRadius: 20,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Icon(
          resultAnalyzer.resultIcon,
          size: 60,
          color: Colors.white,
        ),
      ),
    );
  }
}
