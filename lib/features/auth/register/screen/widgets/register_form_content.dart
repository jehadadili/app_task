
import 'package:flutter/material.dart';
import 'package:flutter_task_app/features/auth/register/model/registration_data.dart';

class RegisterFormContent extends ChangeNotifier {
  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _mobileController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();

  int? _selectedAge;
  String? _selectedGender;
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  RegisterFormContent({String? initialMobileNumber}) {
    if (initialMobileNumber != null) {
      _mobileController.text = initialMobileNumber;
    }
  }

  // Getters
  TextEditingController get fullNameController => _fullNameController;
  TextEditingController get mobileController => _mobileController;
  TextEditingController get passwordController => _passwordController;
  TextEditingController get confirmPasswordController => _confirmPasswordController;
  
  int? get selectedAge => _selectedAge;
  String? get selectedGender => _selectedGender;
  bool get obscurePassword => _obscurePassword;
  bool get obscureConfirmPassword => _obscureConfirmPassword;

  // Setters
  void setAge(int? age) {
    _selectedAge = age;
    notifyListeners();
  }

  void setGender(String? gender) {
    _selectedGender = gender;
    notifyListeners();
  }

  void togglePasswordVisibility() {
    _obscurePassword = !_obscurePassword;
    notifyListeners();
  }

  void toggleConfirmPasswordVisibility() {
    _obscureConfirmPassword = !_obscureConfirmPassword;
    notifyListeners();
  }

  RegistrationData getRegistrationData() {
    return RegistrationData(
      fullName: _fullNameController.text.trim(),
      mobile: _mobileController.text.trim(),
      age: _selectedAge,
      gender: _selectedGender,
      password: _passwordController.text,
      confirmPassword: _confirmPasswordController.text,
    );
  }

  @override
  void dispose() {
    _fullNameController.dispose();
    _mobileController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }
}