import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UserRepository {
  final FirebaseFirestore _firestore;

  UserRepository({FirebaseFirestore? firestore}) 
      : _firestore = firestore ?? FirebaseFirestore.instance;

  Future<bool> userExistsWithMobile(String mobile) async {
    try {
      var existingUserQuery = await _firestore
          .collection('users')
          .where('mobile', isEqualTo: mobile)
          .limit(1)
          .get();

      return existingUserQuery.docs.isNotEmpty;
    } catch (e) {
      log("Error checking user existence: $e");
      throw Exception("Failed to check user existence");
    }
  }

  Future<void> saveUserData({
    required User user,
    required String fullName,
    required String mobile,
    required int age,
    required String gender,
    required String password,
  }) async {
    try {
      log("Saving user data to Firestore for UID: ${user.uid}");
      log("Mobile format for DB: $mobile");

      await _firestore.collection('users').doc(user.uid).set({
        'uid': user.uid,
        'fullName': fullName,
        'mobile': mobile,
        'age': age,
        'gender': gender,
        'password': password,
        'phoneNumber': user.phoneNumber,
        'createdAt': FieldValue.serverTimestamp(),
      });

      log("User data saved successfully to Firestore.");
    } catch (e) {
      log("Firestore save failed: $e");
      throw Exception('Failed to complete saving registration data: ${e.toString()}');
    }
  }
}