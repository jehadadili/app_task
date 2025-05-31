import 'package:flutter/material.dart';
import 'otp_form_controller.dart';

class OtpFormField extends StatelessWidget {
  final OtpFormController controller;
  final bool isEnabled;

  const OtpFormField({
    super.key,
    required this.controller,
    required this.isEnabled,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller.otpController,
      decoration: InputDecoration(
        labelText: 'OTP Code',
        border: const OutlineInputBorder(),
        hintText: 'Enter ${controller.getOtpLength} digits',
      ),
      keyboardType: TextInputType.number,
      maxLength: controller.getOtpLength,
      textAlign: TextAlign.center,
      validator: controller.validateOtp,
      enabled: isEnabled,
    );
  }
}