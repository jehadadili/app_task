part of 'auth_cubit.dart';

@immutable
abstract class AuthState {}

class AuthInitial extends AuthState {}

class AuthLoading extends AuthState {}

class AuthCodeSentSuccess extends AuthState {
  final String verificationId;
  AuthCodeSentSuccess({required this.verificationId});
}

class AuthVerificationFailure extends AuthState {
  final String message;
  final String verificationId;
  
  AuthVerificationFailure(this.message, this.verificationId);
}

class AuthVerificationSuccess extends AuthState {
  final String verificationId;
  
  AuthVerificationSuccess({required this.verificationId});
}

class AuthLoggedIn extends AuthState {
  final User user;
  AuthLoggedIn({required this.user});
}

class AuthLoggedOut extends AuthState {}

class AuthNeedsRegistration extends AuthState {}

class AuthNeedsProfileSetup extends AuthState {
  final User user;
  
  AuthNeedsProfileSetup({required this.user});
}

class AuthRegistrationSuccess extends AuthState {}

class AuthError extends AuthState {
  final String message;
  AuthError(this.message);
}