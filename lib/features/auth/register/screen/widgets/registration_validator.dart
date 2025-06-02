import 'package:flutter_task_app/core/validators/validators.dart';
import 'package:flutter_task_app/core/config/firebase_config.dart';
import 'package:flutter_task_app/features/auth/register/services/phone_formatter.dart';

class RegistrationValidator {
  final FirebaseConfig firebaseConfig;

  RegistrationValidator({required this.firebaseConfig});

  String? validateRegistrationData({
    required String fullName,
    required String mobile,
    required int? age,
    required String? gender,
    required String password,
    required String confirmPassword,
  }) {
    final nameError = Validators.validateName(fullName);
    if (nameError != null) return nameError;

    if (!PhoneFormatter.isValid(mobile)) {
      return 'Phone number must be 9 digits and start with 7';
    }

    final ageError = Validators.validateAge(age?.toString());
    if (ageError != null) return ageError;

    if (gender == null || gender.isEmpty) {
      return 'Sex is required';
    }

    final passwordError = Validators.validatePassword(
      password,
      customRegex: firebaseConfig.passwordRegex,
    );
    if (passwordError != null) {
      return 'Invalid password: $passwordError';
    }

    final confirmPasswordError = Validators.validateConfirmPassword(
      confirmPassword,
      password,
    );
    if (confirmPasswordError != null) {
      return confirmPasswordError;
    }

    return null; 
  }

  String? validateOtpCode(String otpCode) {
    if (otpCode.length != 6) {
      return "The verification code must be 6 digits";
    }
    return null;
  }
}