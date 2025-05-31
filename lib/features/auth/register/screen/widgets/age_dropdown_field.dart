import 'package:flutter/material.dart';
import 'package:flutter_task_app/core/validators/validators.dart';

class AgeDropdownField extends StatelessWidget {
  final int? selectedAge;
  final void Function(int?)? onChanged;

  const AgeDropdownField({
    super.key,
    required this.selectedAge,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<int>(
      value: selectedAge,
      decoration: const InputDecoration(
        labelText: 'Age',
        border: OutlineInputBorder(),
      ),
      items: _buildAgeItems(),
      onChanged: onChanged,
      validator: Validators.validateAge,
    );
  }

  List<DropdownMenuItem<int>> _buildAgeItems() {
    return List.generate(88, (index) => index + 13)
        .map((age) => DropdownMenuItem(
              value: age,
              child: Text(age.toString()),
            ))
        .toList();
  }
}