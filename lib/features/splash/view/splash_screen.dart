import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_task_app/features/splash/cubit/splash_cubit.dart';
import 'package:flutter_task_app/features/splash/cubit/splash_state.dart';

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
        
        } else if (state is SplashError) {
          log("SplashError: ${state.message}");
        
        }
      },
      child: Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              FlutterLogo(size: 150),
              SizedBox(height: 20),
              BlocBuilder<SplashCubit, SplashState>(
                builder: (context, state) {
                  if (state is SplashLoading) {
                    return CircularProgressIndicator();
                  }
                  return SizedBox.shrink(); 
                },
              ),
              Spacer(),               Padding(
                padding: const EdgeInsets.only(bottom: 30.0),
                child: Text(
                  '© ${DateTime.now().year} Framework Technologies. All rights reserved.', // Placeholder copyright
                  style: TextStyle(fontSize: 12, color: Colors.grey),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
