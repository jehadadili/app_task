
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_task_app/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:flutter_task_app/features/auth/presentation/view/register_screen.dart';
import 'package:flutter_task_app/features/home/home_screen.dart';


class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _mobileController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _mobileController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _showErrorDialog(String message) {
    // Replace with the user's custom myAlertDialog if available
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Login Error'),
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

  void _showRegistrationDialog() {
     // Replace with the user's custom myAlertDialog if available
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Not Registered'),
        content: const Text('This phone number is not registered. Would you like to register?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(); // Close dialog
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const RegisterScreen()),
              );
            },
            child: const Text('Register'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Ensure AuthCubit is provided higher up the widget tree
    final authCubit = BlocProvider.of<AuthCubit>(context);

    return Scaffold(
      // appBar: AppBar(title: const Text('Login')), // Removed AppBar for cleaner look like screenshot
      body: BlocListener<AuthCubit, AuthState>(
        listener: (context, state) {
          if (state is AuthLoggedIn) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const HomeScreen()),
            );
          } else if (state is AuthNeedsRegistration) {
            _showRegistrationDialog();
          } else if (state is AuthError) {
            _showErrorDialog(state.message);
          }
        },
        child: SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 24.w), // Use ScreenUtil
            child: Center(
              child: SingleChildScrollView(
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      Icon(Icons.flutter_dash, size: 80.sp, color: Theme.of(context).primaryColor),
                      SizedBox(height: 20.h),
                      Text(
                        'Welcome back',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 24.sp, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 40.h),
                      
                      TextFormField(
                        controller: _mobileController,
                        decoration: const InputDecoration(
                          labelText: 'Mobile Number',
                          hintText: 'Enter your mobile number',
                          border: OutlineInputBorder(),
                          prefixIcon: Icon(Icons.phone),
                        ),
                        keyboardType: TextInputType.phone,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your mobile number';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 16.h),

                      TextFormField(
                        controller: _passwordController,
                        decoration: const InputDecoration(
                          labelText: 'Password',
                          hintText: 'Enter your password',
                          border: OutlineInputBorder(),
                          prefixIcon: Icon(Icons.lock),
                        ),
                        obscureText: true,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your password';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 24.h),

                      BlocBuilder<AuthCubit, AuthState>(
                        builder: (context, state) {
                          return ElevatedButton(
                            onPressed: state is AuthLoading
                                ? null
                                : () {
                                    if (_formKey.currentState!.validate()) {
                                    
                                      authCubit.loginWithPhoneNumberAndPassword(
                                        phoneNumber: _mobileController.text.trim(),
                                        password: _passwordController.text.trim(),
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
                                    child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white)
                                  )
                                : const Text('Login'),
                          );
                        },
                      ),
                      SizedBox(height: 16.h),

                      // 4. Underlined "Register" Text
                      Center(
                        child: RichText(
                          text: TextSpan(
                            text: 'Don\'t have an account? ',
                            style: TextStyle(color: Colors.black54, fontSize: 14.sp),
                            children: <TextSpan>[
                              TextSpan(
                                text: 'Register',
                                style: TextStyle(
                                  color: Theme.of(context).primaryColor,
                                  decoration: TextDecoration.underline,
                                  fontWeight: FontWeight.bold,
                                ),
                                recognizer: TapGestureRecognizer()
                                  ..onTap = () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(builder: (context) => const RegisterScreen()),
                                    );
                                  },
                              ),
                            ],
                          ),
                        ),
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

