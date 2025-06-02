import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_task_app/features/auth/login/cubit/login_cubit.dart';
import 'package:flutter_task_app/features/auth/login/cubit/login_state.dart';
import 'package:flutter_task_app/features/auth/login/screen/widgets/login_form_controller.dart';
import 'package:flutter_task_app/features/auth/login/screen/widgets/login_snack_bar_handler.dart';

class LoginBlocWrapper extends StatelessWidget {
  final Widget child;
  final GlobalKey<FormState> formKey;
  final LoginFormController formController;

  const LoginBlocWrapper({
    super.key,
    required this.child,
    required this.formKey,
    required this.formController,
  });

  @override
  Widget build(BuildContext context) {
    return BlocListener<LoginCubit, LoginState>(
      listener: (context, state) {
             final snackBarHandler = LoginSnackBarHandler();
            snackBarHandler.handleLoginState(context, state);
      },
      child: child,
    );
  }
}
