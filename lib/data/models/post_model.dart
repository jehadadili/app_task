class PostModel {
  final int id;
  final String title;
  final String body;
  final int userId; // Assuming the API provides this
  // Add other relevant fields based on the actual API response, e.g., image URL, timestamp
  final String? imageUrl;
  final DateTime? createdAt;

  PostModel({
    required this.id,
    required this.title,
    required this.body,
    required this.userId,
    this.imageUrl,
    this.createdAt,
  });

  // Factory constructor to create a PostModel from JSON data
  factory PostModel.fromJson(Map<String, dynamic> json) {
    // Basic example, adjust based on actual API structure
    return PostModel(
      id: json['id'] as int? ?? 0,
      title: json['title'] as String? ?? 'No Title',
      body: json['body'] as String? ?? 'No Content',
      userId: json['userId'] as int? ?? 0,
      // Example for optional fields
      imageUrl: json['imageUrl'] as String?,
      createdAt: json['createdAt'] != null ? DateTime.tryParse(json['createdAt']) : null,
    );
  }

  // Method to convert a PostModel instance to JSON (less common for read-only data)
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'body': body,
      'userId': userId,
      'imageUrl': imageUrl,
      'createdAt': createdAt?.toIso8601String(),
    };
  }
}

