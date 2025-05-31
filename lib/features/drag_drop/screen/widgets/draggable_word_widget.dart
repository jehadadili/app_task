import 'package:flutter/material.dart';

class DraggableWordWidget extends StatelessWidget {
  final String word;

  const DraggableWordWidget({
    super.key,
    required this.word,
  });

  @override
  Widget build(BuildContext context) {
    return Draggable<String>(
      data: word,
      feedback: _buildFeedbackWidget(),
      childWhenDragging: _buildDraggedWidget(),
      child: _buildNormalWidget(),
    );
  }

  Widget _buildFeedbackWidget() {
    return Material(
      elevation: 6.0,
      borderRadius: BorderRadius.circular(8.0),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: Colors.blueAccent,
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: Text(
          word,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget _buildDraggedWidget() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.grey[300],
        borderRadius: BorderRadius.circular(8.0),
        border: Border.all(color: Colors.grey),
      ),
      child: Text(
        word,
        style: const TextStyle(
          color: Colors.black38,
          fontSize: 16,
        ),
      ),
    );
  }

  Widget _buildNormalWidget() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.blue[100],
        borderRadius: BorderRadius.circular(8.0),
        border: Border.all(color: Colors.blue[300]!),
      ),
      child: Text(
        word,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}

