import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_task_app/data/models/matching_pairs_question_model.dart';
import 'package:flutter_task_app/features/matching_pairs/presentation/cubit/matching_pairs_state.dart';

class MatchingPairsCubit extends Cubit<MatchingPairsState> {
  MatchingPairsCubit() : super(MatchingPairsInitial()) {
    // Load a question when the cubit is created
    loadQuestion();
  }

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Assuming questions are stored in a 'matching_pairs_questions' collection
  Future<void> loadQuestion({String? questionId}) async {
    emit(MatchingPairsLoading());
    try {
      log("MatchingPairsCubit: Loading question...");
      DocumentSnapshot questionDoc;
      if (questionId != null) {
        questionDoc = await _firestore.collection('matching_pairs_questions').doc(questionId).get();
      } else {
        // Fetch the first question found if no ID is specified
        QuerySnapshot querySnapshot = await _firestore.collection('matching_pairs_questions').limit(1).get();
        if (querySnapshot.docs.isEmpty) {
          throw Exception('No Matching Pairs questions found in Firestore.');
        }
        questionDoc = querySnapshot.docs.first;
      }

      if (questionDoc.exists && questionDoc.data() != null) {
        MatchingPairsQuestionModel questionModel = MatchingPairsQuestionModel.fromMap(questionDoc.data() as Map<String, dynamic>, questionDoc.id);
        log("MatchingPairsCubit: Question loaded successfully: ${questionModel.id}");
        // Initialize user connections map with all question IDs pointing to null
        final initialConnections = { for (var item in questionModel.questions) item.id : null };
        emit(MatchingPairsLoaded(question: questionModel, userConnections: initialConnections));
      } else {
        log("MatchingPairsCubit: Question document not found.");
        emit(const MatchingPairsError("Question not found."));
      }
    } catch (e, stackTrace) {
      log('MatchingPairsCubit: Error loading question: $e', error: e, stackTrace: stackTrace);
      emit(MatchingPairsError('Failed to load question: ${e.toString()}'));
    }
  }

  // Method called by UI when a user connects a question item to an answer item
  void updateUserConnection(String questionId, String? answerId) {
     if (state is MatchingPairsLoaded) {
        final currentState = state as MatchingPairsLoaded;
        // Create a new map with the updated connection
        final updatedConnections = Map<String, String?>.from(currentState.userConnections);
        updatedConnections[questionId] = answerId;
        log("MatchingPairsCubit: Updated connection - Question $questionId -> Answer $answerId");
        // Emit new state with updated connections, clearing any previous result state
        emit(currentState.copyWith(userConnections: updatedConnections, clearResult: true));
     } else {
        log("MatchingPairsCubit: Cannot update connection when question is not loaded.");
     }
  }

  // Method called when the user submits their connections
  void submitAnswers() {
    if (state is MatchingPairsLoaded) {
      final currentState = state as MatchingPairsLoaded;
      log("MatchingPairsCubit: Submitting answers...");

      // Check if all questions have been connected
      bool allConnected = currentState.userConnections.values.every((answerId) => answerId != null);
      if (!allConnected) {
         log("MatchingPairsCubit: Not all items connected. Cannot submit yet.");
         // Optionally emit an error or feedback state
         // emit(currentState.copyWith(showResult: false)); // Or a specific feedback state
         return; // Prevent submission if not all connected
      }

      // Compare user connections with correct matches
      bool allCorrect = true;
      currentState.question.correctMatches.forEach((qId, correctAId) {
        if (currentState.userConnections[qId] != correctAId) {
          allCorrect = false;
        }
      });

      log("MatchingPairsCubit: Submission result - All Correct: $allCorrect");
      emit(currentState.copyWith(showResult: true, isCorrect: allCorrect));

    } else {
      log("MatchingPairsCubit: Cannot submit answers when question is not loaded.");
    }
  }
}

