import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:flutter_task_app/features/exercises/matching/presentation/cubit/matching_state.dart';


class MatchingCubit extends Cubit<MatchingState> {
  MatchingCubit() : super(MatchingInitial());

  List<String> _leftItems = [];
  List<String> _rightItems = [];
  Map<String, String> _correctMatches = {}; 
  Map<String, String?> _userConnections = {}; 

  void loadPairs() {
    emit(MatchingInitial()); 
    try {
      _leftItems = ['Flutter', 'Firebase', 'Dart'];
      _rightItems = ['UI Framework', 'Backend', 'Language']; 
      _correctMatches = {
        'Flutter': 'UI Framework',
        'Firebase': 'Backend',
        'Dart': 'Language',
      };
      _userConnections = {};
      log("--- Placeholder: Matching pairs loaded ---");
      emit(MatchingLoaded(leftItems: _leftItems, rightItems: _rightItems));
    } catch (e) {
      emit(MatchingError("Failed to load matching pairs: ${e.toString()}"));
    }
  }

  void connectPair(String leftItem, String rightItem) {
    _userConnections[leftItem] = rightItem;
    log("User connected: $leftItem -> $rightItem");
   
  }

  void submitMatches() {
    emit(MatchingChecking());
    int correctCount = 0;
    _userConnections.forEach((left, right) {
      if (_correctMatches[left] == right) {
        correctCount++;
      }
    });
    log("--- Placeholder: Checking matches --- ");
    log("Correct Matches: $correctCount / ${_correctMatches.length}");
    emit(MatchingResult(correctMatches: correctCount, totalPairs: _correctMatches.length));
  }

  void reset() {
    loadPairs(); 
  }
}

