
abstract class OtpState {}

class OtpInitial extends OtpState {}

class OtpVerifying extends OtpState {}

class OtpVerificationSuccess extends OtpState {
}

class OtpVerificationFailure extends OtpState {
  final String error;
  OtpVerificationFailure(this.error);
}
