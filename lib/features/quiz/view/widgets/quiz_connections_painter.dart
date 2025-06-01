
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_task_app/features/quiz/view/widgets/matching_quiz_widget.dart';

class QuizConnectionsPainter extends CustomPainter {
  final Map<String, GlobalKey> itemKeys;
  final List<QuizMatchConnection> connections;
  final String? selectedItemId;
  final bool submitted;
  final Map<String, String> correctPairs;

  QuizConnectionsPainter({
    required this.itemKeys,
    required this.connections,
    this.selectedItemId,
    required this.submitted,
    required this.correctPairs,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..strokeWidth = 2.0;

    for (var connection in connections) {
      final startOffset = _getCenterOffset(itemKeys[connection.fromId]);
      final endOffset = _getCenterOffset(itemKeys[connection.toId]);

      if (startOffset != null && endOffset != null) {
        bool isConnectionCorrect = false;
        if (correctPairs[connection.fromId] == connection.toId || correctPairs[connection.toId] == connection.fromId) {
           isConnectionCorrect = true;
        }

        if (submitted) {
          paint.color = isConnectionCorrect ? Colors.green : Colors.red;
          paint.strokeWidth = 3.0;
        } else {
          paint.color = Colors.blue;
          paint.strokeWidth = 2.0;
        }
        canvas.drawLine(startOffset, endOffset, paint);
      }
    }

    if (selectedItemId != null && !submitted) {
       final startPoint = _getCenterOffset(itemKeys[selectedItemId]);
       if (startPoint != null) {
        
       }
    }
  }

  Offset? _getCenterOffset(GlobalKey? key) {
    if (key?.currentContext == null) return null;
    try {
       final RenderBox renderBox = key?.currentContext!.findRenderObject() as RenderBox;
       final position = renderBox.localToGlobal(Offset.zero);
     
       return position + Offset(renderBox.size.width / 2, renderBox.size.height / 2);
    } catch (e) {
       log("Error getting offset for key: $e");
       return null;
    }

  }

  @override
  bool shouldRepaint(covariant QuizConnectionsPainter oldDelegate) {
    return oldDelegate.connections != connections ||
           oldDelegate.selectedItemId != selectedItemId ||
           oldDelegate.submitted != submitted;
  }
}
