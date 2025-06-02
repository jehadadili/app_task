
import 'package:flutter/material.dart';
import 'package:flutter_task_app/features/quiz/model/quiz_result_model.dart';
import 'package:flutter_task_app/features/quiz/view/widgets/quiz_result/widgets/quiz_result_analyzer.dart';
import 'package:flutter_task_app/features/quiz/view/widgets/quiz_result/widgets/quiz_stats_builder.dart';

class ResultContentBuilder {
  final Animation<double> fadeAnimation;
  final QuizResultModel result;
  final QuizResultAnalyzer resultAnalyzer;
  
  ResultContentBuilder({
    required this.fadeAnimation,
    required this.result,
    required this.resultAnalyzer,
  });
  
  Widget build(BuildContext context) {
    final statsBuilder = QuizStatsBuilder(result);
    
    return FadeTransition(
      opacity: fadeAnimation,
      child: Column(
        children: [
          Text(
            resultAnalyzer.resultTitle,
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Colors.grey.shade800,
                ),
          ),
          const SizedBox(height: 16),
          Text(
            'You scored ${resultAnalyzer.percentage.round()}%',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  color: resultAnalyzer.scoreColor,
                  fontWeight: FontWeight.w600,
                ),
          ),
          const SizedBox(height: 32),
          ...statsBuilder.buildStatsCards(),
        ],
      ),
    );
  }
}