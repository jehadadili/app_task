import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_task_app/features/auth/presentation/view/login_screen.dart';
import 'package:flutter_task_app/features/home/home_screen.dart';
import 'package:flutter_task_app/features/splash/presentation/cubit/splash_cubit.dart';
import 'package:flutter_task_app/features/splash/presentation/cubit/splash_state.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
   
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<SplashCubit, SplashState>(
      listener: (context, state) {
      
        Timer(const Duration(seconds: 2), () { 
          if (!mounted) return; 

          if (state is SplashLoaded) {
            if (state.isAuthenticated) {
              log("Navigate to Home");
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const HomeScreen()),
              );
            } else {
              log("Navigate to Login");
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const LoginScreen()),
              );
            }
          } else if (state is SplashError) {
            log("Navigate to Login on Error: ${state.message}");
            // Show error message
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Error loading config: ${state.message}')),
            );
            // Navigate to Login even on error, as per typical flow
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const LoginScreen()),
            );
          }
        });
      },
      child: Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const Icon(Icons.flutter_dash, size: 150, color: Colors.blue),
              const SizedBox(height: 20),
              BlocBuilder<SplashCubit, SplashState>(
                builder: (context, state) {
                  if (state is SplashLoading || state is SplashInitial) {
                    return const CircularProgressIndicator();
                  }
                  return const SizedBox.shrink();
                },
              ),
              const Spacer(),
              const Padding(
                padding: EdgeInsets.only(bottom: 30.0),
                child: Text(
                  '© 2024 LearnWell', 
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

