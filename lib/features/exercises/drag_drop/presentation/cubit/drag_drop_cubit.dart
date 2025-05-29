import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';

part 'drag_drop_state.dart';

class DragDropCubit extends Cubit<DragDropState> {
  DragDropCubit() : super(DragDropInitial());

  void checkAnswer(String droppedAnswer, String correctAnswer) {
    if (droppedAnswer == correctAnswer) {
      emit(DragDropCorrect());
    } else {
      emit(DragDropIncorrect());
    }
  }

  void reset() {
    emit(DragDropInitial());
  }
}

