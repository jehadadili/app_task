
abstract class DragDropState {}

class DragDropInitial extends DragDropState {
  final String sentence = "Flutter is a _____ framework."; 
  final List<String> options = const ['React', 'mobile', 'cross-platform', 'native'];
  final String correctAnswer = 'cross-platform';
  final String? droppedAnswer;

  DragDropInitial({this.droppedAnswer});
}

class DragDropAnswerDropped extends DragDropState {
  final String sentence = "Flutter is a _____ framework.";
  final List<String> options = const ['React', 'mobile', 'cross-platform', 'native'];
  final String correctAnswer = 'cross-platform';
  final String droppedAnswer;

  DragDropAnswerDropped(this.droppedAnswer);
}

class DragDropCorrect extends DragDropState {
   final String message = "Correct!"; 
}

class DragDropIncorrect extends DragDropState {
   final String message = "Incorrect. Try again!"; 
   final String? droppedAnswer; 

   DragDropIncorrect(this.droppedAnswer);
}
