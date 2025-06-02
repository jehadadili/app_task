import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_task_app/core/extensions/navigation_extension.dart';
import 'package:flutter_task_app/features/auth/login/screen/login_screen.dart';
import 'package:flutter_task_app/features/home/screen/home_screen.dart';
import 'package:flutter_task_app/features/splash/cubit/splash_cubit.dart';
import 'package:flutter_task_app/features/splash/cubit/splash_state.dart';
import 'package:flutter_task_app/features/splash/view/widgets/splash_screen_widgets.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    context.read<SplashCubit>().loadConfigAndCheckAuth();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<SplashCubit, SplashState>(
      listener: (context, state) {
       if (state is NavigateToHome) {
          log("SplashScreen Listener: NavigateToHome state received. Navigating to HomeScreen...");
          context.pushReplacement(pushReplacement: const HomeScreen());
        } else if (state is NavigateToLogin) {
          log("SplashScreen Listener: NavigateToLogin state received. Navigating to LoginScreen...");
          context.pushReplacement(pushReplacement: const LoginScreen());
        } else if (state is SplashError) {
          log("SplashScreen Listener: SplashError state received: ${state.message}. Navigating to LoginScreen as fallback...");
          context.pushReplacement(pushReplacement: const LoginScreen());
        }
      },
      child: const SplashScreenWidgets(),
    );
  }
}

