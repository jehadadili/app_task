import 'package:flutter/material.dart';
import 'package:flutter_task_app/features/drag_drop/cubit/drag_drop_state.dart';
import 'draggable_word_widget.dart';

class DragOptionsWidget extends StatelessWidget {
  final DragDropState state;
  
  static const List<String> _options = ['React', 'mobile', 'cross-platform', 'native'];

  const DragOptionsWidget({
    super.key,
    required this.state,
  });

  @override
  Widget build(BuildContext context) {
    if (state is DragDropCorrect) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Drag the correct word:',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 15),
        Wrap(
          spacing: 12.0,
          runSpacing: 12.0,
          children: _options
              .map((word) => DraggableWordWidget(word: word))
              .toList(),
        ),
      ],
    );
  }
}