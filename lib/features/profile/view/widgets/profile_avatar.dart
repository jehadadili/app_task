import 'package:flutter/material.dart';

class ProfileAvatar extends StatelessWidget {
  final double radius;
  final double iconSize;

  const ProfileAvatar({
    super.key,
    this.radius = 50,
    this.iconSize = 50,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: CircleAvatar(
        radius: radius,
        child: Icon(Icons.person, size: iconSize),
      ),
    );
  }
}