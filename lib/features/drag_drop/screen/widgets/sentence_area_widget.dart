import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_task_app/features/drag_drop/cubit/drag_drop_cubit.dart';
import 'package:flutter_task_app/features/drag_drop/cubit/drag_drop_state.dart';
import 'package:flutter_task_app/features/drag_drop/model/sentence_model.dart';

class SentenceAreaWidget extends StatelessWidget {
  final DragDropState state;

  const SentenceAreaWidget({super.key, required this.state});

  @override
  Widget build(BuildContext context) {
    final sentenceData = _getSentenceData();

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        border: Border.all(color: sentenceData.borderColor, width: 2),
        borderRadius: BorderRadius.circular(12.0),
        color: sentenceData.backgroundColor,
      ),
      child: DragTarget<String>(
        onAcceptWithDetails: (details) {
          context.read<DragDropCubit>().answerDropped(details.data);
        },
        builder: (context, candidateData, rejectedData) {
          return RichText(
            text: TextSpan(
              style: const TextStyle(fontSize: 18, color: Colors.black),
              children: [
                const TextSpan(text: 'Flutter is a '),
                TextSpan(
                  text: sentenceData.droppedAnswer.isEmpty
                      ? '_____'
                      : sentenceData.droppedAnswer,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: _getAnswerTextColor(sentenceData),
                    decoration: sentenceData.droppedAnswer.isEmpty
                        ? TextDecoration.underline
                        : TextDecoration.none,
                  ),
                ),
                const TextSpan(text: ' framework.'),
              ],
            ),
          );
        },
      ),
    );
  }

  SentenceModel _getSentenceData() {
    String droppedAnswer = '';
    Color borderColor = Colors.grey;
    Color backgroundColor = Colors.white;

    if (state is DragDropInitial &&
        (state as DragDropInitial).droppedAnswer != null) {
      droppedAnswer = (state as DragDropInitial).droppedAnswer!;
    } else if (state is DragDropAnswerDropped) {
      droppedAnswer = (state as DragDropAnswerDropped).droppedAnswer;
    } else if (state is DragDropIncorrect &&
        (state as DragDropIncorrect).droppedAnswer != null) {
      droppedAnswer = (state as DragDropIncorrect).droppedAnswer!;
      borderColor = Colors.red;
      backgroundColor = Colors.red[50]!;
    }

    return SentenceModel(
      droppedAnswer: droppedAnswer,
      borderColor: borderColor,
      backgroundColor: backgroundColor,
    );
  }

  Color _getAnswerTextColor(SentenceModel data) {
    if (data.droppedAnswer.isEmpty) return Colors.grey;
    return data.borderColor == Colors.red ? Colors.red : Colors.blue;
  }
}
