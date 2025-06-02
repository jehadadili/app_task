import 'package:flutter/material.dart';
import 'package:flutter_task_app/features/quiz/model/multiple_choice_question.dart';
import 'package:flutter_task_app/features/quiz/view/widgets/multiple_quiz/widgets/answer_option_card.dart';

class MultipleChoiceWidget extends StatefulWidget {
  final MultipleChoiceQuestion question;
  final bool isAnswered;
  final Function(String) onAnswerSelected;

  const MultipleChoiceWidget({
    super.key,
    required this.question,
    required this.isAnswered,
    required this.onAnswerSelected,
  });

  @override
  State<MultipleChoiceWidget> createState() => _MultipleChoiceWidgetState();
}

class _MultipleChoiceWidgetState extends State<MultipleChoiceWidget>
    with TickerProviderStateMixin {
  String? selectedAnswer;
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
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
    return FadeTransition(
      opacity: _fadeAnimation,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            widget.question.text,
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 32),
          ...widget.question.options.asMap().entries.map((entry) {
            final index = entry.key;
            final option = entry.value;
            return AnswerOptionCard(
              index: index,
              option: option,
              isSelected: selectedAnswer == option,
              isCorrect: widget.question.correctAnswer == option,
              isAnswered: widget.isAnswered,
              onTap: widget.isAnswered
                  ? null
                  : () {
                      setState(() {
                        selectedAnswer = option;
                      });
                      widget.onAnswerSelected(option);
                    },
            );
          }),
        ],
      ),
    );
  }
}
