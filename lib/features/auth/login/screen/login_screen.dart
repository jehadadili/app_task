import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_task_app/core/config/firebase_config.dart';
import 'package:flutter_task_app/features/auth/login/cubit/login_cubit.dart';
import 'package:flutter_task_app/features/auth/login/screen/widgets/login_form.dart';
import 'package:flutter_task_app/features/splash/cubit/splash_cubit.dart';
import 'package:flutter_task_app/features/splash/cubit/splash_state.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final firebaseConfig = context.select(
      (SplashCubit cubit) => cubit.state is SplashLoaded
          ? (cubit.state as SplashLoaded).config
          : FirebaseConfig.defaultConfig(),
    );

    return BlocProvider(
      create: (context) => LoginCubit(firebaseConfig: firebaseConfig),
      child: const LoginView(),
    );
  }
}

class LoginView extends StatelessWidget {
  const LoginView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: const LoginForm());
  }
}
