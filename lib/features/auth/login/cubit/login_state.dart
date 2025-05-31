
abstract class LoginState {}

class LoginInitial extends LoginState {}

class LoginLoading extends LoginState {}

class LoginSuccess extends LoginState {
}

class LoginFailure extends LoginState {
  final String error;
  LoginFailure(this.error);
}

class LoginUserNotRegistered extends LoginState {
  final String mobileNumber; 
  LoginUserNotRegistered(this.mobileNumber);
}
