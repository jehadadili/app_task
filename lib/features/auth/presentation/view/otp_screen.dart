import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_task_app/features/auth/presentation/cubit/auth_cubit.dart';


class OTPScreen extends StatefulWidget {
  final String verificationId;
  final String email;
  final String password;
  final String fullName;
  final String mobileNumber;
  final int age;
  final String gender;

  const OTPScreen({
    super.key,
    required this.verificationId,
    required this.email,
    required this.password,
    required this.fullName,
    required this.mobileNumber,
    required this.age,
    required this.gender,
  });

  @override
  State<OTPScreen> createState() => _OTPScreenState();
}

class _OTPScreenState extends State<OTPScreen> {
  final _otpController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _otpController.dispose();
    super.dispose();
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('OTP Verification Error'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final authCubit = BlocProvider.of<AuthCubit>(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Verify Mobile Number')),
      body: BlocListener<AuthCubit, AuthState>(
        listener: (context, state) {
          if (state is AuthVerificationSuccess) {
            log("OTP Verified, proceeding to final registration step.");
            authCubit.registerUser(
              email: widget.email,
              password: widget.password,
              fullName: widget.fullName,
              mobileNumber: widget.mobileNumber,
              age: widget.age,
              gender: widget.gender,
              verificationId: state.verificationId,
              smsCode: _otpController.text.trim(), 
            );
            Navigator.of(context).pop(); 
          } else if (state is AuthVerificationFailure) {
            _showErrorDialog("Invalid OTP. Please try again. (${state.message})");
          } else if (state is AuthError) {
            _showErrorDialog(state.message);
          }
        },
        child: SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 24.w),
            child: Center(
              child: SingleChildScrollView(
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      Text(
                        'Enter the code we just sent you',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 18.sp),
                      ),
                      SizedBox(height: 8.h),
                      Text(
                        'Please enter the 4-digit code sent to your mobile number.', 
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 14.sp, color: Colors.grey[600]),
                      ),
                      SizedBox(height: 40.h),

                      TextFormField(
                        controller: _otpController,
                        decoration: const InputDecoration(
                          labelText: 'OTP Code',
                          hintText: 'Enter the 4 or 6 digit code',
                          border: OutlineInputBorder(),
                        ),
                        keyboardType: TextInputType.number,
                        maxLength: 6, 
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 20.sp, letterSpacing: 8.w),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter the OTP';
                          }
                          if (value.length < 4 || value.length > 6) { // Adjust length check
                             return 'OTP must be 4 or 6 digits';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 30.h),

                      // 2. Verify Button
                      BlocBuilder<AuthCubit, AuthState>(
                        builder: (context, state) {
                          return ElevatedButton(
                            onPressed: state is AuthLoading
                                ? null
                                : () {
                                    if (_formKey.currentState!.validate()) {
                                      authCubit.verifyOtp(
                                        otp: _otpController.text.trim(),
                                        verificationId: widget.verificationId, // Pass the initial verification ID
                                      );
                                    }
                                  },
                            style: ElevatedButton.styleFrom(
                              padding: EdgeInsets.symmetric(vertical: 16.h),
                              textStyle: TextStyle(fontSize: 16.sp),
                            ),
                            child: state is AuthLoading
                                ? const SizedBox(
                                    height: 20,
                                    width: 20,
                                    child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                                  )
                                : const Text('Verify'),
                          );
                        },
                      ),
                      SizedBox(height: 20.h),
                      TextButton(
                        onPressed: () {
                          log("Resend OTP clicked - functionality to be implemented");
                        },
                        child: const Text('Resend Code'),
                      ),
                       SizedBox(height: 30.h), 
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

