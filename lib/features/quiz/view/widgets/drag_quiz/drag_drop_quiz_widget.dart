import 'package:flutter/material.dart';
import 'package:flutter_task_app/features/quiz/model/drag_drop_quiz_question.dart';
import 'package:flutter_task_app/features/quiz/view/widgets/drag_quiz/widgets/drag_drop_options_area.dart';
import 'package:flutter_task_app/features/quiz/view/widgets/drag_quiz/widgets/question_text_with_drop_target.dart';

class DragDropWidget extends StatefulWidget {
  final FillBlankDragDropQuestion question;
  final bool isAnswered;
  final Function(String?) onAnswerSelected;

  const DragDropWidget({
    super.key,
    required this.question,
    required this.isAnswered,
    required this.onAnswerSelected,
  });

  @override
  State<DragDropWidget> createState() => _DragDropWidgetState();
}

class _DragDropWidgetState extends State<DragDropWidget> {
  String? _droppedWord;

  void _handleAnswerSelected(String? word) {
    setState(() {
      _droppedWord = word;
    });
    widget.onAnswerSelected(word);
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(16.0),
              margin: const EdgeInsets.only(bottom: 32.0),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12.0),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withValues(alpha: 0.15),
                    spreadRadius: 2,
                    blurRadius: 5,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: QuestionTextWithDropTarget(
                question: widget.question,
                droppedWord: _droppedWord,
                isAnswered: widget.isAnswered,
                onWordDropped: _handleAnswerSelected,
              ),
            ),

            DragDropOptionsArea(
              options: widget.question.options,
              droppedWord: _droppedWord,
              isAnswered: widget.isAnswered,
              onWordDragged: _handleAnswerSelected,
            ),
          ],
        ),
      ),
    );
  }
}
