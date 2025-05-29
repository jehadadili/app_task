// TODO: Implement Register Screen UI
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_task_app/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:flutter_task_app/features/auth/presentation/view/login_screen.dart';
import 'package:flutter_task_app/features/auth/presentation/view/otp_screen.dart';


class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _fullNameController = TextEditingController();
  final _mobileController = TextEditingController();
  final _ageController = TextEditingController(); 
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  String? _selectedGender;
  final String _selectedCountryCode = '+1'; 

  @override
  void dispose() {
    _fullNameController.dispose();
    _mobileController.dispose();
    _ageController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _showErrorDialog(String message) {
    // Replace with the user's custom myAlertDialog if available
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Registration Error'),
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
      appBar: AppBar(title: const Text('Register')),
      body: BlocListener<AuthCubit, AuthState>(
        listener: (context, state) {
          if (state is AuthCodeSentSuccess) {
            // Navigate to OTP screen upon successful code sending
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => OTPScreen(
                  verificationId: state.verificationId,
                  // Pass necessary registration data to OTP screen or store temporarily
                  // For simplicity, we might re-collect it after OTP verification
                  // or pass it along.
                  // Example passing data:
                  fullName: _fullNameController.text.trim(),
                  mobileNumber: '$_selectedCountryCode${_mobileController.text.trim()}',
                  age: int.tryParse(_ageController.text.trim()) ?? 0,
                  gender: _selectedGender ?? '',
                  password: _passwordController.text.trim(),
                  // Need email for Firebase Auth - How is this obtained?
                  // Assuming email = mobile + domain or similar for now.
                  // **This needs clarification based on actual requirements.**
                  email: '${_mobileController.text.trim()}@example.com', // Placeholder email
                ),
              ),
            );
          } else if (state is AuthError) {
            _showErrorDialog(state.message);
          } else if (state is AuthRegistrationSuccess) {
             // This state might be triggered after OTP verification + profile save
             log("Registration successful, navigating to Login.");
             ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Registration Successful! Please login.')),
             );
             // Navigate back to Login screen after successful registration
             Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => const LoginScreen()),
                (Route<dynamic> route) => false, // Remove all previous routes
             );
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
                      SizedBox(height: 20.h),
                      Text(
                        'Create Account',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 24.sp, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 30.h),

                      // 1. Full Name
                      TextFormField(
                        controller: _fullNameController,
                        decoration: const InputDecoration(
                          labelText: 'Full Name',
                          hintText: 'Enter your full name',
                          border: OutlineInputBorder(),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your full name';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 16.h),

                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 16.h), // Adjust padding
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey),
                              borderRadius: BorderRadius.circular(4.r),
                            ),
                            child: Text(_selectedCountryCode), 
                          ),
                          SizedBox(width: 8.w),
                          Expanded(
                            child: TextFormField(
                              controller: _mobileController,
                              decoration: const InputDecoration(
                                labelText: 'Mobile Number',
                                hintText: 'Enter mobile number',
                                border: OutlineInputBorder(),
                              ),
                              keyboardType: TextInputType.phone,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter your mobile number';
                                }
                                return null;
                              },
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 16.h),

                      // 3. Age Picker
                      TextFormField(
                        controller: _ageController,
                        decoration: const InputDecoration(
                          labelText: 'Age',
                          hintText: 'Enter your age',
                          border: OutlineInputBorder(),
                        ),
                        keyboardType: TextInputType.number,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your age';
                          }
                          if (int.tryParse(value) == null || int.parse(value) <= 0) {
                             return 'Please enter a valid age';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 16.h),

                      // 4. Gender Dropdown
                      DropdownButtonFormField<String>(
                        value: _selectedGender,
                        decoration: const InputDecoration(
                          labelText: 'Gender',
                          border: OutlineInputBorder(),
                        ),
                        items: <String>['Male', 'Female', 'Other']
                            .map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                        onChanged: (String? newValue) {
                          setState(() {
                            _selectedGender = newValue;
                          });
                        },
                        validator: (value) => value == null ? 'Please select your gender' : null,
                      ),
                      SizedBox(height: 16.h),

                      // 5. Password
                      TextFormField(
                        controller: _passwordController,
                        decoration: const InputDecoration(
                          labelText: 'Password',
                          hintText: 'Enter your password',
                          border: OutlineInputBorder(),
                        ),
                        obscureText: true,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter a password';
                          }
                          if (value.length < 6) { // Example basic validation
                             return 'Password must be at least 6 characters';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 16.h),

                      // 6. Confirm Password
                      TextFormField(
                        controller: _confirmPasswordController,
                        decoration: const InputDecoration(
                          labelText: 'Confirm Password',
                          hintText: 'Re-enter your password',
                          border: OutlineInputBorder(),
                        ),
                        obscureText: true,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please confirm your password';
                          }
                          if (value != _passwordController.text) {
                            return 'Passwords do not match';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 24.h),

                      // 7. Register Button
                      BlocBuilder<AuthCubit, AuthState>(
                         builder: (context, state) {
                            return ElevatedButton(
                              onPressed: state is AuthLoading ? null : () {
                                if (_formKey.currentState!.validate()) {
                                  final fullPhoneNumber = '$_selectedCountryCode${_mobileController.text.trim()}';
                                  log("Requesting OTP for: $fullPhoneNumber");
                                  authCubit.sendOtp(phoneNumber: fullPhoneNumber);
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
                                  : const Text('Register'),
                            );
                         },
                      ),
                      SizedBox(height: 30.h), // Add some bottom padding
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

