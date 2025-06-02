
import 'package:flutter/material.dart';
import 'package:flutter_task_app/features/quiz/model/multiple_choice_question.dart';

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
            final isSelected = selectedAnswer == option;
            final isCorrect = widget.question.correctAnswer == option;
            
            Color cardColor = Colors.white;
            Color borderColor = Colors.grey.shade300;
            
            if (widget.isAnswered) {
              if (isCorrect) {
                cardColor = Colors.green.shade50;
                borderColor = Colors.green;
              } else if (isSelected && !isCorrect) {
                cardColor = Colors.red.shade50;
                borderColor = Colors.red;
              }
            } else if (isSelected) {
              cardColor = Colors.blue.shade50;
              borderColor = Colors.blue;
            }

            return AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              margin: const EdgeInsets.only(bottom: 12),
              child: Material(
                elevation: isSelected ? 4 : 1,
                borderRadius: BorderRadius.circular(12),
                child: InkWell(
                  borderRadius: BorderRadius.circular(12),
                  onTap: widget.isAnswered
                      ? null
                      : () {
                          setState(() {
                            selectedAnswer = option;
                          });
                          widget.onAnswerSelected(option);
                        },
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: cardColor,
                      border: Border.all(color: borderColor, width: 2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 32,
                          height: 32,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: borderColor,
                          ),
                          child: Center(
                            child: Text(
                              String.fromCharCode(65 + index), // A, B, C, D
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Text(
                            option,
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                            ),
                          ),
                        ),
                        if (widget.isAnswered && isCorrect)
                          const Icon(Icons.check_circle, color: Colors.green),
                        if (widget.isAnswered && isSelected && !isCorrect)
                          const Icon(Icons.cancel, color: Colors.red),
                      ],
                    ),
                  ),
                ),
              ),
            );
          }).toList(),
        ],
      ),
    );
  }
}