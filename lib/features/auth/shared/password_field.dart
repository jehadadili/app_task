
import 'package:flutter/material.dart';
import 'package:flutter_task_app/core/widgets/custom_text_field.dart';

class PasswordField extends StatefulWidget {
  final String? labelText;
  final String? hintText;
  final TextEditingController? controller;
  final FocusNode? focusNode;
  final bool enabled;
  final TextInputAction? textInputAction;
  final Function(String)? onFieldSubmitted;
  final String? Function(String?)? validator;
  final Function(String)? onChanged;

  const PasswordField({
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
  State<PasswordField> createState() => _PasswordFieldState();
}

class _PasswordFieldState extends State<PasswordField> {
  bool _isPasswordVisible = false;

  @override
  Widget build(BuildContext context) {
    return CustomTextField(
      controller: widget.controller,
      focusNode: widget.focusNode,
      enabled: widget.enabled,
      labelText: widget.labelText ?? 'Password',
      hintText: widget.hintText ?? 'Enter your password',
      prefixIcon: Icons.lock,
      obscureText: !_isPasswordVisible,
      textInputAction: widget.textInputAction,
      onFieldSubmitted: widget.onFieldSubmitted,
      validator: widget.validator,
      onChanged: widget.onChanged ?? (value) {},
      suffixIcon: IconButton(
        icon: Icon(
          _isPasswordVisible ? Icons.visibility_off : Icons.visibility,
        ),
        onPressed: () {
          setState(() {
            _isPasswordVisible = !_isPasswordVisible;
          });
        },
      ),
    );
  }
}