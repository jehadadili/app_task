import 'package:flutter_task_app/core/config/firebase_config.dart';

abstract class SplashState {}

class SplashInitial extends SplashState {}

class SplashLoading extends SplashState {}

class NavigateToLogin extends SplashState {
  final FirebaseConfig config;
  NavigateToLogin(this.config);
}

class NavigateToHome extends SplashState {
  final FirebaseConfig config;
  NavigateToHome(this.config);
}

class SplashError extends SplashState {
  final String message;
  final FirebaseConfig config; // Include config for fallback
  SplashError(this.message, this.config);
}

