import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/material.dart';

class LoginFormController {
  final TextEditingController mobileController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final FocusNode mobileFocusNode = FocusNode();
  final FocusNode passwordFocusNode = FocusNode();

  // Store the selected country code
  CountryCode selectedCountry = CountryCode.fromCountryCode('JO'); // Default to Jordan

  // Method to update the selected country code
  void updateSelectedCountry(CountryCode country) {
    selectedCountry = country;
  }

  // Getter for the full E.164 mobile number
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

