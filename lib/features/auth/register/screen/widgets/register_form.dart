import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_task_app/core/extensions/navigation_extension.dart';
import 'package:flutter_task_app/core/validators/validators.dart';
import 'package:flutter_task_app/features/auth/login/screen/login_screen.dart';
import 'package:flutter_task_app/features/auth/otp/screen/otp_screen.dart';
import 'package:flutter_task_app/features/auth/register/cubit/register_cubit.dart';
import 'package:flutter_task_app/features/auth/register/cubit/register_state.dart';
import 'package:flutter_task_app/features/auth/widgets/age_field.dart';
import 'package:flutter_task_app/features/auth/widgets/form_footer.dart';
import 'package:flutter_task_app/features/auth/widgets/form_header.dart';
import 'package:flutter_task_app/features/auth/widgets/gender_dropdown_field.dart';
import 'package:flutter_task_app/features/auth/widgets/loading_button.dart';
import 'package:flutter_task_app/features/auth/widgets/mobile_input_field.dart';
import 'package:flutter_task_app/features/auth/widgets/name_field.dart';
import 'package:flutter_task_app/features/auth/widgets/password_field.dart';

class RegisterForm extends StatefulWidget {
  final String? initialMobileNumber;

  const RegisterForm({super.key, this.initialMobileNumber});

  @override
  State<RegisterForm> createState() => _RegisterFormState();
}

class _RegisterFormState extends State<RegisterForm> {
  final _formKey = GlobalKey<FormState>();
  final _fullNameController = TextEditingController();
  final _mobileController = TextEditingController();
  final _ageController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  final _fullNameFocusNode = FocusNode();
  final _mobileFocusNode = FocusNode();
  final _ageFocusNode = FocusNode();
  final _passwordFocusNode = FocusNode();
  final _confirmPasswordFocusNode = FocusNode();

  String? _selectedGender;

  @override
  void initState() {
    super.initState();
    if (widget.initialMobileNumber != null) {
      String mobile = widget.initialMobileNumber!;
      if (mobile.startsWith('+962')) {
        mobile = mobile.substring(4);
      }
      _mobileController.text = mobile;
    }
  }

  @override
  void dispose() {
    _fullNameController.dispose();
    _mobileController.dispose();
    _ageController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _fullNameFocusNode.dispose();
    _mobileFocusNode.dispose();
    _ageFocusNode.dispose();
    _passwordFocusNode.dispose();
    _confirmPasswordFocusNode.dispose();
    super.dispose();
  }

  void _handleRegister() {
    if (_formKey.currentState!.validate()) {
      final age = int.tryParse(_ageController.text);
      final fullMobileNumber = '+962${_mobileController.text.trim()}';

      context.read<RegisterCubit>().initiateRegistration(
        fullName: _fullNameController.text.trim(),
        mobile: fullMobileNumber,
        age: age,
        gender: _selectedGender,
        password: _passwordController.text,
        confirmPassword: _confirmPasswordController.text,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<RegisterCubit, RegisterState>(
      listener: (context, state) {
        if (state is RegisterOtpRequired) {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => OtpScreen(
                mobileNumber: state.mobileNumber,
                registerCubit: context.read<RegisterCubit>(),
              ),
            ),
          );
        } else if (state is RegisterFailure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.error), backgroundColor: Colors.red),
          );
        } else if (state is RegisterSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Registration completed successfully!'),
              backgroundColor: Colors.green,
            ),
          );
          Navigator.of(context).popUntil((route) => route.isFirst);
        }
      },
      child: BlocBuilder<RegisterCubit, RegisterState>(
        builder: (context, state) {
          final isLoading = state is RegisterLoading;

          return FormContainer(
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: MediaQuery.of(context).size.width * 0.01,
                vertical: MediaQuery.of(context).size.height * 0.1,
              ),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    const FormHeader(logoPath: "assets/logo.png"),

                    NameField(
                      controller: _fullNameController,
                      focusNode: _fullNameFocusNode,
                      enabled: !isLoading,
                      textInputAction: TextInputAction.next,
                      onFieldSubmitted: (_) {
                        _mobileFocusNode.requestFocus();
                      },
                      validator: (value) => Validators.validateName(value),
                    ),

                    const SizedBox(height: 16),

                    MobileInputField(
                      controller: _mobileController,
                      focusNode: _mobileFocusNode,
                      enabled: !isLoading,
                      textInputAction: TextInputAction.next,
                      onChanged: (value) {},
                      onFieldSubmitted: (_) {
                        _ageFocusNode.requestFocus();
                      },
                      validator: (value) => Validators.validateMobile(value),
                    ),

                    const SizedBox(height: 16),

                    AgeField(
                      controller: _ageController,
                      focusNode: _ageFocusNode,
                      enabled: !isLoading,
                      textInputAction: TextInputAction.next,
                      onFieldSubmitted: (_) {
                        _passwordFocusNode.requestFocus();
                      },
                      validator: (value) => Validators.validateAge(value),
                    ),

                    const SizedBox(height: 16),

                    GenderDropdownField(
                      value: _selectedGender,
                      enabled: !isLoading,
                      onChanged: (value) {
                        setState(() {
                          _selectedGender = value;
                        });
                      },
                      validator: (value) => Validators.validateGender(value),
                    ),

                    const SizedBox(height: 16),

                    PasswordField(
                      labelText: 'Password',
                      hintText: 'Enter your password',
                      controller: _passwordController,
                      focusNode: _passwordFocusNode,
                      enabled: !isLoading,
                      textInputAction: TextInputAction.next,
                      onFieldSubmitted: (_) {
                        _confirmPasswordFocusNode.requestFocus();
                      },
                      validator: (value) => Validators.validatePassword(value),
                    ),

                    const SizedBox(height: 16),

                    PasswordField(
                      labelText: 'Confirm Password',
                      hintText: 'Confirm your password',
                      controller: _confirmPasswordController,
                      focusNode: _confirmPasswordFocusNode,
                      enabled: !isLoading,
                      textInputAction: TextInputAction.done,
                      onFieldSubmitted: (_) {
                        _handleRegister();
                      },
                      validator: (value) => Validators.validateConfirmPassword(
                        value,
                        _passwordController.text,
                      ),
                    ),

                    const SizedBox(height: 32),

                    LoadingButton(
                      text: 'Create Account',
                      onPressed: isLoading ? null : _handleRegister,
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
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
