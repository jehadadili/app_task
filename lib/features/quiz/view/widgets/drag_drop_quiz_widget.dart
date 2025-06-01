import 'package:flutter/material.dart';
import 'package:flutter_task_app/features/quiz/model/drag_drop_quiz_question.dart';

class DragDropQuizWidget extends StatefulWidget {
  final DragDropQuizQuestion question;
  final Function(String) onAnswerDropped; 
  final bool answerSubmitted;
  final String? userAnswer; 

  const DragDropQuizWidget({
    super.key,
    required this.question,
    required this.onAnswerDropped,
    required this.answerSubmitted,
    this.userAnswer,
  });

  @override
  State<DragDropQuizWidget> createState() => _DragDropQuizWidgetState();
}

class _DragDropQuizWidgetState extends State<DragDropQuizWidget> {
  String? _droppedAnswer;

  @override
  void initState() {
    super.initState();
    if (widget.answerSubmitted && widget.userAnswer != null) {
      _droppedAnswer = widget.userAnswer;
    }
  }

  @override
  void didUpdateWidget(covariant DragDropQuizWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Reset local state if the question changes
    if (widget.question.id != oldWidget.question.id) {
      _droppedAnswer = (widget.answerSubmitted && widget.userAnswer != null) ? widget.userAnswer : null;
    } 
    // Update if answer becomes submitted while widget is visible
    else if (widget.answerSubmitted && !oldWidget.answerSubmitted && widget.userAnswer != null) {
       _droppedAnswer = widget.userAnswer;
    }
  }

  @override
  Widget build(BuildContext context) {
    final sentenceParts = widget.question.sentenceTemplate.split('_____');
    final bool isCorrect = widget.answerSubmitted && (_droppedAnswer == widget.question.correctAnswer);

    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // Sentence with Drop Target
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 32.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(sentenceParts[0], style: Theme.of(context).textTheme.headlineSmall),
              DragTarget<String>(
                builder: (context, candidateData, rejectedData) {
                  Color borderColor = Colors.grey;
                  Color bgColor = Colors.grey.shade200;
                  Color textColor = Colors.grey;

                  if (widget.answerSubmitted) {
                    borderColor = isCorrect ? Colors.green : Colors.red;
                    bgColor = isCorrect ? Colors.green.shade100 : Colors.red.shade100;
                    textColor = Colors.black;
                  } else if (_droppedAnswer != null) {
                    borderColor = Colors.blue;
                    bgColor = Colors.blue.shade100;
                    textColor = Colors.black;
                  } else if (candidateData.isNotEmpty) {
                     bgColor = Colors.lightBlue.shade100;
                  }

                  return Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
                    margin: const EdgeInsets.symmetric(horizontal: 8.0),
                    decoration: BoxDecoration(
                      border: Border.all(color: borderColor, width: 2),
                      borderRadius: BorderRadius.circular(8.0),
                      color: bgColor,
                    ),
                    constraints: const BoxConstraints(minWidth: 120),
                    child: Text(
                      _droppedAnswer ?? '______',
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                            color: textColor,
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                  );
                },
                onWillAcceptWithDetails: (data) => !widget.answerSubmitted,
                onAcceptWithDetails: (data) {
                  if (!widget.answerSubmitted) {
                     setState(() {
                       _droppedAnswer = data.data;
                     });
                     widget.onAnswerDropped(data.data);
                  }
                },
              ),
              if (sentenceParts.length > 1)
                Text(sentenceParts[1], style: Theme.of(context).textTheme.headlineSmall),
            ],
          ),
        ),

        Wrap(
          spacing: 16.0,
          runSpacing: 16.0,
          alignment: WrapAlignment.center,
          children: widget.question.draggableOptions.map((option) {
            if (_droppedAnswer == option) {
              return const SizedBox.shrink();
            }

            return Draggable<String>(
              data: option,
              feedback: Material(
                elevation: 4.0,
                child: Chip(label: Text(option), padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12)),
              ),
              childWhenDragging: Chip(
                  label: Text(option),
                  backgroundColor: Colors.grey.shade400,
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12)
              ),
              child: widget.answerSubmitted
                  ? Chip(
                      label: Text(option),
                      backgroundColor: Colors.grey.shade300,
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    )
                  : Chip(
                      label: Text(option),
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      elevation: 2.0,
                    ),
            );
          }).toList(),
        ),
        const SizedBox(height: 20), // Spacer
      ],
    );
  }
}
