enum ExerciseType {
  dragAndDrop,
  matchingPairs,
  multipleChoice, // For Quiz
  // Add other types if needed
}

class DragDropQuestionModel {
  final String id;
  final String sentenceTemplate; // e.g., "Flutter is a _____ framework."
  final List<String> draggableOptions;
  final String correctAnswer;
  final ExerciseType type = ExerciseType.dragAndDrop;

  DragDropQuestionModel({
    required this.id,
    required this.sentenceTemplate,
    required this.draggableOptions,
    required this.correctAnswer,
  });

  // Factory constructor from Firestore data (example)
  factory DragDropQuestionModel.fromMap(Map<String, dynamic> map, String documentId) {
    return DragDropQuestionModel(
      id: documentId,
      sentenceTemplate: map["sentenceTemplate"] as String? ?? "",
      // Ensure options are stored as a list in Firestore
      draggableOptions: List<String>.from(map["draggableOptions"] as List<dynamic>? ?? []),
      correctAnswer: map["correctAnswer"] as String? ?? "",
    );
  }

  // Method to convert to map for Firestore (if needed)
  Map<String, dynamic> toMap() {
    return {
      "sentenceTemplate": sentenceTemplate,
      "draggableOptions": draggableOptions,
      "correctAnswer": correctAnswer,
      "type": type.name, // Store type as string
    };
  }
}

