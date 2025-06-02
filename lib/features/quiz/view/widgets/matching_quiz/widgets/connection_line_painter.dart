import 'package:flutter/material.dart';

class ConnectionLinePainter extends CustomPainter {
  final Map<String, String> matches;
  final Map<String, GlobalKey> leftKeys;
  final Map<String, GlobalKey> rightKeys;
  final Map<String, String> correctMatches;
  final bool isAnswered;
  final Offset? lineStartPoint;
  final Offset? lineEndPoint;

  ConnectionLinePainter({
    required this.matches,
    required this.leftKeys,
    required this.rightKeys,
    required this.correctMatches,
    required this.isAnswered,
    this.lineStartPoint,
    this.lineEndPoint,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (lineStartPoint != null && lineEndPoint != null) {
      final paint = Paint()
        ..color = Colors.blueGrey
        ..strokeWidth = 2.5
        ..style = PaintingStyle.stroke
        ..strokeCap = StrokeCap.round;
      canvas.drawLine(lineStartPoint!, lineEndPoint!, paint);
      final startCirclePaint = Paint()..color = Colors.blueGrey;
      canvas.drawCircle(lineStartPoint!, 4, startCirclePaint);
    }

    matches.forEach((leftItem, rightItem) {
      final leftKey = leftKeys[leftItem];
      final rightKey = rightKeys[rightItem];

      if (leftKey?.currentContext != null && rightKey?.currentContext != null) {
        final leftRenderBox =
            leftKey!.currentContext!.findRenderObject() as RenderBox;
        final rightRenderBox =
            rightKey!.currentContext!.findRenderObject() as RenderBox;

        final RenderBox? customPaintBox = leftKey.currentContext
            ?.findAncestorRenderObjectOfType<RenderBox>();
        final Offset customPaintOffset = customPaintBox != null
            ? customPaintBox.localToGlobal(Offset.zero)
            : Offset.zero;

        final leftPosition =
            leftRenderBox.localToGlobal(Offset.zero) - customPaintOffset;
        final rightPosition =
            rightRenderBox.localToGlobal(Offset.zero) - customPaintOffset;

        final startPoint = Offset(
          leftPosition.dx + leftRenderBox.size.width,
          leftPosition.dy + leftRenderBox.size.height / 2,
        );
        final endPoint = Offset(
          rightPosition.dx,
          rightPosition.dy + rightRenderBox.size.height / 2,
        );

        Color lineColor;
        if (isAnswered) {
          final isCorrect = correctMatches[leftItem] == rightItem;
          lineColor = isCorrect ? Colors.green.shade400 : Colors.red.shade400;
        } else {
          lineColor = Colors.orange.shade400;
        }

        final paint = Paint()
          ..color = lineColor
          ..strokeWidth = 3
          ..style = PaintingStyle.stroke
          ..strokeCap = StrokeCap.round;

        canvas.drawLine(startPoint, endPoint, paint);

        final pointPaint = Paint()..color = lineColor;
        canvas.drawCircle(startPoint, 5, pointPaint);
        canvas.drawCircle(endPoint, 5, pointPaint);
      }
    });
  }

  @override
  bool shouldRepaint(ConnectionLinePainter oldDelegate) {
    return oldDelegate.matches != matches ||
        oldDelegate.isAnswered != isAnswered ||
        oldDelegate.lineStartPoint != lineStartPoint ||
        oldDelegate.lineEndPoint != lineEndPoint;
  }
}
