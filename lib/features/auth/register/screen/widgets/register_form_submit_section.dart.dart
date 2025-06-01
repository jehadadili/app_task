import 'package:flutter/material.dart';
import 'package:flutter_task_app/core/extensions/navigation_extension.dart';
import 'package:flutter_task_app/core/widgets/loading_button.dart';
import 'package:flutter_task_app/features/auth/login/screen/login_screen.dart';
import 'package:flutter_task_app/features/auth/widgets/form_footer.dart';

class RegisterFormSubmitSection extends StatelessWidget {
  final bool isLoading;
  final VoidCallback onRegister;

  const RegisterFormSubmitSection({
    super.key,
    required this.isLoading,
    required this.onRegister,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        LoadingButton(
          text: 'Create Account',
          onPressed: isLoading ? null : onRegister,
          isLoading: isLoading,
        ),
        const SizedBox(height: 24),
        FormFooter(
          text: 'Already have an account? ',
          buttonText: 'Sign In',
          enabled: !isLoading,
          onPressed: () {
            context.pushReplacement(pushReplacement: LoginScreen());
          },
        ),
      ],
    );
  }
}
