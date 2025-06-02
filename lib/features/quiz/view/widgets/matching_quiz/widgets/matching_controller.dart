
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_task_app/features/quiz/model/matching_quiz_question.dart';

class MatchingController {
  final MatchingQuestion question;
  final Function(Map<String, String>) onAnswerSelected;
  
  Map<String, String> userMatches = {};
  String? selectedLeft;
  String? selectedRight;
  
  final Map<String, GlobalKey> leftKeys = {};
  final Map<String, GlobalKey> rightKeys = {};
  
  Offset? lineStartPoint;
  Offset? lineEndPoint;

  MatchingController({
    required this.question,
    required this.onAnswerSelected,
  }) {
    _initializeKeys();
  }

  void _initializeKeys() {
    for (String item in question.leftItems) {
      leftKeys[item] = GlobalKey();
    }
    for (String item in question.rightItems) {
      rightKeys[item] = GlobalKey();
    }
  }

  Offset? getLeftItemCenterRight(String item) {
    final key = leftKeys[item];
    if (key?.currentContext != null) {
      final RenderBox renderBox =
          key!.currentContext!.findRenderObject() as RenderBox;
      final position = renderBox.localToGlobal(Offset.zero);
      return Offset(
        position.dx + renderBox.size.width,
        position.dy + renderBox.size.height / 2,
      );
    }
    return null;
  }

  void handlePointerMove(PointerMoveEvent event, StateSetter setState) {
    if (selectedLeft != null && lineStartPoint != null) {
      setState(() {
        lineEndPoint = event.position;
      });
    }
  }

  void handleTap(String item, bool isLeft, bool isAnswered, StateSetter setState) {
    if (isAnswered) return;
    log("Tapped: $item, isLeft: $isLeft");

    setState(() {
      if (isLeft) {
        _handleLeftItemTap(item);
      } else {
        _handleRightItemTap(item);
      }
      log("Current matches: $userMatches");
      log("Selected Left: $selectedLeft, Selected Right: $selectedRight");
    });
  }

  void _handleLeftItemTap(String item) {
    if (userMatches.containsKey(item)) {
      log("Removing existing match for left item: $item");
      userMatches.remove(item);
      selectedLeft = null;
      lineStartPoint = null;
      lineEndPoint = null;
    } else if (selectedLeft == item) {
      log("Deselecting left item: $item");
      selectedLeft = null;
      lineStartPoint = null;
      lineEndPoint = null;
    } else {
      log("Selecting left item: $item");
      selectedLeft = item;
      selectedRight = null;
      lineStartPoint = getLeftItemCenterRight(item);
      lineEndPoint = lineStartPoint;
    }
  }

  void _handleRightItemTap(String item) {
    if (selectedLeft != null) {
      String? existingLeftMatch = userMatches.entries
          .firstWhere(
            (entry) => entry.value == item,
            orElse: () => const MapEntry("", ""),
          )
          .key;

      if (existingLeftMatch.isNotEmpty && existingLeftMatch != selectedLeft) {
        log("Right item '$item' already matched with '$existingLeftMatch'. Removing old match.");
        userMatches.remove(existingLeftMatch);
      }

      log("Matching left '$selectedLeft' with right '$item'");
      userMatches[selectedLeft!] = item;
      onAnswerSelected(Map.from(userMatches));
      selectedLeft = null;
      selectedRight = null;
      lineStartPoint = null;
      lineEndPoint = null;
    } else {
      String? matchedLeftKey = userMatches.entries
          .firstWhere(
            (entry) => entry.value == item,
            orElse: () => const MapEntry<String, String>("", ""),
          )
          .key;
      if (matchedLeftKey.isNotEmpty) {
        log("Removing existing match for right item: $item");
        userMatches.remove(matchedLeftKey);
        selectedRight = null;
        lineStartPoint = null;
        lineEndPoint = null;
      }
    }
  }
}
