
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_task_app/features/home/cubit/home_cubit.dart';
import 'package:flutter_task_app/features/home/cubit/home_state.dart';
import 'package:flutter_task_app/features/posts/view/post_screen.dart';
import 'package:flutter_task_app/features/profile/view/profile_screen.dart';

class TabBedHomeView extends StatelessWidget {
   const TabBedHomeView({super.key});

  final List<Widget> _pages = const [
    PostScreen(), 
    ProfileScreen(), 
  ];

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeCubit, HomeState>(
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            title: Text(state.tabIndex == 0 ? 'Posts' : 'Profile'), 
            actions: state.tabIndex == 0
                ? [
                    IconButton(
                      icon: const Icon(Icons.search),
                      onPressed: () {
                        log("Search icon pressed - Placeholder");
                      },
                    ),
                  ]
                : null,
          ),
          body: IndexedStack(
            index: state.tabIndex,
            children: _pages,
          ),
          bottomNavigationBar: BottomNavigationBar(
            currentIndex: state.tabIndex,
            onTap: (index) {
              context.read<HomeCubit>().changeTab(index);
            },
            items: const [
              BottomNavigationBarItem(
                icon: Icon(Icons.article), 
                label: 'Posts',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.person), 
                label: 'Profile',
              ),
            ],
          ),
        );
      },
    );
  }
}
