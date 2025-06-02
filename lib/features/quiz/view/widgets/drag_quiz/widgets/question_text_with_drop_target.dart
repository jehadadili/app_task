import 'package:flutter/material.dart';
import 'package:flutter_task_app/features/quiz/model/drag_drop_quiz_question.dart';

class QuestionTextWithDropTarget extends StatelessWidget {
  final FillBlankDragDropQuestion question;
  final String? droppedWord;
  final bool isAnswered;
  final Function(String?) onWordDropped;

  const QuestionTextWithDropTarget({
    super.key,
    required this.question,
    required this.droppedWord,
    required this.isAnswered,
    required this.onWordDropped,
  });

  @override
  Widget build(BuildContext context) {
    final textStyle = Theme.of(context).textTheme.headlineMedium?.copyWith(
          fontWeight: FontWeight.w500,
          color: Colors.black87,
          height: 1.4,
        );
    const blankPlaceholder = '____';
    List<String> parts = question.text.split(blankPlaceholder);

    if (parts.length != 2) {
      return Text(question.text, style: textStyle, textAlign: TextAlign.center);
    }

    bool isCorrect = isAnswered && droppedWord == question.correctAnswer;

    final blankTextStyle = textStyle?.copyWith(
      fontWeight: FontWeight.bold,
      color: droppedWord == null ? Colors.grey.shade500 : Colors.deepPurple.shade700,
    );

    return RichText(
      textAlign: TextAlign.center,
      text: TextSpan(
        style: textStyle,
        children: [
          TextSpan(text: parts[0]),
          WidgetSpan(
            alignment: PlaceholderAlignment.bottom,
            child: DragTarget<String>(
              builder: (context, candidateData, rejectedData) {
                bool isHovering = candidateData.isNotEmpty;
                return Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  margin: const EdgeInsets.symmetric(horizontal: 6),
                  decoration: BoxDecoration(
                    color: isHovering
                        ? Colors.lightGreen.shade100
                        : droppedWord != null
                            ? (isAnswered
                                ? (isCorrect ? Colors.green.shade50 : Colors.red.shade50)
                                : Colors.orange.shade50)
                            : Colors.grey.shade200,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: isHovering
                          ? Colors.green.shade400
                          : droppedWord != null
                              ? (isAnswered
                                  ? (isCorrect ? Colors.green.shade400 : Colors.red.shade400)
                                  : Colors.orange.shade400)
                              : Colors.grey.shade400,
                      width: 2,
                    ),
                    boxShadow: isHovering || (droppedWord != null && !isAnswered)
                        ? [
                            BoxShadow(
                              color: Colors.grey.withValues(alpha: 0.3),
                              spreadRadius: 1,
                              blurRadius: 3,
                              offset: const Offset(0, 1),
                            )
                          ]
                        : [],
                  ),
                  constraints: const BoxConstraints(minWidth: 100),
                  child: Text(
                    droppedWord ?? blankPlaceholder,
                    style: blankTextStyle,
                  ),
                );
              },
              onWillAcceptWithDetails: (details) => !isAnswered,
              onAcceptWithDetails: (details) {
                if (!isAnswered) {
                  onWordDropped(details.data);
                }
              },
            ),
          ),
          TextSpan(text: parts[1]),
        ],
      ),
    );
  }
}
