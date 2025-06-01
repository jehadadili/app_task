

import 'package:flutter/material.dart';
import 'package:flutter_task_app/core/widgets/custom_text_field.dart';

class NameField extends StatelessWidget {
  final String? labelText;
  final String? hintText;
  final TextEditingController? controller;
  final FocusNode? focusNode;
  final bool enabled;
  final TextInputAction? textInputAction;
  final Function(String)? onFieldSubmitted;
  final String? Function(String?)? validator;
  final Function(String)? onChanged;

  const NameField({
    super.key,
    this.labelText,
    this.hintText,
    this.controller,
    this.focusNode,
    this.enabled = true,
    this.textInputAction,
    this.onFieldSubmitted,
    this.validator,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return CustomTextField(
      controller: controller,
      focusNode: focusNode,
      enabled: enabled,
      labelText: labelText ?? 'Full Name',
      hintText: hintText ?? 'Enter your full name',
      prefixIcon: Icons.person,
      textInputAction: textInputAction,
      onFieldSubmitted: onFieldSubmitted,
      validator: validator,
      onChanged: onChanged ?? (value) {},
    );
  }
}
