import 'package:flutter/material.dart';
import 'package:flutter_task_app/features/quiz/model/matching_quiz_question.dart';

class MatchingWidget extends StatefulWidget {
  final MatchingQuestion question;
  final bool isAnswered;
  final Function(Map<String, String>) onAnswerSelected;

  const MatchingWidget({
    super.key,
    required this.question,
    required this.isAnswered,
    required this.onAnswerSelected,
  });

  @override
  State<MatchingWidget> createState() => _MatchingWidgetState();
}

class _MatchingWidgetState extends State<MatchingWidget>
    with TickerProviderStateMixin {
  Map<String, String> userMatches = {};
  String? selectedLeft;
  String? selectedRight;
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  
  // مفاتيح للعناصر لتتبع مواقعها
  final Map<String, GlobalKey> _leftKeys = {};
  final Map<String, GlobalKey> _rightKeys = {};

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.elasticOut),
    );
    _animationController.forward();
    
    // إنشاء مفاتيح للعناصر
    for (String item in widget.question.leftItems) {
      _leftKeys[item] = GlobalKey();
    }
    for (String item in widget.question.rightItems) {
      _rightKeys[item] = GlobalKey();
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _handleTap(String item, bool isLeft) {
    if (widget.isAnswered) return;

    setState(() {
      if (isLeft) {
        if (selectedLeft == item) {
          selectedLeft = null;
        } else {
          selectedLeft = item;
          selectedRight = null;
        }
      } else {
        if (selectedRight == item) {
          selectedRight = null;
        } else {
          selectedRight = item;
          selectedLeft = null;
        }
      }

      // إذا تم اختيار عنصرين، أنشئ مطابقة
      if (selectedLeft != null && selectedRight != null) {
        // إزالة أي مطابقة سابقة لهذين العنصرين
        userMatches.removeWhere((key, value) => key == selectedLeft || value == selectedRight);
        userMatches[selectedLeft!] = selectedRight!;
        selectedLeft = null;
        selectedRight = null;
        widget.onAnswerSelected(userMatches);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: _scaleAnimation,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            widget.question.text,
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 32),
          Stack(
            children: [
              // خطوط الربط
              if (userMatches.isNotEmpty)
                CustomPaint(
                  painter: ConnectionLinePainter(
                    matches: userMatches,
                    leftKeys: _leftKeys,
                    rightKeys: _rightKeys,
                    correctMatches: widget.question.correctMatches,
                    isAnswered: widget.isAnswered,
                  ),
                  child: Container(),
                ),
              // المحتوى الرئيسي
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Text(
                          'اربط هذه العناصر:',
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.w600,
                                color: Colors.blue.shade700,
                              ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 16),
                        ...widget.question.leftItems.map((item) {
                          final isSelected = selectedLeft == item;
                          final isMatched = userMatches.containsKey(item);
                          final matchedWith = userMatches[item];
                          final isCorrect = widget.isAnswered && 
                              widget.question.correctMatches[item] == matchedWith;

                          return Padding(
                            key: _leftKeys[item],
                            padding: const EdgeInsets.only(bottom: 12),
                            child: GestureDetector(
                              onTap: () => _handleTap(item, true),
                              child: AnimatedContainer(
                                duration: const Duration(milliseconds: 300),
                                padding: const EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                  color: isSelected
                                      ? Colors.blue.shade100
                                      : isMatched
                                          ? (widget.isAnswered
                                              ? (isCorrect ? Colors.green.shade50 : Colors.red.shade50)
                                              : Colors.orange.shade50)
                                          : Colors.grey.shade50,
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(
                                    color: isSelected
                                        ? Colors.blue
                                        : isMatched
                                            ? (widget.isAnswered
                                                ? (isCorrect ? Colors.green : Colors.red)
                                                : Colors.orange)
                                            : Colors.grey.shade300,
                                    width: isSelected ? 3 : 2,
                                  ),
                                  boxShadow: isSelected ? [
                                    BoxShadow(
                                      color: Colors.blue.shade200,
                                      blurRadius: 8,
                                      offset: const Offset(0, 4),
                                    ),
                                  ] : null,
                                ),
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: Text(
                                        item,
                                        style: const TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ),
                                    if (widget.isAnswered && isMatched)
                                      Icon(
                                        isCorrect ? Icons.check_circle : Icons.cancel,
                                        color: isCorrect ? Colors.green : Colors.red,
                                        size: 24,
                                      ),
                                    if (isSelected)
                                      const Icon(
                                        Icons.radio_button_checked,
                                        color: Colors.blue,
                                        size: 20,
                                      )
                                    else if (!isMatched)
                                      Icon(
                                        Icons.radio_button_unchecked,
                                        color: Colors.grey.shade400,
                                        size: 20,
                                      ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        }).toList(),
                      ],
                    ),
                  ),
                  Container(
                    width: 3,
                    height: 250,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.blue.shade200,
                          Colors.purple.shade200,
                          Colors.blue.shade200,
                        ],
                      ),
                      borderRadius: BorderRadius.circular(2),
                    ),
                    margin: const EdgeInsets.symmetric(horizontal: 20),
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Text(
                          'مع هذه:',
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.w600,
                                color: Colors.purple.shade700,
                              ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 16),
                        ...widget.question.rightItems.map((item) {
                          final isSelected = selectedRight == item;
                          final isMatched = userMatches.containsValue(item);
                          final matchedWith = userMatches.entries
                              .where((entry) => entry.value == item)
                              .map((entry) => entry.key)
                              .firstOrNull;
                          final isCorrect = widget.isAnswered && 
                              matchedWith != null &&
                              widget.question.correctMatches[matchedWith] == item;

                          return Padding(
                            key: _rightKeys[item],
                            padding: const EdgeInsets.only(bottom: 12),
                            child: GestureDetector(
                              onTap: () => _handleTap(item, false),
                              child: AnimatedContainer(
                                duration: const Duration(milliseconds: 300),
                                padding: const EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                  color: isSelected
                                      ? Colors.purple.shade100
                                      : isMatched
                                          ? (widget.isAnswered
                                              ? (isCorrect ? Colors.green.shade50 : Colors.red.shade50)
                                              : Colors.orange.shade50)
                                          : Colors.grey.shade50,
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(
                                    color: isSelected
                                        ? Colors.purple
                                        : isMatched
                                            ? (widget.isAnswered
                                                ? (isCorrect ? Colors.green : Colors.red)
                                                : Colors.orange)
                                            : Colors.grey.shade300,
                                    width: isSelected ? 3 : 2,
                                  ),
                                  boxShadow: isSelected ? [
                                    BoxShadow(
                                      color: Colors.purple.shade200,
                                      blurRadius: 8,
                                      offset: const Offset(0, 4),
                                    ),
                                  ] : null,
                                ),
                                child: Row(
                                  children: [
                                    if (isSelected)
                                      const Icon(
                                        Icons.radio_button_checked,
                                        color: Colors.purple,
                                        size: 20,
                                      )
                                    else if (!isMatched)
                                      Icon(
                                        Icons.radio_button_unchecked,
                                        color: Colors.grey.shade400,
                                        size: 20,
                                      ),
                                    if (widget.isAnswered && isMatched)
                                      Icon(
                                        isCorrect ? Icons.check_circle : Icons.cancel,
                                        color: isCorrect ? Colors.green : Colors.red,
                                        size: 24,
                                      ),
                                    const SizedBox(width: 8),
                                    Expanded(
                                      child: Text(
                                        item,
                                        style: const TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        }).toList(),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// رسام مخصص لخطوط الربط
class ConnectionLinePainter extends CustomPainter {
  final Map<String, String> matches;
  final Map<String, GlobalKey> leftKeys;
  final Map<String, GlobalKey> rightKeys;
  final Map<String, String> correctMatches;
  final bool isAnswered;

  ConnectionLinePainter({
    required this.matches,
    required this.leftKeys,
    required this.rightKeys,
    required this.correctMatches,
    required this.isAnswered,
  });

  @override
  void paint(Canvas canvas, Size size) {
    matches.forEach((leftItem, rightItem) {
      final leftKey = leftKeys[leftItem];
      final rightKey = rightKeys[rightItem];
      
      if (leftKey?.currentContext != null && rightKey?.currentContext != null) {
        final leftRenderBox = leftKey!.currentContext!.findRenderObject() as RenderBox;
        final rightRenderBox = rightKey!.currentContext!.findRenderObject() as RenderBox;
        
        final leftPosition = leftRenderBox.localToGlobal(Offset.zero);
        final rightPosition = rightRenderBox.localToGlobal(Offset.zero);
        
        // تحديد نقاط البداية والنهاية
        final startPoint = Offset(
          leftPosition.dx + leftRenderBox.size.width,
          leftPosition.dy + leftRenderBox.size.height / 2,
        );
        final endPoint = Offset(
          rightPosition.dx,
          rightPosition.dy + rightRenderBox.size.height / 2,
        );

        // تحديد لون الخط
        Color lineColor;
        if (isAnswered) {
          final isCorrect = correctMatches[leftItem] == rightItem;
          lineColor = isCorrect ? Colors.green : Colors.red;
        } else {
          lineColor = Colors.orange;
        }

        // رسم الخط
        final paint = Paint()
          ..color = lineColor
          ..strokeWidth = 3
          ..style = PaintingStyle.stroke;

        // رسم خط منحني
        final controlPoint1 = Offset(
          startPoint.dx + (endPoint.dx - startPoint.dx) * 0.3,
          startPoint.dy,
        );
        final controlPoint2 = Offset(
          startPoint.dx + (endPoint.dx - startPoint.dx) * 0.7,
          endPoint.dy,
        );

        final path = Path()
          ..moveTo(startPoint.dx, startPoint.dy)
          ..cubicTo(
            controlPoint1.dx, controlPoint1.dy,
            controlPoint2.dx, controlPoint2.dy,
            endPoint.dx, endPoint.dy,
          );

        canvas.drawPath(path, paint);

        // رسم نقاط في نهايات الخط
        final pointPaint = Paint()
          ..color = lineColor
          ..style = PaintingStyle.fill;

        canvas.drawCircle(startPoint, 4, pointPaint);
        canvas.drawCircle(endPoint, 4, pointPaint);
      }
    });
  }

  @override
  bool shouldRepaint(ConnectionLinePainter oldDelegate) {
    return oldDelegate.matches != matches || 
           oldDelegate.isAnswered != isAnswered;
  }
}