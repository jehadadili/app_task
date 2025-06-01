import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_task_app/features/auth/otp/screen/otp_screen.dart';
import 'package:flutter_task_app/features/auth/register/cubit/register_cubit.dart';
import 'package:flutter_task_app/features/auth/register/cubit/register_state.dart';

class RegisterFormListener extends StatelessWidget {
  final Widget child;

  const RegisterFormListener({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return BlocListener<RegisterCubit, RegisterState>(
      listener: (context, state) {
        if (state is RegisterOtpRequired) {
          Navigator.of(context).push(MaterialPageRoute(
            builder: (_) => OtpScreen(
              mobileNumber: state.mobileNumber,
              registerCubit: context.read<RegisterCubit>(),
            ),
          ));
        } else if (state is RegisterFailure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.error), backgroundColor: Colors.red),
          );
        } else if (state is RegisterSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Registration completed successfully!'),
              backgroundColor: Colors.green,
            ),
          );
          Navigator.of(context).popUntil((route) => route.isFirst);
        }
      },
      child: child,
    );
  }
}
