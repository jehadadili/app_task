
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_task_app/features/auth/otp/cubit/otp_cubit.dart';
import 'package:flutter_task_app/features/auth/otp/cubit/otp_state.dart';
import 'package:flutter_task_app/features/auth/otp/screen/widgets/otp_form.dart';
import 'package:flutter_task_app/features/auth/register/cubit/register_cubit.dart';
import 'package:flutter_task_app/features/auth/register/cubit/register_state.dart';

class OtpScreen extends StatelessWidget {
  final String mobileNumber;
  final RegisterCubit registerCubit;

  const OtpScreen({
    super.key,
    required this.mobileNumber,
    required this.registerCubit,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => OtpCubit(registerCubit: registerCubit),
      child: OtpView(
        mobileNumber: mobileNumber, 
        registerCubit: registerCubit,
      ),
    );
  }
}

class OtpView extends StatelessWidget {
  final String mobileNumber;
  final RegisterCubit registerCubit;

  const OtpView({
    super.key,
    required this.mobileNumber,
    required this.registerCubit,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Verify OTP')),
      body: MultiBlocListener(
        listeners: [
          // الاستماع لحالة RegisterCubit
          BlocListener<RegisterCubit, RegisterState>(
            bloc: registerCubit,
            listener: (context, state) {
              if (state is RegisterSuccess) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Registration completed successfully!'),
                    backgroundColor: Colors.green,
                  ),
                );
                
                // العودة للشاشة الرئيسية أو شاشة تسجيل الدخول
                Navigator.of(context).popUntil((route) => route.isFirst);
              } else if (state is RegisterFailure) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(state.error),
                    backgroundColor: Colors.red,
                  ),
                );
              }
            },
          ),
          // الاستماع لحالة OtpCubit
          BlocListener<OtpCubit, OtpState>(
            listener: (context, state) {
              if (state is OtpVerificationFailure) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(state.error),
                    backgroundColor: Colors.red,
                  ),
                );
              } else if (state is OtpVerificationSuccess) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('OTP verified successfully!'),
                    backgroundColor: Colors.green,
                  ),
                );
              }
            },
          ),
        ],
        child: BlocBuilder<OtpCubit, OtpState>(
          builder: (context, state) {
            return Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  children: [
                    OtpForm(mobileNumber: mobileNumber),
                    const SizedBox(height: 20),
                    TextButton(
                      onPressed: state is OtpVerifying ? null : () {
                        context.read<OtpCubit>().resendOtp();
                      },
                      child: const Text('Resend OTP'),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}