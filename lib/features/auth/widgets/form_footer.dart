import 'package:flutter/material.dart';

class FormFooter extends StatelessWidget {
  final String text;
  final String buttonText;
  final VoidCallback? onPressed;
  final bool enabled;

  const FormFooter({
    super.key,
    required this.text,
    required this.buttonText,
    this.onPressed,
    this.enabled = true,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(text, style: const TextStyle(fontSize: 16, color: Colors.black54)),
        TextButton(
          onPressed: onPressed,
          child: Text(
            buttonText,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
              color: Color(0xff152e67),
            ),
          ),
        ),
      ],
    );
  }
}

class FormContainer extends StatelessWidget {
  final Widget child;
  final EdgeInsets? padding;
  final bool scrollable;

  const FormContainer({
    super.key,
    required this.child,
    this.padding,
    this.scrollable = true,
  });

  @override
  Widget build(BuildContext context) {
    Widget content = Padding(
      padding: padding ?? const EdgeInsets.all(24.0),
      child: child,
    );

    if (scrollable) {
      return SingleChildScrollView(child: content);
    }

    return content;
  }
}
