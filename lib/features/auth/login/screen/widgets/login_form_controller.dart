
import 'package:flutter/material.dart';
import 'package:flutter_task_app/features/auth/login/model/login_data.dart';

class LoginFormController extends ChangeNotifier {
  final TextEditingController _mobileController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _obscurePassword = true;

  TextEditingController get mobileController => _mobileController;
  TextEditingController get passwordController => _passwordController;
  bool get obscurePassword => _obscurePassword;

  void togglePasswordVisibility() {
    _obscurePassword = !_obscurePassword;
    notifyListeners();
  }

  LoginData getLoginData() {
    return LoginData(
      mobile: _mobileController.text.trim(),
      password: _passwordController.text.trim(),
    );
  }

  @override
  void dispose() {
    _mobileController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}