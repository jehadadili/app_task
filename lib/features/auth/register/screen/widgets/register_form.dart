import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_task_app/features/auth/register/cubit/register_cubit.dart';
import 'package:flutter_task_app/features/auth/register/cubit/register_state.dart';
import 'package:flutter_task_app/features/auth/register/screen/widgets/register_form_content.dart';
import 'package:flutter_task_app/features/auth/register/screen/widgets/register_form_fields.dart';

class RegisterForm extends StatefulWidget {
  final String? initialMobileNumber;
  
  const RegisterForm({super.key, this.initialMobileNumber});

  @override
  State<RegisterForm> createState() => _RegisterFormState();
}

class _RegisterFormState extends State<RegisterForm> {
  final _formKey = GlobalKey<FormState>();
  late final RegisterFormContent _formController;

  @override
  void initState() {
    super.initState();
    _formController = RegisterFormContent(
      initialMobileNumber: widget.initialMobileNumber,
    );
  }

  @override
  void dispose() {
    _formController.dispose();
    super.dispose();
  }

  void _handleRegistration() {
    if (_formKey.currentState!.validate()) {
      final registerCubit = context.read<RegisterCubit>();
      final data = _formController.getRegistrationData();
      
      registerCubit.initiateRegistration(
        fullName: data.fullName,
        mobile: data.mobile,
        age: data.age,
        gender: data.gender,
        password: data.password,
        confirmPassword: data.confirmPassword,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<RegisterCubit, RegisterState>(
      listener: _handleStateChange,
      builder: (context, state) {
        final isLoading = state is RegisterLoading;
        
        return Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  RegisterFormFields(
                    controller: _formController,
                    isEnabled: !isLoading,
                  ),
                  const SizedBox(height: 24.0),
                  _buildRegisterButton(isLoading),
                  const SizedBox(height: 16.0),
                  _buildLoginButton(isLoading),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  void _handleStateChange(BuildContext context, RegisterState state) {
    if (state is RegisterFailure) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(state.error), backgroundColor: Colors.red),
      );
    }
    if (state is RegisterOtpRequired) {
      log("Navigating to OTP Screen for ${state.mobileNumber}");
    }
    if (state is RegisterSuccess) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Registration Successful! Please Login.'),
          backgroundColor: Colors.green,
        ),
      );
      log("Navigating back to Login Screen...");
      Navigator.of(context).pop();
    }
  }

  Widget _buildRegisterButton(bool isLoading) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(vertical: 16.0),
      ),
      onPressed: isLoading ? null : _handleRegistration,
      child: isLoading
          ? const SizedBox(
              height: 20,
              width: 20,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                color: Colors.white,
              ),
            )
          : const Text('Register'),
    );
  }

  Widget _buildLoginButton(bool isLoading) {
    return TextButton(
      onPressed: isLoading ? null : () => Navigator.of(context).pop(),
      child: const Text(
        'Already have an account? Login',
        style: TextStyle(decoration: TextDecoration.underline),
      ),
    );
  }
}
