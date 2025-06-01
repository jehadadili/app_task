import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_task_app/core/extensions/navigation_extension.dart'; // Import the extension
import 'package:flutter_task_app/features/auth/login/screen/login_screen.dart'; // Import LoginScreen
import 'package:flutter_task_app/features/profile/cubit/profile_cubit.dart';

class LogoutConfirmationDialog extends StatelessWidget {
  const LogoutConfirmationDialog({super.key});

  static Future<void> show(BuildContext context) {
    // Capture the ProfileCubit from the context where the dialog is shown
    final profileCubit = context.read<ProfileCubit>();

    return showDialog<void>(
      context: context,
      // Pass the original context (which has the ProfileCubit and Navigator) 
      // and the cubit instance to the builder.
      builder: (BuildContext dialogContext) {
        // Use a Builder to get a context that is descendant of the Dialog,
        // but we will use the original `context` for navigation and cubit access.
        return Builder(
          builder: (innerDialogContext) => AlertDialog(
            title: const Text('Confirm Logout'),
            content: const Text('Are you sure you want to log out?'),
            actions: <Widget>[
              TextButton(
                child: const Text('Cancel'),
                onPressed: () {
                  // Use innerDialogContext to pop the dialog itself
                  Navigator.of(innerDialogContext).pop(); 
                },
              ),
              TextButton(
                style: TextButton.styleFrom(foregroundColor: Colors.red),
                onPressed: () {
                  // Pop the dialog first using innerDialogContext
                  Navigator.of(innerDialogContext).pop(); 
                  // Call logout on the captured cubit instance
                  profileCubit.logoutUser();
                  // Perform navigation using the original context (which has the extension)
                  // Navigate to LoginScreen and remove all previous routes
                  context.pushReplacement(pushReplacement: const LoginScreen());
                },
                child: const Text('Logout'),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return const AlertDialog(
      title: Text('Confirm Logout'),
      content: Text('Are you sure you want to log out?'),
    );
  }
}

