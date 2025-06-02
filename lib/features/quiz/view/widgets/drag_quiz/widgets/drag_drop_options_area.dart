import 'package:flutter/material.dart';
import 'package:flutter_task_app/features/quiz/view/widgets/drag_quiz/widgets/draggable_option_chip.dart';

class DragDropOptionsArea extends StatelessWidget {
  final List<String> options;
  final String? droppedWord;
  final bool isAnswered;
  final Function(String) onWordDragged;

  const DragDropOptionsArea({
    super.key,
    required this.options,
    required this.droppedWord,
    required this.isAnswered,
    required this.onWordDragged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          'Drag the correct word:',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
                color: Colors.blueGrey.shade700,
              ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 24.0),
        Wrap(
          spacing: 12.0,
          runSpacing: 12.0,
          alignment: WrapAlignment.center,
          children: options.map((option) {
            bool isUsed = option == droppedWord;
            bool canDrag = !isAnswered && !isUsed;

            return DraggableOptionChip(
              text: option,
              enabled: canDrag,
              onDrag: () => onWordDragged(option),
            );
          }).toList(),
        ),
      ],
    );
  }
}
