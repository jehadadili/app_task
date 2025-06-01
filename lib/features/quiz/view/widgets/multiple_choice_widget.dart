import 'package:flutter/material.dart';
import 'package:flutter_task_app/features/quiz/model/multiple_choice_question.dart';

class MultipleChoiceWidget extends StatefulWidget {
  final MultipleChoiceQuestion question;
  final Function(int) onAnswerSelected; 
  final bool answerSubmitted;
  final int? userAnswer; 

  const MultipleChoiceWidget({
    super.key,
    required this.question,
    required this.onAnswerSelected,
    required this.answerSubmitted,
    this.userAnswer,
  });

  @override
  State<MultipleChoiceWidget> createState() => _MultipleChoiceWidgetState();
}

class _MultipleChoiceWidgetState extends State<MultipleChoiceWidget> {
  int? _selectedIndex;

  @override
  void initState() {
    super.initState();
    if (widget.answerSubmitted && widget.userAnswer != null) {
      _selectedIndex = widget.userAnswer;
    }
  }

  @override
  void didUpdateWidget(covariant MultipleChoiceWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.question.id != oldWidget.question.id) {
       _selectedIndex = (widget.answerSubmitted && widget.userAnswer != null) ? widget.userAnswer : null;
    }
    else if (widget.answerSubmitted && !oldWidget.answerSubmitted && widget.userAnswer != null) {
       _selectedIndex = widget.userAnswer;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.question.questionText,
          style: Theme.of(context).textTheme.headlineMedium,
        ),
        const SizedBox(height: 24.0),
        Expanded(
          child: ListView.builder(
            itemCount: widget.question.options.length,
            itemBuilder: (context, index) {
              bool isSelected = _selectedIndex == index;
              bool isCorrect = index == widget.question.correctAnswerIndex;
              Color? tileColor;
              Icon? trailingIcon;

              if (widget.answerSubmitted) {
                if (isSelected) {
                  tileColor = isCorrect ? Colors.green.shade100 : Colors.red.shade100;
                  trailingIcon = Icon(isCorrect ? Icons.check_circle : Icons.cancel, color: isCorrect ? Colors.green : Colors.red);
                } else if (isCorrect) {
                  // Highlight the correct answer if user chose wrong
                  tileColor = Colors.green.shade100;
                  trailingIcon = const Icon(Icons.check_circle, color: Colors.green);
                }
              }

              return Card(
                elevation: isSelected && !widget.answerSubmitted ? 4 : 1,
                color: tileColor,
                margin: const EdgeInsets.symmetric(vertical: 6.0),
                child: ListTile(
                  title: Text(widget.question.options[index]),
                  leading: Radio<int>(
                     value: index,
                     groupValue: _selectedIndex,
                     onChanged: widget.answerSubmitted ? null : (value) {
                       setState(() {
                         _selectedIndex = value;
                       });
                       // Immediately submit the answer upon selection
                       widget.onAnswerSelected(value!);
                     },
                     activeColor: widget.answerSubmitted ? (isCorrect ? Colors.green : Colors.red) : Theme.of(context).primaryColor,
                  ),
                  trailing: widget.answerSubmitted ? trailingIcon : null,
                  onTap: widget.answerSubmitted ? null : () {
                    setState(() {
                      _selectedIndex = index;
                    });
                     widget.onAnswerSelected(index);
                  },
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
