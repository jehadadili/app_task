import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_task_app/features/auth/register/cubit/register_cubit.dart';
import 'package:flutter_task_app/features/auth/register/cubit/register_state.dart';
import 'package:flutter_task_app/features/auth/register/screen/widgets/register_form_fields.dart';
import 'package:flutter_task_app/features/auth/register/screen/widgets/register_form_listener.dart';
import 'package:flutter_task_app/features/auth/register/screen/widgets/register_form_submit_section.dart.dart';
import 'package:flutter_task_app/features/auth/shared/form_footer.dart';
import 'package:flutter_task_app/features/auth/shared/form_header.dart';

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
    return RegisterFormListener(
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
                    RegisterFormFields(
                      fullNameController: _fullNameController,
                      mobileController: _mobileController,
                      ageController: _ageController,
                      passwordController: _passwordController,
                      confirmPasswordController: _confirmPasswordController,
                      fullNameFocusNode: _fullNameFocusNode,
                      mobileFocusNode: _mobileFocusNode,
                      ageFocusNode: _ageFocusNode,
                      passwordFocusNode: _passwordFocusNode,
                      confirmPasswordFocusNode: _confirmPasswordFocusNode,
                      selectedGender: _selectedGender,
                      onGenderChanged: (value) =>
                          setState(() => _selectedGender = value),
                      isLoading: isLoading,
                      onSubmit: _handleRegister,
                    ),
                    const SizedBox(height: 32),
                    RegisterFormSubmitSection(
                      isLoading: isLoading,
                      onRegister: _handleRegister,
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
