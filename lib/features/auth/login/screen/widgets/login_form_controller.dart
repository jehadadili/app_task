import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/material.dart';

class LoginFormController {
  final TextEditingController mobileController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final FocusNode mobileFocusNode = FocusNode();
  final FocusNode passwordFocusNode = FocusNode();

  CountryCode selectedCountry = CountryCode.fromCountryCode('JO');

  void updateSelectedCountry(CountryCode country) {
    selectedCountry = country;
  }

  String get fullMobileNumber => '${selectedCountry.dialCode}${mobileController.text.trim()}';

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

