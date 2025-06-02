import 'package:flutter/material.dart';

class FormHeader extends StatelessWidget {
  final String? logoPath;
  final String? title;
  final String? subtitle;
  final IconData? icon;
  final double? iconSize;
  final Color? iconColor;

  const FormHeader({
    super.key,
    this.logoPath,
    this.title,
    this.subtitle,
    this.icon,
    this.iconSize,
    this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (logoPath != null)
          LayoutBuilder(
            builder: (context, constraints) {
              double logoSize = constraints.maxWidth * 0.8;
              double logoSizeh = constraints.maxWidth * 0.4;
              return Image.asset(logoPath!, width: logoSize, height: logoSizeh);
            },
          ),
      ],
    );
  }
}
