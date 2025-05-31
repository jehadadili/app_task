import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_task_app/core/validators/validators.dart';
import 'package:flutter_task_app/features/auth/register/cubit/register_cubit.dart';
import 'package:flutter_task_app/core/widgets/custom_text_field.dart';
import 'package:flutter_task_app/features/auth/register/screen/widgets/age_dropdown_field.dart';
import 'package:flutter_task_app/features/auth/register/screen/widgets/gender_dropdown_field.dart';
import 'package:flutter_task_app/features/auth/register/screen/widgets/register_form_content.dart';

class RegisterFormFields extends StatelessWidget {
  final RegisterFormContent controller;
  final bool isEnabled;

  const RegisterFormFields({
    super.key,
    required this.controller,
    required this.isEnabled,
  });

  @override
  Widget build(BuildContext context) {
    final config = context.read<RegisterCubit>().firebaseConfig;

    return Column(
      children: [
        CustomTextField(
          controller: controller.fullNameController,
          labelText: 'Full Name',
          validator: Validators.validateName,
          enabled: isEnabled,
          textCapitalization: TextCapitalization.words,
        ),
        const SizedBox(height: 16.0),

        CustomTextField(
          controller: controller.mobileController,
          labelText: 'Mobile Number',
          prefixText: '${config.countryCode} ',
          keyboardType: TextInputType.phone,
          validator: (value) =>
              Validators.validateMobile(value, config.mobileRegex),
          enabled: isEnabled,
        ),
        const SizedBox(height: 16.0),

        AgeDropdownField(
          selectedAge: controller.selectedAge,
          onChanged: isEnabled ? controller.setAge : null,
        ),
        const SizedBox(height: 16.0),

        GenderDropdownField(
          selectedGender: controller.selectedGender,
          onChanged: isEnabled ? controller.setGender : null,
        ),
        const SizedBox(height: 16.0),

        CustomTextField(
          controller: controller.passwordController,
          labelText: 'Password',
          obscureText: controller.obscurePassword,
          validator: (value) =>
              Validators.validatePassword(value, config.passwordRegex),
          enabled: isEnabled,
          suffixIcon: IconButton(
            icon: Icon(
              controller.obscurePassword
                  ? Icons.visibility_off
                  : Icons.visibility,
            ),
            onPressed: controller.togglePasswordVisibility,
          ),
        ),
        const SizedBox(height: 16.0),

        CustomTextField(
          controller: controller.confirmPasswordController,
          labelText: 'Confirm Password',
          obscureText: controller.obscureConfirmPassword,
          validator: (value) => Validators.validateConfirmPassword(
            value,
            controller.passwordController.text,
          ),
          enabled: isEnabled,
          suffixIcon: IconButton(
            icon: Icon(
              controller.obscureConfirmPassword
                  ? Icons.visibility_off
                  : Icons.visibility,
            ),
            onPressed: controller.toggleConfirmPasswordVisibility,
          ),
        ),
      ],
    );
  }
}
