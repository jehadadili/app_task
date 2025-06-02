import 'package:flutter/material.dart';
import 'package:flutter_task_app/features/quiz/model/quiz_result_model.dart';
import 'package:flutter_task_app/features/quiz/view/widgets/quiz_result/widgets/action_buttons_builder.dart';
import 'package:flutter_task_app/features/quiz/view/widgets/quiz_result/widgets/animated_result_icon.dart';
import 'package:flutter_task_app/features/quiz/view/widgets/quiz_result/widgets/quiz_result_analyzer.dart';
import 'package:flutter_task_app/features/quiz/view/widgets/quiz_result/widgets/result_content_builder.dart';

class QuizResultScreen extends StatefulWidget {
  final QuizResultModel result;

  const QuizResultScreen({super.key, required this.result});

  @override
  State<QuizResultScreen> createState() => _QuizResultScreenState();
}

class _QuizResultScreenState extends State<QuizResultScreen>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 0.5, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.0, 0.6, curve: Curves.elasticOut),
      ),
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.4, 1.0, curve: Curves.easeIn),
      ),
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final resultAnalyzer = QuizResultAnalyzer(widget.result);
    final animatedResultIcon = AnimatedResultIcon(
      scaleAnimation: _scaleAnimation,
      resultAnalyzer: resultAnalyzer,
    );
    final resultContentBuilder = ResultContentBuilder(
      fadeAnimation: _fadeAnimation,
      result: widget.result,
      resultAnalyzer: resultAnalyzer,
    );
    final actionButtonsBuilder = ActionButtonsBuilder(
      fadeAnimation: _fadeAnimation,
    );

    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    animatedResultIcon.build(),
                    const SizedBox(height: 32),
                    resultContentBuilder.build(context),
                  ],
                ),
              ),
              actionButtonsBuilder.build(context),
            ],
          ),
        ),
      ),
    );
  }
}



class TimeFormatter {
  String format(int seconds) {
    final minutes = seconds ~/ 60;
    final remainingSeconds = seconds % 60;
    return '${minutes}m ${remainingSeconds}s';
  }
}