import 'package:flutter/material.dart';

class GenderDropdownField extends StatelessWidget {
  final String? selectedGender;
  final void Function(String?)? onChanged;

  const GenderDropdownField({
    super.key,
    required this.selectedGender,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<String>(
      value: selectedGender,
      decoration: const InputDecoration(
        labelText: 'Gender',
        border: OutlineInputBorder(),
      ),
      items: _buildGenderItems(),
      onChanged: onChanged,
      validator: (value) => value == null ? 'Gender is required' : null,
    );
  }

  List<DropdownMenuItem<String>> _buildGenderItems() {
    return ['Male', 'Female', 'Other']
        .map((gender) => DropdownMenuItem(
              value: gender,
              child: Text(gender),
            ))
        .toList();
  }
}