import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_task_app/core/extensions/navigation_extension.dart'; 
import 'package:flutter_task_app/features/auth/login/screen/login_screen.dart'; 
import 'package:flutter_task_app/features/profile/cubit/profile_cubit.dart';

class LogoutConfirmationDialog extends StatelessWidget {
  const LogoutConfirmationDialog({super.key});

  static Future<void> show(BuildContext context) {
    final profileCubit = context.read<ProfileCubit>();

    return showDialog<void>(
      context: context,
    
      builder: (BuildContext dialogContext) {
       
        return Builder(
          builder: (innerDialogContext) => AlertDialog(
            title: const Text('Confirm Logout'),
            content: const Text('Are you sure you want to log out?'),
            actions: <Widget>[
              TextButton(
                child: const Text('Cancel'),
                onPressed: () {
                  Navigator.of(innerDialogContext).pop(); 
                },
              ),
              TextButton(
                style: TextButton.styleFrom(foregroundColor: Colors.red),
                onPressed: () {
                  Navigator.of(innerDialogContext).pop(); 
                  profileCubit.logoutUser();
                 
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

