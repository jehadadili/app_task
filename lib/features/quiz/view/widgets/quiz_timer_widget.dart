import 'package:flutter/material.dart';

class QuizTimerWidget extends StatelessWidget {
  final int remainingTime;
  final int totalTime;

  const QuizTimerWidget({
    super.key,
    required this.remainingTime,
    required this.totalTime,
  });

  @override
  Widget build(BuildContext context) {
    final progress = remainingTime / totalTime;
    final isLowTime = remainingTime <= 10;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: isLowTime
              ? [Colors.red.shade400, Colors.red.shade600]
              : [Colors.blue.shade400, Colors.blue.shade600],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: (isLowTime ? Colors.red : Colors.blue).withValues(alpha: 0.3),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Icon(
            Icons.timer,
            color: Colors.white,
            size: isLowTime ? 28 : 24,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Time Remaining',
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.9),
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 4),
                LinearProgressIndicator(
                  value: progress,
                  backgroundColor: Colors.white.withValues(alpha: 0.3),
                  valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
                  minHeight: 4,
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          AnimatedDefaultTextStyle(
            duration: const Duration(milliseconds: 300),
            style: TextStyle(
              color: Colors.white,
              fontSize: isLowTime ? 20 : 18,
              fontWeight: FontWeight.bold,
            ),
            child: Text(
              '${remainingTime}s',
            ),
          ),
        ],
      ),
    );
  }
}
