
import 'dart:developer';
import 'package:flutter/material.dart';

class UserNotRegisteredDialog {
  static void show(BuildContext context, String mobileNumber) {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: const Text('User Not Registered'),
          content: const Text(
            'This mobile number is not registered. Would you like to register?',
          ),
          actions: [
            TextButton(
              child: const Text('Cancel'),
              onPressed: () => Navigator.of(dialogContext).pop(),
            ),
            TextButton(
              child: const Text('Register'),
              onPressed: () {
                Navigator.of(dialogContext).pop();
                log("Navigating to Register Screen with mobile: $mobileNumber");
              },
            ),
          ],
        );
      },
    );
  }
}