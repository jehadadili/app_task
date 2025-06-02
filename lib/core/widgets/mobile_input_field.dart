import 'dart:async';

import 'package:flutter/material.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:intl_phone_field/phone_number.dart';

class MobileInputField extends StatelessWidget {
  final String? hintText;
  final String? labelText;
  final Function(String) onChanged; 
  final TextEditingController? controller; 
  final bool enabled;
  final TextInputAction? textInputAction;
  final Function(String)? onFieldSubmitted; 
  final FocusNode? focusNode;
final FutureOr<String?> Function(PhoneNumber?)? validator;
  const MobileInputField({
    super.key,
    this.hintText,
    this.labelText,
    required this.onChanged,
    this.controller,
    this.enabled = true,
    this.textInputAction,
    this.onFieldSubmitted,
    this.focusNode, this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return IntlPhoneField(
      controller: controller, 
      focusNode: focusNode,
      enabled: enabled,
      validator: validator,
      keyboardType: TextInputType.phone,
      textInputAction: textInputAction ?? TextInputAction.next,
      decoration: InputDecoration(
        labelText: labelText ?? 'Mobile Number', 
        hintText: hintText ?? '', 
        filled: true,
        fillColor: const Color(0xFFC6C6C6).withAlpha(102), 
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8.0)),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
          borderSide: BorderSide(color: Colors.grey.shade400),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
          borderSide: const BorderSide(color: Color(0xff152e67), width: 2.0),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
          borderSide: const BorderSide(color: Colors.red, width: 2.0),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
          borderSide: const BorderSide(color: Colors.red, width: 2.0),
        ),
      ),
      initialCountryCode: 'JO', 
      onChanged: (PhoneNumber phoneNumber) {
        onChanged(phoneNumber.completeNumber);
      },
      onSubmitted: onFieldSubmitted, 
    
    );
  }
}


