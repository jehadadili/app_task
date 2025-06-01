abstract class RegisterState {}

class RegisterInitial extends RegisterState {}

class RegisterLoading extends RegisterState {}

class RegisterOtpRequired extends RegisterState {
  final String mobileNumber;
  final String? verificationId;
  RegisterOtpRequired(this.mobileNumber, {this.verificationId});
}

class RegisterMobileVerified extends RegisterState {}

class RegisterSuccess extends RegisterState {}

class RegisterFailure extends RegisterState {
  final String error;
  RegisterFailure(this.error);
}
