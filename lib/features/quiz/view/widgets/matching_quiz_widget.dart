
import 'package:flutter/material.dart';
import 'package:flutter_task_app/features/quiz/model/matching_quiz_item.dart';

import 'package:flutter_task_app/features/quiz/model/matching_quiz_question.dart';
import 'package:flutter_task_app/features/quiz/view/widgets/quiz_connections_painter.dart';

class QuizMatchConnection {
  final String fromId;
  final String toId;

  QuizMatchConnection({required this.fromId, required this.toId});

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is QuizMatchConnection &&
          runtimeType == other.runtimeType &&
          ((fromId == other.fromId && toId == other.toId) ||
           (fromId == other.toId && toId == other.fromId));

  @override
  int get hashCode => fromId.hashCode ^ toId.hashCode;

  
  Map<String, String> toMapEntry() {
    
     if (fromId.startsWith('l')) {
        return {fromId: toId};
     } else {
        return {toId: fromId};
     }
  }
}

class MatchingQuizWidget extends StatefulWidget {
  final MatchingQuizQuestion question;
  final Function(Map<String, String>) onPairsSubmitted; 
  final bool answerSubmitted;
  final Map<String, String>? userAnswer; 

  const MatchingQuizWidget({
    super.key,
    required this.question,
    required this.onPairsSubmitted,
    required this.answerSubmitted,
    this.userAnswer,
  });

  @override
  State<MatchingQuizWidget> createState() => _MatchingQuizWidgetState();
}

class _MatchingQuizWidgetState extends State<MatchingQuizWidget> {
  final Map<String, GlobalKey> _itemKeys = {};
  List<QuizMatchConnection> _connections = [];
  String? _selectedItemId;

  @override
  void initState() {
    super.initState();
    _initializeKeys();
    if (widget.answerSubmitted && widget.userAnswer != null) {
      _connections = widget.userAnswer!.entries
          .map((entry) => QuizMatchConnection(fromId: entry.key, toId: entry.value))
          .toList();
    }
  }

 @override
  void didUpdateWidget(covariant MatchingQuizWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.question.id != oldWidget.question.id) {
      _initializeKeys();
      _selectedItemId = null;
      if (widget.answerSubmitted && widget.userAnswer != null) {
         _connections = widget.userAnswer!.entries
             .map((entry) => QuizMatchConnection(fromId: entry.key, toId: entry.value))
             .toList();
      } else {
         _connections = [];
      }
    }
    else if (widget.answerSubmitted && !oldWidget.answerSubmitted && widget.userAnswer != null) {
       _connections = widget.userAnswer!.entries
           .map((entry) => QuizMatchConnection(fromId: entry.key, toId: entry.value))
           .toList();
       _selectedItemId = null;

    }
  }

  void _initializeKeys() {
    _itemKeys.clear();
    for (var item in [...widget.question.leftItems, ...widget.question.rightItems]) {
      _itemKeys[item.id] = GlobalKey();
    }
  }

  void _handleItemTap(String itemId) {
    if (widget.answerSubmitted) return; 

    setState(() {
      if (_selectedItemId == null) {
        _selectedItemId = itemId;
      } else {
        final firstItem = _findItem(_selectedItemId!);
        final secondItem = _findItem(itemId);

        if (firstItem != null && secondItem != null && _isLeftItem(firstItem.id) != _isLeftItem(secondItem.id)) {
          final newConnection = QuizMatchConnection(fromId: _selectedItemId!, toId: itemId);

          _connections.removeWhere((conn) =>
              conn.fromId == _selectedItemId || conn.toId == _selectedItemId ||
              conn.fromId == itemId || conn.toId == itemId);

          _connections.add(newConnection);
          _selectedItemId = null; 

          if (_connections.length == widget.question.leftItems.length) {
             _submitFinalAnswers();
          }

        } else {
          _selectedItemId = itemId;
        }
      }
    });
  }

  MatchingQuizItem? _findItem(String id) {
    try {
      return widget.question.leftItems.firstWhere((item) => item.id == id);
    } catch (e) {
      try {
        return widget.question.rightItems.firstWhere((item) => item.id == id);
      } catch (e) {
        return null;
      }
    }
  }

  bool _isLeftItem(String id) {

     return widget.question.leftItems.any((item) => item.id == id);
  }

  void _submitFinalAnswers() {
     if (widget.answerSubmitted) return;
     Map<String, String> submittedPairs = {};
     for (var conn in _connections) {
        if (_isLeftItem(conn.fromId)) {
           submittedPairs[conn.fromId] = conn.toId;
        } else {
           submittedPairs[conn.toId] = conn.fromId;
        }
     }
     widget.onPairsSubmitted(submittedPairs);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 16.0),
          child: Text(
            widget.question.questionText,
            style: Theme.of(context).textTheme.headlineMedium,
            textAlign: TextAlign.center,
          ),
        ),
        Expanded(
          child: Stack(
            children: [
              CustomPaint(
                size: Size.infinite,
                painter: QuizConnectionsPainter(
                  itemKeys: _itemKeys,
                  connections: _connections,
                  selectedItemId: _selectedItemId,
                  submitted: widget.answerSubmitted,
                  correctPairs: widget.question.correctPairs,
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildQuizItemList(widget.question.leftItems),
                  _buildQuizItemList(widget.question.rightItems),
                ],
              ),
            ],
          ),
        ),
         
      ],
    );
  }

  Widget _buildQuizItemList(List<MatchingQuizItem> items) {
    return Expanded(
      child: ListView.builder(
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
        itemCount: items.length,
        itemBuilder: (context, index) {
          final item = items[index];
          final key = _itemKeys[item.id]!;
          final bool isSelected = item.id == _selectedItemId;
          bool? isCorrect;

          if (widget.answerSubmitted && widget.userAnswer != null) {
             final String? userMatchedId = _isLeftItem(item.id)
                ? widget.userAnswer![item.id]
                : widget.userAnswer!.entries.firstWhere((entry) => entry.value == item.id, orElse: () => const MapEntry('', '')).key;


             if (userMatchedId != null && userMatchedId.isNotEmpty) {
                isCorrect = _isLeftItem(item.id)
                   ? widget.question.correctPairs[item.id] == userMatchedId
                   : widget.question.correctPairs[userMatchedId] == item.id;
             }
          }

          return Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 15.0),
              child: GestureDetector(
                onTap: () => _handleItemTap(item.id),
                child: Container(
                  key: key,
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  decoration: BoxDecoration(
                    color: isSelected ? Colors.blue.shade100 : (isCorrect == true ? Colors.green.shade100 : (isCorrect == false ? Colors.red.shade100 : Colors.grey.shade200)),
                    border: Border.all(
                      color: isSelected ? Colors.blue : (isCorrect == true ? Colors.green : (isCorrect == false ? Colors.red : Colors.grey)),
                      width: isSelected ? 2.0 : 1.0,
                    ),
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: Text(item.text, textAlign: TextAlign.center),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
