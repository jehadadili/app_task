import 'package:flutter/material.dart';
import 'package:flutter_task_app/features/posts/view/post_screen.dart';
import 'package:flutter_task_app/features/profile/view/profile_screen.dart';

class HomePages extends StatelessWidget {
  final int tabIndex;

  const HomePages({super.key, required this.tabIndex});

  static const List<Widget> _pages = [
    PostScreen(),
    ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return IndexedStack(
      index: tabIndex,
      children: _pages,
    );
  }
}
