
class MatchItem {
  final String id;
  final String text;
  final String group; 

  MatchItem({required this.id, required this.text, required this.group});
}

class MatchConnection {
  final String fromId;
  final String toId;

  MatchConnection({required this.fromId, required this.toId});

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MatchConnection &&
          runtimeType == other.runtimeType &&
          ((fromId == other.fromId && toId == other.toId) ||
           (fromId == other.toId && toId == other.fromId)); 

  @override
  int get hashCode => fromId.hashCode ^ toId.hashCode;
}