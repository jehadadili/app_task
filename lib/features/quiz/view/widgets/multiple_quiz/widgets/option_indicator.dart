import 'package:flutter/material.dart';

class OptionIndicator extends StatelessWidget {
  final String letter;
  final Color color;

  const OptionIndicator({
    super.key,
    required this.letter,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 32,
      height: 32,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: color,
      ),
      child: Center(
        child: Text(
          letter,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
