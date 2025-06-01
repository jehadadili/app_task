import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_task_app/features/auth/otp/cubit/otp_cubit.dart';
import 'package:flutter_task_app/features/auth/otp/cubit/otp_state.dart';
import 'package:flutter_task_app/features/auth/otp/screen/widgets/otp_code_fields.dart';
import 'package:flutter_task_app/features/auth/otp/screen/widgets/otp_header_texts.dart';
import 'package:flutter_task_app/features/auth/otp/screen/widgets/otp_verify_button.dart';

class OtpForm extends StatefulWidget {
  final String mobileNumber;

  const OtpForm({super.key, required this.mobileNumber});

  @override
  State<OtpForm> createState() => _OtpFormState();
}

class _OtpFormState extends State<OtpForm> {
  final _formKey = GlobalKey<FormState>();
  late final List<TextEditingController> _controllers;
  late final List<FocusNode> _focusNodes;

  @override
  void initState() {
    super.initState();
    _controllers = List.generate(6, (_) => TextEditingController());
    _focusNodes = List.generate(6, (_) => FocusNode());
  }

  @override
  void dispose() {
    for (var controller in _controllers) {
      controller.dispose();
    }
    for (var node in _focusNodes) {
      node.dispose();
    }
    super.dispose();
  }

  void _verifyOtp() {
    final otpCode = _controllers.map((e) => e.text).join();
    if (otpCode.length == 6) {
      context.read<OtpCubit>().verifyOtp(otpCode);
    }
  }

  void _clearOtp() {
    for (var controller in _controllers) {
      controller.clear();
    }
    _focusNodes[0].requestFocus();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<OtpCubit, OtpState>(
      builder: (context, state) {
        final isLoading = state is OtpVerifying;

        return Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              OtpHeaderTexts(mobileNumber: widget.mobileNumber),
              const SizedBox(height: 48),
              OtpCodeFields(
                controllers: _controllers,
                focusNodes: _focusNodes,
                isLoading: isLoading,
                onAllFilled: _verifyOtp,
              ),
              const SizedBox(height: 32),
              OtpVerifyButton(isLoading: isLoading, onPressed: _verifyOtp),
              const SizedBox(height: 16),
              TextButton(
                onPressed: isLoading ? null : _clearOtp,
                child: const Text('Clear'),
              ),
              const SizedBox(height: 32),
              Text(
                "Didn't receive the code?",
                style: TextStyle(color: Colors.grey[600], fontSize: 14),
              ),
            ],
          ),
        );
      },
    );
  }
}
