import 'package:flutter/material.dart';
import 'package:flutter_task_app/core/validators/validators.dart';
import 'package:flutter_task_app/core/widgets/mobile_input_field.dart';
import 'package:flutter_task_app/features/auth/shared/age_field.dart';
import 'package:flutter_task_app/features/auth/shared/gender_dropdown_field.dart';
import 'package:flutter_task_app/features/auth/shared/name_field.dart';
import 'package:flutter_task_app/features/auth/shared/password_field.dart';

class RegisterFormFields extends StatelessWidget {
  final TextEditingController fullNameController;
  final TextEditingController mobileController;
  final TextEditingController ageController;
  final TextEditingController passwordController;
  final TextEditingController confirmPasswordController;
  final FocusNode fullNameFocusNode;
  final FocusNode mobileFocusNode;
  final FocusNode ageFocusNode;
  final FocusNode passwordFocusNode;
  final FocusNode confirmPasswordFocusNode;
  final String? selectedGender;
  final bool isLoading;
  final Function(String?) onGenderChanged;
  final VoidCallback onSubmit;

  const RegisterFormFields({
    super.key,
    required this.fullNameController,
    required this.mobileController,
    required this.ageController,
    required this.passwordController,
    required this.confirmPasswordController,
    required this.fullNameFocusNode,
    required this.mobileFocusNode,
    required this.ageFocusNode,
    required this.passwordFocusNode,
    required this.confirmPasswordFocusNode,
    required this.selectedGender,
    required this.isLoading,
    required this.onGenderChanged,
    required this.onSubmit,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        NameField(
          controller: fullNameController,
          focusNode: fullNameFocusNode,
          enabled: !isLoading,
          textInputAction: TextInputAction.next,
          onFieldSubmitted: (_) => mobileFocusNode.requestFocus(),
          validator: Validators.validateName,
        ),
        const SizedBox(height: 16),
        MobileInputField(
          controller: mobileController,
          focusNode: mobileFocusNode,
          enabled: !isLoading,
          textInputAction: TextInputAction.next,
          onChanged: (value) {},
          onFieldSubmitted: (_) {
            ageFocusNode.requestFocus();
          },
        ),
        const SizedBox(height: 16),
        AgeField(
          controller: ageController,
          focusNode: ageFocusNode,
          enabled: !isLoading,
          textInputAction: TextInputAction.next,
          onFieldSubmitted: (_) => passwordFocusNode.requestFocus(),
          validator: Validators.validateAge,
        ),
        const SizedBox(height: 16),
        GenderDropdownField(
          value: selectedGender,
          enabled: !isLoading,
          onChanged: onGenderChanged,
          validator: Validators.validateGender,
        ),
        const SizedBox(height: 16),
        PasswordField(
          labelText: 'Password',
          hintText: 'Enter your password',
          controller: passwordController,
          focusNode: passwordFocusNode,
          enabled: !isLoading,
          textInputAction: TextInputAction.next,
          onFieldSubmitted: (_) => confirmPasswordFocusNode.requestFocus(),
          validator: Validators.validatePassword,
        ),
        const SizedBox(height: 16),
        PasswordField(
          labelText: 'Confirm Password',
          hintText: 'Confirm your password',
          controller: confirmPasswordController,
          focusNode: confirmPasswordFocusNode,
          enabled: !isLoading,
          textInputAction: TextInputAction.done,
          onFieldSubmitted: (_) => onSubmit(),
          validator: (value) => Validators.validateConfirmPassword(
            value,
            passwordController.text,
          ),
        ),
      ],
    );
  }
}
