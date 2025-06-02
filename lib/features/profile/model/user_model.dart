import 'package:cloud_firestore/cloud_firestore.dart';

class UserProfile {
  final String uid;
  final String fullName;
  final String mobile;
  final int age;
  final String gender;
  final String email;

  UserProfile({
    required this.uid,
    required this.fullName,
    required this.mobile,
    required this.age,
    required this.gender,
    required this.email,
  });

  factory UserProfile.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return UserProfile(
      uid: data['uid'] ?? '',
      fullName: data['fullName'] ?? 'N/A',
      mobile: data['mobile'] ?? 'N/A',
      age: data['age'] ?? 0,
      gender: data['gender'] ?? 'N/A',
      email: data['email'] ?? 'N/A',
    );
  }
}
