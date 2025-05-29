import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String uid;
  final String email;
  final String fullName;
  final String mobileNumber;
  final int age;
  final String gender;
  final DateTime? createdAt;

  UserModel({
    required this.uid,
    required this.email,
    required this.fullName,
    required this.mobileNumber,
    required this.age,
    required this.gender,
    this.createdAt,
  });

  factory UserModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return UserModel(
      uid: doc.id,
      email: data['email'] ?? '',
      fullName: data['fullName'] ?? '',
      mobileNumber: data['mobileNumber'] ?? '',
      age: data['age'] ?? 0,
      gender: data['gender'] ?? '',
      createdAt: data['createdAt'] != null 
          ? (data['createdAt'] as Timestamp).toDate() 
          : null,
    );
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      uid: map['uid'] ?? '',
      email: map['email'] ?? '',
      fullName: map['fullName'] ?? '',
      mobileNumber: map['mobileNumber'] ?? '',
      age: map['age'] ?? 0,
      gender: map['gender'] ?? '',
      createdAt: map['createdAt'] != null 
          ? (map['createdAt'] as Timestamp).toDate() 
          : null,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'email': email,
      'fullName': fullName,
      'mobileNumber': mobileNumber,
      'age': age,
      'gender': gender,
      'createdAt': FieldValue.serverTimestamp(),
    };
  }


 

}