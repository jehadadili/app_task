import 'package:flutter/material.dart';
import 'logout_confirmation_dialog.dart';

class LogoutButton extends StatelessWidget {
  final EdgeInsetsGeometry padding;
  final Color backgroundColor;
  final Color foregroundColor;

  const LogoutButton({
    super.key,
    this.padding = const EdgeInsets.symmetric(vertical: 16.0),
    this.backgroundColor = Colors.redAccent,
    this.foregroundColor = Colors.white,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      icon: const Icon(Icons.logout),
      label: const Text('Logout'),
      style: ElevatedButton.styleFrom(
        backgroundColor: backgroundColor,
        foregroundColor: foregroundColor,
        padding: padding,
      ),
      onPressed: () {
        LogoutConfirmationDialog.show(context);
      },
    );
  }
}