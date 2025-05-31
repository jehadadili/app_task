import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_task_app/features/auth/otp/cubit/otp_cubit.dart';
import 'package:flutter_task_app/features/auth/otp/cubit/otp_state.dart';
import 'package:flutter_task_app/features/auth/otp/screen/widgets/otp_form.dart';
import 'package:flutter_task_app/features/auth/register/cubit/register_cubit.dart';

class OtpScreen extends StatelessWidget {
  final String? verificationId;
  final String mobileNumber;

  const OtpScreen({
    super.key,
    required this.verificationId,
    required this.mobileNumber,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => OtpCubit(verificationId: verificationId),
      child: OtpView(mobileNumber: mobileNumber),
    );
  }
}

class OtpView extends StatelessWidget {
  final String mobileNumber;

  const OtpView({
    super.key,
    required this.mobileNumber,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Verify OTP')),
      body: BlocConsumer<OtpCubit, OtpState>(
        listener: (context, state) {
          if (state is OtpVerificationFailure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.error),
                backgroundColor: Colors.red,
              ),
            );
          }
          if (state is OtpVerificationSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Mobile Number Verified!'),
                backgroundColor: Colors.green,
              ),
            );
            try {
              context.read<RegisterCubit>().completeRegistrationAfterOtp();
            } catch (e) {
              log("Error accessing RegisterCubit: $e. Ensure it's provided.");
            }
            Navigator.of(context).pop();
          }
        },
        builder: (context, state) {
          return Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24.0),
              child: OtpForm(mobileNumber: mobileNumber),
            ),
          );
        },
      ),
    );
  }
}