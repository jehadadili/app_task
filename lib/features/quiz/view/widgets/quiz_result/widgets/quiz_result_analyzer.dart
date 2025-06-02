
import 'package:flutter/material.dart';
import 'package:flutter_task_app/features/quiz/model/quiz_result_model.dart';

class QuizResultAnalyzer {
  final QuizResultModel result;
  
  QuizResultAnalyzer(this.result);
  
  double get percentage => result.percentage;
  bool get isExcellent => percentage >= 80;
  bool get isGood => percentage >= 60;
  
  String get resultTitle {
    if (isExcellent) return 'Excellent!';
    if (isGood) return 'Good Job!';
    return 'Keep Trying!';
  }
  
  IconData get resultIcon {
    if (isExcellent) return Icons.emoji_events;
    if (isGood) return Icons.thumb_up;
    return Icons.refresh;
  }
  
  List<Color> get gradientColors {
    if (isExcellent) return [Colors.green.shade400, Colors.green.shade600];
    if (isGood) return [Colors.orange.shade400, Colors.orange.shade600];
    return [Colors.red.shade400, Colors.red.shade600];
  }
  
  Color get shadowColor {
    if (isExcellent) return Colors.green;
    if (isGood) return Colors.orange;
    return Colors.red;
  }
  
  Color get scoreColor {
    if (isExcellent) return Colors.green.shade600;
    if (isGood) return Colors.orange.shade600;
    return Colors.red.shade600;
  }
}
