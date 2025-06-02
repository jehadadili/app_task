import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_task_app/core/extensions/navigation_extension.dart';
import 'package:flutter_task_app/features/drag_drop/screen/drag_drop_screen.dart';
import 'package:flutter_task_app/features/matching_pairs/screen/matching_screen.dart';
import 'package:flutter_task_app/features/quiz/view/quiz_screen.dart';

class GameBottomSheet {
  static void show(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.0)),
      ),
      builder: (BuildContext bc) {
        return Container(
          padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 15.0),
          child: Wrap(
            children: [
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
              _gameTile(
                context: context,
                icon: Icons.drag_handle,
                color: Colors.blueAccent,
                title: 'Drag & Drop Sentence',
                destination: const DragDropScreen(),
              ),
              _gameTile(
                context: context,
                icon: Icons.link,
                color: Colors.greenAccent,
                title: 'Matching Pairs',
                destination: const MatchingScreen(),
              ),
              _gameTile(
                context: context,
                icon: Icons.quiz,
                color: Colors.orangeAccent,
                title: 'Custom Quiz',
                destination: const QuizScreen(),
              ),
            ],
          ),
        );
      },
    );
  }

  static Widget _gameTile({
    required BuildContext context,
    required IconData icon,
    required Color color,
    required String title,
    required Widget destination,
  }) {
    return ListTile(
      leading: Icon(icon, color: color),
      title: Text(title),
      onTap: () {
        Navigator.pop(context);
        log("Navigating to $title...");
        context.pushWidget(push: destination);
      },
    );
  }
}
