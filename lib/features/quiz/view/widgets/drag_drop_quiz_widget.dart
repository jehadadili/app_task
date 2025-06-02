import 'package:flutter/material.dart';
import 'package:flutter_task_app/features/quiz/model/drag_drop_quiz_question.dart';

class DragDropWidget extends StatefulWidget {
  final DragDropQuestion question;
  final bool isAnswered;
  final Function(Map<String, String>) onAnswerSelected;

  const DragDropWidget({
    super.key,
    required this.question,
    required this.isAnswered,
    required this.onAnswerSelected,
  });

  @override
  State<DragDropWidget> createState() => _DragDropWidgetState();
}

class _DragDropWidgetState extends State<DragDropWidget>
    with TickerProviderStateMixin {
  Map<String, String> userPairs = {};
  late AnimationController _animationController;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );
    _slideAnimation =
        Tween<Offset>(begin: const Offset(-1.0, 0.0), end: Offset.zero).animate(
          CurvedAnimation(
            parent: _animationController,
            curve: Curves.easeOutBack,
          ),
        );
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SlideTransition(
      position: _slideAnimation,
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
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      'اسحب العناصر:',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: Colors.blue.shade700,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),
                    ...widget.question.leftItems.map((item) {
                      final isUsed = userPairs.containsKey(item);

                      return Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: Draggable<String>(
                          data: item,
                          feedback: Material(
                            elevation: 8,
                            borderRadius: BorderRadius.circular(12),
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 12,
                              ),
                              constraints: const BoxConstraints(maxWidth: 150),
                              decoration: BoxDecoration(
                                color: Colors.blue.shade100,
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: Colors.blue,
                                  width: 2,
                                ),
                              ),
                              child: Text(
                                item,
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                          childWhenDragging: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 12,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.grey.shade100,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: Colors.grey.shade300,
                                width: 2,
                              ),
                            ),
                            child: Text(
                              item,
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey.shade400,
                                fontWeight: FontWeight.w500,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 300),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 12,
                            ),
                            decoration: BoxDecoration(
                              color: isUsed
                                  ? Colors.grey.shade100
                                  : Colors.blue.shade50,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: isUsed
                                    ? Colors.grey.shade300
                                    : Colors.blue.shade300,
                                width: 2,
                              ),
                              boxShadow: isUsed
                                  ? null
                                  : [
                                      BoxShadow(
                                        color: Colors.blue.shade100,
                                        blurRadius: 4,
                                        offset: const Offset(0, 2),
                                      ),
                                    ],
                            ),
                            child: Text(
                              item,
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                color: isUsed
                                    ? Colors.grey.shade500
                                    : Colors.black87,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ],
                ),
              ),
              const SizedBox(width: 20),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      'أفلت هنا:',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: Colors.green.shade700,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),
                    ...widget.question.rightItems.map((item) {
                      final pairedWith = userPairs.entries
                          .where((entry) => entry.value == item)
                          .map((entry) => entry.key)
                          .firstOrNull;

                      final isCorrect =
                          widget.isAnswered &&
                          pairedWith != null &&
                          widget.question.correctPairs[pairedWith] == item;

                      final isIncorrect =
                          widget.isAnswered &&
                          pairedWith != null &&
                          widget.question.correctPairs[pairedWith] != item;

                      return Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: DragTarget<String>(
                          builder: (context, candidateData, rejectedData) {
                            final isHovering = candidateData.isNotEmpty;

                            return AnimatedContainer(
                              duration: const Duration(milliseconds: 300),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 12,
                              ),
                              decoration: BoxDecoration(
                                color: isHovering
                                    ? Colors.green.shade100
                                    : pairedWith != null
                                    ? (widget.isAnswered
                                          ? (isCorrect
                                                ? Colors.green.shade50
                                                : Colors.red.shade50)
                                          : Colors.orange.shade50)
                                    : Colors.grey.shade50,
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: isHovering
                                      ? Colors.green
                                      : pairedWith != null
                                      ? (widget.isAnswered
                                            ? (isCorrect
                                                  ? Colors.green
                                                  : Colors.red)
                                            : Colors.orange)
                                      : Colors.grey.shade300,
                                  width: isHovering ? 3 : 2,
                                ),
                                boxShadow: isHovering
                                    ? [
                                        BoxShadow(
                                          color: Colors.green.shade200,
                                          blurRadius: 8,
                                          offset: const Offset(0, 4),
                                        ),
                                      ]
                                    : null,
                              ),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          item,
                                          style: const TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                        if (pairedWith != null) ...[
                                          const SizedBox(height: 4),
                                          Text(
                                            '← $pairedWith',
                                            style: TextStyle(
                                              fontSize: 12,
                                              color: Colors.grey.shade600,
                                              fontStyle: FontStyle.italic,
                                            ),
                                          ),
                                        ],
                                      ],
                                    ),
                                  ),
                                  if (widget.isAnswered && pairedWith != null)
                                    Icon(
                                      isCorrect
                                          ? Icons.check_circle
                                          : Icons.cancel,
                                      color: isCorrect
                                          ? Colors.green
                                          : Colors.red,
                                      size: 24,
                                    ),
                                  if (pairedWith == null && !widget.isAnswered)
                                    Icon(
                                      Icons.add_circle_outline,
                                      color: Colors.grey.shade400,
                                      size: 20,
                                    ),
                                ],
                              ),
                            );
                          },
                          onAcceptWithDetails: (details) {
                            if (!widget.isAnswered) {
                              setState(() {
                                // إزالة أي اقتران سابق لهذا العنصر
                                userPairs.removeWhere(
                                  (key, value) => value == item,
                                );
                                userPairs.removeWhere(
                                  (key, value) => key == details.data,
                                );
                                // إضافة الاقتران الجديد
                                userPairs[details.data] = item;
                              });
                              widget.onAnswerSelected(userPairs);
                            }
                          },
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
    );
  }
}
