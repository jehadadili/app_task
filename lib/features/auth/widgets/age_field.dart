
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_task_app/core/widgets/custom_text_field.dart';

class AgeField extends StatelessWidget {
  final TextEditingController? controller;
  final FocusNode? focusNode;
  final bool enabled;
  final TextInputAction? textInputAction;
  final Function(String)? onFieldSubmitted;
  final String? Function(String?)? validator;
  final Function(String)? onChanged;

  const AgeField({
    super.key,
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
      labelText: 'Age',
      hintText: 'Enter your age',
      prefixIcon: Icons.calendar_today,
      keyboardType: TextInputType.number,
      inputFormatters: [
        FilteringTextInputFormatter.digitsOnly,
        LengthLimitingTextInputFormatter(3),
      ],
      textInputAction: textInputAction,
      onFieldSubmitted: onFieldSubmitted,
      validator: validator,
      onChanged: onChanged ?? (value) {},
    );
  }
}
