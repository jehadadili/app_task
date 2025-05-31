import 'package:flutter/material.dart';
import 'package:flutter_task_app/features/drag_drop/cubit/drag_drop_state.dart';

class ResultMessageWidget extends StatelessWidget {
  final DragDropState state;

  const ResultMessageWidget({
    super.key,
    required this.state,
  });

  @override
  Widget build(BuildContext context) {
    if (state is DragDropCorrect) {
      return _buildSuccessMessage(state as DragDropCorrect);
    } else if (state is DragDropIncorrect) {
      return _buildErrorMessage(state as DragDropIncorrect);
    }
    return const SizedBox.shrink();
  }

  Widget _buildSuccessMessage(DragDropCorrect state) {
    return _buildMessageContainer(
      message: state.message,
      backgroundColor: Colors.green[100]!,
      borderColor: Colors.green,
      textColor: Colors.green,
      icon: Icons.check_circle,
    );
  }

  Widget _buildErrorMessage(DragDropIncorrect state) {
    return _buildMessageContainer(
      message: state.message,
      backgroundColor: Colors.red[100]!,
      borderColor: Colors.red,
      textColor: Colors.red,
      icon: Icons.error,
    );
  }

  Widget _buildMessageContainer({
    required String message,
    required Color backgroundColor,
    required Color borderColor,
    required Color textColor,
    required IconData icon,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: borderColor),
      ),
      child: Row(
        children: [
          Icon(icon, color: textColor, size: 24),
          const SizedBox(width: 8),
          Text(
            message,
            style: TextStyle(
              color: textColor,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}