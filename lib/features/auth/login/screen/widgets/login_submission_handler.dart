import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_task_app/features/auth/login/cubit/login_cubit.dart';
import 'package:flutter_task_app/features/auth/login/screen/widgets/login_form_controller.dart';

class LoginSubmissionHandler {
  final GlobalKey<FormState> formKey;
  final LoginFormController formController;

  LoginSubmissionHandler({
    required this.formKey,
    required this.formController,
  });

  void handleLogin() {
    if (formKey.currentState!.validate()) {
      final context = formKey.currentContext!;
      context.read<LoginCubit>().loginUser(
        formController.fullMobileNumber,
        formController.passwordController.text,
      );
    }
  }
}