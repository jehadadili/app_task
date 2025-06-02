import 'package:flutter/material.dart';

class DraggableOptionChip extends StatelessWidget {
  final String text;
  final bool enabled;
  final VoidCallback onDrag;

  const DraggableOptionChip({
    super.key,
    required this.text,
    required this.enabled,
    required this.onDrag,
  });

  @override
  Widget build(BuildContext context) {
    final chipContent = Text(
      text,
      style: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w500,
        color: enabled ? Colors.blue.shade800 : Colors.grey.shade600,
      ),
      textAlign: TextAlign.center,
    );

    final chipContainer = Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      decoration: BoxDecoration(
        color: enabled ? Colors.blue.shade50 : Colors.grey.shade200,
        borderRadius: BorderRadius.circular(25),
        border: Border.all(
          color: enabled ? Colors.blue.shade200 : Colors.grey.shade300,
          width: 1.5,
        ),
        boxShadow: enabled
            ? [
                BoxShadow(
                  color: Colors.blue.shade100.withValues(alpha: 0.6),
                  blurRadius: 5,
                  offset: const Offset(0, 2),
                ),
              ]
            : [],
      ),
      child: chipContent,
    );

    if (!enabled) return chipContainer;

    return Draggable<String>(
      data: text,
      feedback: Material(
        elevation: 5.0,
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(25),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          decoration: BoxDecoration(
            color: Colors.blue.shade100,
            borderRadius: BorderRadius.circular(25),
            border: Border.all(color: Colors.blue.shade400, width: 2),
          ),
          child: chipContent,
        ),
      ),
      childWhenDragging: Opacity(
        opacity: 0.4,
        child: chipContainer,
      ),
      child: chipContainer,
    );
  }
}
