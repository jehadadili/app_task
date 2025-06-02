
import 'package:flutter/material.dart';
import 'package:flutter_task_app/features/quiz/model/quiz_result_model.dart';
import 'package:flutter_task_app/features/quiz/view/widgets/quiz_result/quiz_result_screen.dart';
import 'package:flutter_task_app/features/quiz/view/widgets/quiz_result/widgets/stat_card_builder.dart';

class QuizStatsBuilder {
  final QuizResultModel result;
  
  QuizStatsBuilder(this.result);
  
  List<Widget> buildStatsCards() {
    final timeFormatter = TimeFormatter();
    final statCardBuilder = StatCardBuilder();
    
    return [
      statCardBuilder.build(
        title: 'Correct Answers',
        value: '${result.totalScore}/${result.totalQuestions}',
        icon: Icons.check_circle,
        color: Colors.green,
      ),
      const SizedBox(height: 16),
      statCardBuilder.build(
        title: 'Total Time',
        value: timeFormatter.format(result.totalTimeTaken),
        icon: Icons.timer,
        color: Colors.blue,
      ),
      const SizedBox(height: 16),
      statCardBuilder.build(
        title: 'Average Time per Question',
        value: timeFormatter.format(result.totalTimeTaken ~/ result.totalQuestions),
        icon: Icons.speed,
        color: Colors.purple,
      ),
    ];
  }
}