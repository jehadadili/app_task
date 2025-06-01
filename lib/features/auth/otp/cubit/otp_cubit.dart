import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:flutter_task_app/features/auth/otp/cubit/otp_state.dart';

class OtpCubit extends Cubit<OtpState> {
  final String? verificationId;

  OtpCubit({this.verificationId}) : super(OtpInitial());

  Future<void> verifyOtp(String otpCode) async {
    if (verificationId == null) {
      emit(
        OtpVerificationFailure("Verification process not initiated correctly."),
      );
      return;
    }
    if (otpCode.length != 6) {
      emit(
        OtpVerificationFailure("Invalid OTP format. Please enter 6 digits."),
      );
      return;
    }

    emit(OtpVerifying());

    try {
      log(
        "Simulating OTP Verification for code: $otpCode with verificationId: $verificationId",
      );

      await Future.delayed(const Duration(seconds: 2));

      log("OTP Verification Simulation Successful");
      emit(OtpVerificationSuccess());
    } catch (e) {
      log("OTP Verification Simulation Failed: $e");
      emit(
        OtpVerificationFailure("OTP verification failed. Please try again."),
      ); // Needs localization
    }
  }
}
