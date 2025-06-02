import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_task_app/core/config/firebase_config.dart';
import 'package:flutter_task_app/features/auth/register/cubit/register_cubit.dart';
import 'package:flutter_task_app/features/auth/register/screen/widgets/register_form.dart';
import 'package:flutter_task_app/features/splash/cubit/splash_cubit.dart';
import 'package:flutter_task_app/features/splash/cubit/splash_state.dart';

class RegisterScreen extends StatelessWidget {
  final String? initialMobileNumber;

  const RegisterScreen({super.key, this.initialMobileNumber});

  @override
  Widget build(BuildContext context) {
    final firebaseConfig = context.select(
      (SplashCubit cubit) => cubit.state is NavigateToLogin
          ? (cubit.state as NavigateToLogin).config
          : FirebaseConfig.defaultConfig(),
    );

    return BlocProvider(
      create: (context) => RegisterCubit(firebaseConfig: firebaseConfig),
      child: RegistrationView(initialMobileNumber: initialMobileNumber),
    );
  }
}

class RegistrationView extends StatelessWidget {
  final String? initialMobileNumber;

  const RegistrationView({super.key, this.initialMobileNumber});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: RegisterForm(initialMobileNumber: initialMobileNumber),
    );
  }
}
