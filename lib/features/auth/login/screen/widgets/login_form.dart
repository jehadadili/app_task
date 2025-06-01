import 'package:flutter/material.dart';
import 'package:flutter_task_app/features/auth/login/screen/widgets/login_bloc_wrapper.dart';
import 'package:flutter_task_app/features/auth/login/screen/widgets/login_form_content.dart';
import 'package:flutter_task_app/features/auth/login/screen/widgets/login_form_controller.dart';


class LoginForm extends StatefulWidget {
  const LoginForm({super.key});

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final _formKey = GlobalKey<FormState>();
  final _formController = LoginFormController();

  @override
  void dispose() {
    _formController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LoginBlocWrapper(
      formKey: _formKey,
      formController: _formController,
      child: LoginFormContent(
        formKey: _formKey,
        formController: _formController,
      ),
    );
  }
}




