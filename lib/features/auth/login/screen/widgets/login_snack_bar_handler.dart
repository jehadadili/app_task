import 'package:flutter/material.dart';
import 'package:flutter_task_app/core/extensions/navigation_extension.dart';
import 'package:flutter_task_app/features/auth/login/cubit/login_state.dart';
import 'package:flutter_task_app/features/auth/register/screen/register_screen.dart';
import 'package:flutter_task_app/features/home/screen/home_screen.dart';

class LoginSnackBarHandler {
  void handleLoginState(BuildContext context, LoginState state) {
    if (state is LoginSuccess) {
      _showSuccessSnackBar(context);
      context.pushReplacement(pushReplacement: const HomeScreen());
    } else if (state is LoginFailure) {
      _showErrorSnackBar(context, state.error);
    } else if (state is LoginUserNotRegistered) {
      _showNotRegisteredSnackBar(context, state.mobileNumber);
    }
  }

  void _showSuccessSnackBar(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Login successful!'),
        backgroundColor: Colors.green,
      ),
    );
  }

  void _showErrorSnackBar(BuildContext context, String error) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(error), backgroundColor: Colors.red));
  }

  void _showNotRegisteredSnackBar(BuildContext context, String mobileNumber) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('User not registered with mobile: $mobileNumber'),
        backgroundColor: Colors.orange,
        action: SnackBarAction(
          label: 'Register',
          onPressed: () {
            context.pushReplacement(pushReplacement: const RegisterScreen());
          },
        ),
      ),
    );
  }
}
