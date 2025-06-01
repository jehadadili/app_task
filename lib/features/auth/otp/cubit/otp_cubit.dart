import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:flutter_task_app/features/auth/otp/cubit/otp_state.dart';
import 'package:flutter_task_app/features/auth/register/cubit/register_cubit.dart';

class OtpCubit extends Cubit<OtpState> {
  final RegisterCubit registerCubit;

  OtpCubit({required this.registerCubit}) : super(OtpInitial());

  Future<void> verifyOtp(String otpCode) async {
    if (otpCode.length != 6) {
      emit(OtpVerificationFailure("Invalid OTP format. Please enter 6 digits."));
      return;
    }

    emit(OtpVerifying());

    try {
      // استدعاء التحقق من الـ OTP في RegisterCubit
      await registerCubit.verifyOtpAndCompleteRegistration(otpCode);
      emit(OtpVerificationSuccess());
    } catch (e) {
      log("OTP Verification Failed: $e");
      emit(OtpVerificationFailure("OTP verification failed. Please try again."));
    }
  }

  Future<void> resendOtp() async {
    try {
      await registerCubit.resendOtp();
    } catch (e) {
      log("Resend OTP Failed: $e");
      emit(OtpVerificationFailure("Failed to resend OTP. Please try again."));
    }
  }
}