import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_task_app/core/extensions/navigation_extension.dart';
import 'package:flutter_task_app/features/auth/login/cubit/login_cubit.dart';
import 'package:flutter_task_app/features/auth/login/cubit/login_state.dart';
import 'package:flutter_task_app/features/auth/login/screen/widgets/login_form_controller.dart';
import 'package:flutter_task_app/features/auth/login/screen/widgets/login_input_fields.dart';
import 'package:flutter_task_app/features/auth/login/screen/widgets/login_submission_handler.dart';
import 'package:flutter_task_app/features/auth/register/screen/register_screen.dart';
import 'package:flutter_task_app/features/auth/shared/form_footer.dart';
import 'package:flutter_task_app/features/auth/shared/form_header.dart';
import 'package:flutter_task_app/core/widgets/loading_button.dart';

class LoginFormContent extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final LoginFormController formController;

  const LoginFormContent({
    super.key,
    required this.formKey,
    required this.formController,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoginCubit, LoginState>(
      builder: (context, state) {
        final isLoading = state is LoginLoading;
        final loginHandler = LoginSubmissionHandler(
          formKey: formKey,
          formController: formController,
        );

        return FormContainer(
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: MediaQuery.of(context).size.width * 0.02,
              vertical: MediaQuery.of(context).size.height * 0.25,
            ),
            child: Form(
              key: formKey,
              child: Column(
                children: [
                  const FormHeader(logoPath: "assets/logo.png"),

                  LoginInputFields(
                    formController: formController,
                    isLoading: isLoading,
                    onPasswordSubmitted: loginHandler.handleLogin,
                  ),

                  const SizedBox(height: 24),

                  LoadingButton(
                    text: 'Login',
                    onPressed: loginHandler.handleLogin,
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
    );
  }
}
