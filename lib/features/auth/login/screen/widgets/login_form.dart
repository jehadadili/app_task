import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_task_app/core/extensions/navigation_extension.dart';
import 'package:flutter_task_app/core/validators/validators.dart';
import 'package:flutter_task_app/features/auth/login/cubit/login_cubit.dart';
import 'package:flutter_task_app/features/auth/login/cubit/login_state.dart';
import 'package:flutter_task_app/features/auth/register/screen/register_screen.dart';
import 'package:flutter_task_app/features/auth/widgets/form_footer.dart';
import 'package:flutter_task_app/features/auth/widgets/form_header.dart';
import 'package:flutter_task_app/features/auth/widgets/loading_button.dart';
import 'package:flutter_task_app/features/auth/widgets/mobile_input_field.dart';
import 'package:flutter_task_app/features/auth/widgets/password_field.dart';
import 'package:flutter_task_app/features/home/screen/home_screen.dart';

class LoginForm extends StatefulWidget {
  const LoginForm({super.key});

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final _formKey = GlobalKey<FormState>();
  final _mobileController = TextEditingController();
  final _passwordController = TextEditingController();
  final _mobileFocusNode = FocusNode();
  final _passwordFocusNode = FocusNode();

  @override
  void dispose() {
    _mobileController.dispose();
    _passwordController.dispose();
    _mobileFocusNode.dispose();
    _passwordFocusNode.dispose();
    super.dispose();
  }

  void _handleLogin() {
    if (_formKey.currentState!.validate()) {
      final fullMobileNumber = '+962 ${_mobileController.text.trim()}';
      context.read<LoginCubit>().loginUser(
        fullMobileNumber,
        _passwordController.text,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<LoginCubit, LoginState>(
      listener: (context, state) {
        if (state is LoginSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Login successful!'),
              backgroundColor: Colors.green,
            ),
          );
          context.pushReplacement(pushReplacement: HomeScreen());
        } else if (state is LoginFailure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.error), backgroundColor: Colors.red),
          );
        } else if (state is LoginUserNotRegistered) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                'User not registered with mobile: ${state.mobileNumber}',
              ),
              backgroundColor: Colors.orange,
              action: SnackBarAction(
                label: 'Register',
                onPressed: () {
                  context.pushReplacement(pushReplacement: RegisterScreen());
                },
              ),
            ),
          );
        }
      },
      child: BlocBuilder<LoginCubit, LoginState>(
        builder: (context, state) {
          final isLoading = state is LoginLoading;

          return FormContainer(
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: MediaQuery.of(context).size.width * 0.02,
                vertical: MediaQuery.of(context).size.height * 0.25,
              ),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    const FormHeader(logoPath: "assets/logo.png"),

                    MobileInputField(
                      controller: _mobileController,
                      focusNode: _mobileFocusNode,
                      enabled: !isLoading,
                      textInputAction: TextInputAction.next,
                      onChanged: (value) {},
                      onFieldSubmitted: (_) {
                        _passwordFocusNode.requestFocus();
                      },
                      validator: (value) => Validators.validateMobile(value),
                    ),

                    const SizedBox(height: 16),

                    PasswordField(
                      controller: _passwordController,
                      focusNode: _passwordFocusNode,
                      enabled: !isLoading,
                      textInputAction: TextInputAction.done,
                      onFieldSubmitted: (_) => _handleLogin(),
                      validator: (value) => Validators.validatePassword(value),
                    ),

                    const SizedBox(height: 24),

                    LoadingButton(
                      text: 'Login',
                      onPressed: _handleLogin,
                      isLoading: isLoading,
                    ),

                    const SizedBox(height: 16),

                    FormFooter(
                      text: 'Don\'t have an account? ',
                      buttonText: 'Register',
                      onPressed: () {
                        context.pushReplacement(
                          pushReplacement: RegisterScreen(),
                        );
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
