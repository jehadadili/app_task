import 'package:bloc/bloc.dart';
import 'package:flutter_task_app/features/drag_drop/cubit/drag_drop_state.dart';


class DragDropCubit extends Cubit<DragDropState> {
  DragDropCubit() : super(DragDropInitial());

  void answerDropped(String droppedAnswer) {
    emit(DragDropAnswerDropped(droppedAnswer));

    validateAnswer(droppedAnswer);
  }

  void validateAnswer(String answer) {
  
    const String correctAnswer = 'cross-platform';

    if (answer == correctAnswer) {
      emit(DragDropCorrect());
    } else {
      emit(DragDropIncorrect(answer));
    }
  }

  void resetExercise() {
    emit(DragDropInitial());
  }
}
