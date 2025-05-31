
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_task_app/core/validators/validators.dart';
import 'package:flutter_task_app/core/widgets/custom_text_field.dart';
import 'package:flutter_task_app/features/auth/login/cubit/login_cubit.dart';
import 'package:flutter_task_app/features/auth/login/screen/widgets/login_form_controller.dart';

class LoginFormFields extends StatelessWidget {
  final LoginFormController controller;
  final bool isEnabled;

  const LoginFormFields({
    super.key,
    required this.controller,
    required this.isEnabled,
  });

  @override
  Widget build(BuildContext context) {
    final config = context.read<LoginCubit>().firebaseConfig;

    return Column(
      children: [
        CustomTextField(
          controller: controller.mobileController,
          labelText: 'Mobile Number',
          prefixText: '${config.countryCode} ',
          hintText: 'Enter your mobile number',
          keyboardType: TextInputType.phone,
          validator: (value) => Validators.validateMobile(value, config.mobileRegex),
          enabled: isEnabled,
        ),
        const SizedBox(height: 16.0),
        
        CustomTextField(
          controller: controller.passwordController,
          labelText: 'Password',
          hintText: 'Enter your password',
          obscureText: controller.obscurePassword,
          validator: (value) => Validators.validatePassword(value, config.passwordRegex),
          enabled: isEnabled,
          suffixIcon: IconButton(
            icon: Icon(
              controller.obscurePassword ? Icons.visibility_off : Icons.visibility,
            ),
            onPressed: controller.togglePasswordVisibility,
          ),
        ),
      ],
    );
  }
}
