
import 'package:flutter/material.dart';

class LoginFormController {
  final TextEditingController mobileController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final FocusNode mobileFocusNode = FocusNode();
  final FocusNode passwordFocusNode = FocusNode();

  String get fullMobileNumber => '+962 ${mobileController.text.trim()}';

  void dispose() {
    mobileController.dispose();
    passwordController.dispose();
    mobileFocusNode.dispose();
    passwordFocusNode.dispose();
  }

  void focusPassword() {
    passwordFocusNode.requestFocus();
  }
}
