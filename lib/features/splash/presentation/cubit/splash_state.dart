

abstract class SplashState {}

class SplashInitial extends SplashState {}

class SplashLoading extends SplashState {}

class SplashLoaded extends SplashState {
  final bool isAuthenticated; 

  SplashLoaded({required this.isAuthenticated});
}

class SplashError extends SplashState {
  final String message;

  SplashError(this.message);
}

