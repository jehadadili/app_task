class UserModel {
  final String uid; // Firebase Auth UID
  final String fullName;
  final String mobileNumber;
  final int age;
  final String gender;
  final String email; // Assuming email is needed for Firebase Auth

  UserModel({
    required this.uid,
    required this.fullName,
    required this.mobileNumber,
    required this.age,
    required this.gender,
    required this.email,
  });

  // Factory constructor for creating a new UserModel instance from a map (e.g., Firestore data)
  factory UserModel.fromMap(Map<String, dynamic> map, String documentId) {
    return UserModel(
      uid: documentId, // Use Firestore document ID as UID if not stored separately
      fullName: map['fullName'] as String? ?? '',
      mobileNumber: map['mobileNumber'] as String? ?? '',
      age: map['age'] as int? ?? 0,
      gender: map['gender'] as String? ?? '',
      email: map['email'] as String? ?? '', // Assuming email is stored
    );
  }

  // Method for converting a UserModel instance to a map (e.g., for saving to Firestore)
  Map<String, dynamic> toMap() {
    return {
      'fullName': fullName,
      'mobileNumber': mobileNumber,
      'age': age,
      'gender': gender,
      'email': email, // Assuming email is stored
      // uid is often the document ID, so might not be stored within the document itself
    };
  }
}

