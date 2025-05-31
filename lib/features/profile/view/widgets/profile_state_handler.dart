import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_task_app/features/profile/cubit/profile_state.dart';

class ProfileStateHandler {
  static void handleStateChanges(BuildContext context, ProfileState state) {
    if (state is ProfileLogoutSuccess) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Logged out successfully.'),
          backgroundColor: Colors.green,
        ),
      );
      log("Logout successful, navigating to Login Screen...");
    } else if (state is ProfileError) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: ${state.message}'),
          backgroundColor: Colors.red,
        ),
      );
      if (state.message.contains("User not logged in")) {
        log("User not logged in, navigating to Login Screen...");
      }
    }
  }
}