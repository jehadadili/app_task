import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_task_app/features/auth/login/cubit/login_cubit.dart';
import 'package:flutter_task_app/features/auth/login/cubit/login_state.dart';
import 'package:flutter_task_app/features/auth/login/screen/widgets/login_form_controller.dart';
import 'package:flutter_task_app/features/auth/login/screen/widgets/login_form_fields.dart';
import 'package:flutter_task_app/features/auth/login/screen/widgets/user_not_registered_dialog.dart';
import 'package:flutter_task_app/features/auth/register/screen/register_screen.dart';

class LoginForm extends StatefulWidget {
  const LoginForm({super.key});

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final _formKey = GlobalKey<FormState>();
  late final LoginFormController _formController;

  @override
  void initState() {
    super.initState();
    _formController = LoginFormController();
  }

  @override
  void dispose() {
    _formController.dispose();
    super.dispose();
  }

  void _handleLogin() {
    if (_formKey.currentState!.validate()) {
      final loginCubit = context.read<LoginCubit>();
      final data = _formController.getLoginData();

      loginCubit.loginUser(data.mobile, data.password);
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<LoginCubit, LoginState>(
      listener: _handleStateChange,
      builder: (context, state) {
        final isLoading = state is LoginLoading;

        return Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const FlutterLogo(size: 100),
                  const SizedBox(height: 48.0),

                  LoginFormFields(
                    controller: _formController,
                    isEnabled: !isLoading,
                  ),
                  const SizedBox(height: 24.0),

                  _buildLoginButton(isLoading),
                  const SizedBox(height: 16.0),

                  _buildRegisterButton(isLoading),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  void _handleStateChange(BuildContext context, LoginState state) {
    if (state is LoginFailure) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(state.error), backgroundColor: Colors.red),
      );
    }
    if (state is LoginSuccess) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Login Successful!'),
          backgroundColor: Colors.green,
        ),
      );
      log("Navigating to Home Screen...");
    }
    if (state is LoginUserNotRegistered) {
      UserNotRegisteredDialog.show(context, state.mobileNumber);
    }
  }

  Widget _buildLoginButton(bool isLoading) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(vertical: 16.0),
      ),
      onPressed: isLoading ? null : _handleLogin,
      child: isLoading
          ? const SizedBox(
              height: 20,
              width: 20,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                color: Colors.white,
              ),
            )
          : const Text('Login'),
    );
  }

  Widget _buildRegisterButton(bool isLoading) {
    return TextButton(
      onPressed: isLoading
          ? null
          : () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const RegisterScreen()),
              );
              log("Navigating to Register Screen...");
            },
      child: const Text(
        'Don\'t have an account? Register',
        style: TextStyle(decoration: TextDecoration.underline),
      ),
    );
  }
}
