import 'package:flutter/material.dart';
import 'package:flutter_task_app/core/validators/validators.dart';
import 'package:flutter_task_app/core/widgets/mobile_input_field.dart';
import 'package:flutter_task_app/features/auth/login/screen/widgets/login_form_controller.dart';
import 'package:flutter_task_app/features/auth/widgets/password_field.dart';

class LoginInputFields extends StatelessWidget {
  final LoginFormController formController;
  final bool isLoading;
  final VoidCallback onPasswordSubmitted;

  const LoginInputFields({
    super.key,
    required this.formController,
    required this.isLoading,
    required this.onPasswordSubmitted,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        MobileInputField(
          controller: formController.mobileController,
          focusNode: formController.mobileFocusNode,
          enabled: !isLoading,
          textInputAction: TextInputAction.next,
          onChanged: (value) {},
          onFieldSubmitted: (_) {
            formController.focusPassword();
          },
          validator: (value) => Validators.validateMobile(value),
        ),

        const SizedBox(height: 16),

        PasswordField(
          controller: formController.passwordController,
          focusNode: formController.passwordFocusNode,
          enabled: !isLoading,
          textInputAction: TextInputAction.done,
          onFieldSubmitted: (_) => onPasswordSubmitted(),
          validator: (value) => Validators.validatePassword(value),
        ),
      ],
    );
  }
}