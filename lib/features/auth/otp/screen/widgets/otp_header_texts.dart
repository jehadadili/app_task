import 'package:flutter/material.dart';

class OtpHeaderTexts extends StatelessWidget {
  final String mobileNumber;

  const OtpHeaderTexts({super.key, required this.mobileNumber});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Icon(Icons.verified_user, size: 80, color: Colors.blue),
        const SizedBox(height: 32),
        const Text(
          'Enter Verification Code',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),
        Text(
          'We sent a verification code to',
          style: TextStyle(fontSize: 16, color: Colors.grey[600]),
        ),
        const SizedBox(height: 8),
        Text(
          mobileNumber,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }
}
