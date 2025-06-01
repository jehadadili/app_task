import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_task_app/core/extensions/navigation_extension.dart'; // Import the extension
import 'package:flutter_task_app/features/auth/login/screen/login_screen.dart'; // Import LoginScreen
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
    context.read<SplashCubit>().loadConfigAndNavigate();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<SplashCubit, SplashState>(
      listener: (context, state) {
        if (state is SplashLoaded) {
          log("SplashLoaded: Navigating to Login Screen...");
          context.pushReplacement(pushReplacement: const LoginScreen());
        } else if (state is SplashError) {
          log("SplashError: ${state.message}");

          context.pushReplacement(pushReplacement: const LoginScreen());
        }
      },
      child: SplashScreenWidgets(),
    );
  }
}
