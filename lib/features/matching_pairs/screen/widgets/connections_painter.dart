import 'package:flutter/material.dart';
import 'package:flutter_task_app/features/matching_pairs/model/match_item.dart';

class ConnectionsPainter extends CustomPainter {
  final Map<String, GlobalKey> itemKeys;
  final GlobalKey canvasKey;
  final List<MatchConnection> connections;
  final String? selectedItemId;
  final bool submitted;
  final List<MatchConnection> correctConnections;

  ConnectionsPainter({
    required this.itemKeys,
    required this.canvasKey,
    required this.connections,
    this.selectedItemId,
    required this.submitted,
    required this.correctConnections,
  });

  @override
  void paint(Canvas canvas, Size size) {
    for (var connection in connections) {
      final startOffset = _getCenterOffset(itemKeys[connection.fromId]);
      final endOffset = _getCenterOffset(itemKeys[connection.toId]);

      if (startOffset != null && endOffset != null) {
        _drawConnection(canvas, startOffset, endOffset, connection);
      }
    }
  }

  void _drawConnection(
    Canvas canvas,
    Offset start,
    Offset end,
    MatchConnection connection,
  ) {
    final isCorrect = submitted && correctConnections.contains(connection);
    final isIncorrect = submitted && !correctConnections.contains(connection);

    final paint = Paint()
      ..strokeWidth = submitted ? 4.0 : 3.0
      ..strokeCap = StrokeCap.round;

    if (isCorrect) {
      paint.color = Colors.green.shade600;
      paint.shader = LinearGradient(
        colors: [Colors.green.shade400, Colors.green.shade700],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ).createShader(Rect.fromPoints(start, end));
    } else if (isIncorrect) {
      paint.color = Colors.red.shade600;
      paint.shader = LinearGradient(
        colors: [Colors.red.shade400, Colors.red.shade700],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ).createShader(Rect.fromPoints(start, end));
    } else {
      paint.color = Colors.blue.shade600;
      paint.shader = LinearGradient(
        colors: [Colors.blue.shade400, Colors.blue.shade700],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ).createShader(Rect.fromPoints(start, end));
    }

    final shadowPaint = Paint()
      ..color = Colors.black.withValues(alpha: 0.2)
      ..strokeWidth = paint.strokeWidth + 2
      ..strokeCap = StrokeCap.round;

    canvas.drawLine(
      start + const Offset(2, 2),
      end + const Offset(2, 2),
      shadowPaint,
    );

    canvas.drawLine(start, end, paint);

    _drawConnectionPoint(canvas, start, paint.color);
    _drawConnectionPoint(canvas, end, paint.color);
  }

  void _drawConnectionPoint(Canvas canvas, Offset point, Color color) {
    final paint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;

    canvas.drawCircle(point, 6, paint);

    paint.color = color;
    canvas.drawCircle(point, 4, paint);
  }

  Offset? _getCenterOffset(GlobalKey? key) {
    if (key?.currentContext == null || canvasKey.currentContext == null) {
      return null;
    }

    final itemRenderBox = key!.currentContext!.findRenderObject() as RenderBox;
    final canvasRenderBox =
        canvasKey.currentContext!.findRenderObject() as RenderBox;

    final itemGlobalPosition = itemRenderBox.localToGlobal(Offset.zero);
    final canvasGlobalPosition = canvasRenderBox.localToGlobal(Offset.zero);

    final relativePosition = itemGlobalPosition - canvasGlobalPosition;
    return relativePosition +
        Offset(itemRenderBox.size.width / 2, itemRenderBox.size.height / 2);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
