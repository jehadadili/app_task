import 'package:flutter_task_app/core/config/firebase_config.dart';


abstract class SplashState {}

class SplashInitial extends SplashState {}

class SplashLoading extends SplashState {}

class SplashLoaded extends SplashState {
  final FirebaseConfig config;
  SplashLoaded(this.config);
}

class SplashError extends SplashState {
  final String message;
  SplashError(this.message);
}
