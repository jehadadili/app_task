import 'dart:developer';
import 'package:flutter/material.dart';

class OtpFormController {
  final TextEditingController _otpController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final int otpLength = 6;

  // Getters
  TextEditingController get otpController => _otpController;
  GlobalKey<FormState> get formKey => _formKey;
  int get getOtpLength => otpLength;

  // Validation method
  String? validateOtp(String? value) {
    if (value == null || value.isEmpty) {
      return 'OTP is required';
    }
    if (value.length != otpLength) {
      return 'OTP must be $otpLength digits';
    }
    if (!RegExp(r'^\d+$').hasMatch(value)) {
      return 'OTP must contain only numbers';
    }
    return null;
  }

  // Get trimmed OTP value
  String getOtpValue() {
    return _otpController.text.trim();
  }

  // Validate form
  bool validateForm() {
    return _formKey.currentState?.validate() ?? false;
  }

  // Clear OTP field
  void clearOtp() {
    _otpController.clear();
  }

  // Dispose method
  void dispose() {
    _otpController.dispose();
  }

  // Log resend OTP action
  void logResendOtp() {
    log("Resend OTP clicked - Placeholder");
  }
}