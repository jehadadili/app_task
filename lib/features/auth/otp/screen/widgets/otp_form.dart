import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_task_app/features/auth/otp/cubit/otp_cubit.dart';
import 'package:flutter_task_app/features/auth/otp/cubit/otp_state.dart';
import 'otp_form_controller.dart';
import 'otp_form_field.dart';

class OtpForm extends StatefulWidget {
  final String mobileNumber;

  const OtpForm({
    super.key,
    required this.mobileNumber,
  });

  @override
  State<OtpForm> createState() => _OtpFormState();
}

class _OtpFormState extends State<OtpForm> {
  late final OtpFormController _formController;

  @override
  void initState() {
    super.initState();
    _formController = OtpFormController();
  }

  @override
  void dispose() {
    _formController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final otpCubit = context.read<OtpCubit>();

    return Form(
      key: _formController.formKey,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Text(
            'Enter the ${_formController.getOtpLength}-digit code sent to ${widget.mobileNumber}',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 32.0),

          BlocBuilder<OtpCubit, OtpState>(
            builder: (context, state) {
              bool isLoading = state is OtpVerifying;
              
              return OtpFormField(
                controller: _formController,
                isEnabled: !isLoading,
              );
            },
          ),
          const SizedBox(height: 24.0),

          BlocBuilder<OtpCubit, OtpState>(
            builder: (context, state) {
              bool isLoading = state is OtpVerifying;
              
              return ElevatedButton(
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                ),
                onPressed: isLoading ? null : () {
                  if (_formController.validateForm()) {
                    otpCubit.verifyOtp(_formController.getOtpValue());
                  }
                },
                child: isLoading
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                    : const Text('Verify OTP'),
              );
            },
          ),
          const SizedBox(height: 16.0),

          BlocBuilder<OtpCubit, OtpState>(
            builder: (context, state) {
              bool isLoading = state is OtpVerifying;
              
              return TextButton(
                onPressed: isLoading ? null : () {
                  _formController.logResendOtp();
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Resend OTP functionality not implemented yet.'),
                    ),
                  );
                },
                child: const Text('Resend OTP'),
              );
            },
          ),
        ],
      ),
    );
  }
}