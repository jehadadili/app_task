
class MatchingQuizItem {
  final String id;
  final String text;
  MatchingQuizItem({required this.id, required this.text});
  factory MatchingQuizItem.fromMap(Map<String, dynamic> map) {
     return MatchingQuizItem(id: map["id"] ?? 	"", text: map["text"] ?? "");
  }
}