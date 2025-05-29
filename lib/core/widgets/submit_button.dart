// Placeholder for SubmitButton - Implement actual UI as needed
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SubmitButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;

  const SubmitButton({super.key, required this.text, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 24.w),
        textStyle: TextStyle(fontSize: 16.sp),
      ),
      child: Text(text),
    );
  }
}

