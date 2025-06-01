import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_task_app/core/extensions/navigation_extension.dart'; // Import navigation extension
import 'package:flutter_task_app/features/drag_drop/screen/drag_drop_screen.dart'; // Import DragDropScreen
import 'package:flutter_task_app/features/home/cubit/home_cubit.dart';
import 'package:flutter_task_app/features/home/cubit/home_state.dart';
import 'package:flutter_task_app/features/matching_pairs/screen/matching_screen.dart'; // Import MatchingScreen
import 'package:flutter_task_app/features/posts/view/post_screen.dart';
import 'package:flutter_task_app/features/profile/view/profile_screen.dart';
import 'package:flutter_task_app/features/quiz/view/quiz_screen.dart'; // Import QuizScreen

class TabBedHomeView extends StatelessWidget {
  const TabBedHomeView({super.key});

  final List<Widget> _pages = const [PostScreen(), ProfileScreen()];

  void _showGameSelection(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.0)),
      ),
      builder: (BuildContext bc) {
        return Container(
          padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 15.0),
          child: Wrap(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(bottom: 15.0),
                child: Center(
                  child: Text(
                    'Choose a Game',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              ListTile(
                leading: const Icon(
                  Icons.drag_handle,
                  color: Colors.blueAccent,
                ),
                title: const Text('Drag & Drop Sentence'),
                onTap: () {
                  Navigator.pop(bc); // Close the bottom sheet
                  log("Navigating to Drag & Drop Screen...");
                  context.pushWidget(push: const DragDropScreen());
                },
              ),
              ListTile(
                leading: const Icon(Icons.link, color: Colors.greenAccent),
                title: const Text('Matching Pairs'),
                onTap: () {
                  Navigator.pop(bc); // Close the bottom sheet
                  log("Navigating to Matching Pairs Screen...");
                  context.pushWidget(push: const MatchingScreen());
                },
              ),
              ListTile(
                leading: const Icon(Icons.quiz, color: Colors.orangeAccent),
                title: const Text('Custom Quiz'),
                onTap: () {
                  Navigator.pop(bc); // Close the bottom sheet
                  log("Navigating to Custom Quiz Screen...");
                  context.pushWidget(
                    push: const QuizScreen(quizId: "default_quiz_id"),
                  ); 
                },
              ),
            ],
          ),
        );
      },
    );
  }

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
                        // Implement search functionality if needed
                      },
                    ),
                  ]
                : null,
          ),
          body: IndexedStack(index: state.tabIndex, children: _pages),
          // Add FloatingActionButton to open game selection
          floatingActionButton: FloatingActionButton(
            onPressed: () => _showGameSelection(context),
            tooltip: 'Play Games',
            child: const Icon(Icons.gamepad_outlined),
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
