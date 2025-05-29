import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  String? _verificationId;

  AuthCubit() : super(AuthInitial());

  Future<void> loginWithPhoneNumberAndPassword({
    required String phoneNumber, 
    required String password,
  }) async {
    emit(AuthLoading());
    try {
      log("--- Attempting Login --- ");
      log("Phone Number: $phoneNumber");

      final querySnapshot = await _firestore
          .collection('users')
          .where('mobileNumber', isEqualTo: phoneNumber)
          .limit(1)
          .get();

      if (querySnapshot.docs.isEmpty) {
        log("User not registered with phone number: $phoneNumber");
        emit(AuthNeedsRegistration());
        return;
      }

      final userDoc = querySnapshot.docs.first;
      final uid = userDoc.id;
      
      final email = userDoc.data()['email'] as String?; 
      if (email == null) {
        log("Email not found for user $uid. Cannot perform standard Firebase login.");
        emit(AuthError("Login configuration error: Email not linked."));
        return;
      }

      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email, 
        password: password,
      );

      log("Login successful for user: ${userCredential.user?.uid}");

      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('user_email', email);
      await prefs.setBool('is_logged_in', true);
      await prefs.setString('user_uid', userCredential.user!.uid);

      emit(AuthLoggedIn(user: userCredential.user!));

    } on FirebaseAuthException catch (e) {
      log("Firebase Auth Error during login: ${e.code} - ${e.message}");
      if (e.code == 'user-not-found' || e.code == 'invalid-email') {
        emit(AuthNeedsRegistration());
      } else if (e.code == 'wrong-password' || e.code == 'invalid-credential') {
        emit(AuthError("Incorrect password. Please try again."));
      } else {
        emit(AuthError("Login failed: ${e.message ?? 'Unknown error'}"));
      }
    } catch (e) {
      log("General Error during login: ${e.toString()}");
      emit(AuthError("An unexpected error occurred during login: ${e.toString()}"));
    }
  }

  Future<void> sendOtp({required String phoneNumber}) async {
    emit(AuthLoading());
    try {
      log("--- Sending OTP --- ");
      log("Phone Number: $phoneNumber");

      final querySnapshot = await _firestore
          .collection('users')
          .where('mobileNumber', isEqualTo: phoneNumber)
          .limit(1)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        log("Phone number already registered.");
        emit(AuthError("This phone number is already registered. Please login."));
        return;
      }

      await _auth.verifyPhoneNumber(
        phoneNumber: phoneNumber,
        verificationCompleted: (PhoneAuthCredential credential) async {
          log("--- Phone Verification Completed Automatically --- ");
        },
        verificationFailed: (FirebaseAuthException e) {
          log("--- Phone Verification Failed --- ");
          log("Error Code: ${e.code}");
          log("Error Message: ${e.message}");
          emit(AuthError("Verification Failed: ${e.message ?? 'Unknown error'}"));
        },
        codeSent: (String verificationId, int? resendToken) {
          log("--- OTP Code Sent --- ");
          log("Verification ID: $verificationId");
          _verificationId = verificationId;
          emit(AuthCodeSentSuccess(verificationId: verificationId));
        },
        codeAutoRetrievalTimeout: (String verificationId) {
          log("--- OTP Code Auto Retrieval Timeout --- ");
          _verificationId = verificationId;
        },
        timeout: const Duration(seconds: 60),
      );
    } catch (e) {
      log("Error sending OTP: ${e.toString()}");
      emit(AuthError("Failed to send OTP: ${e.toString()}"));
    }
  }

  Future<void> verifyOtp({required String otp, required String verificationId}) async {
    _verificationId = verificationId; 
    if (_verificationId == null) {
      emit(AuthError("Verification ID not found. Please request OTP again."));
      return;
    }
    emit(AuthLoading());
    try {
      log("--- Verifying OTP --- ");
      log("Verification ID: $_verificationId");
      log("OTP Code: $otp");

      PhoneAuthCredential credential = PhoneAuthProvider.credential(
        verificationId: _verificationId!,
        smsCode: otp,
      );
      
      // Verify the OTP without signing in permanently
      await _auth.signInWithCredential(credential); 
      User? tempUser = _auth.currentUser;
      await _auth.signOut(); 
      
      if (tempUser != null) {
        log("OTP Verified Successfully for temp user: ${tempUser.uid}");
        emit(AuthVerificationSuccess(verificationId: _verificationId!));
      } else {
        throw FirebaseAuthException(
          code: 'otp-verification-failed', 
          message: 'Could not verify OTP.'
        );
      }

    } on FirebaseAuthException catch (e) {
      log("--- OTP Verification Failed --- ");
      log("Error Code: ${e.code}");
      log("Error Message: ${e.message}");
      emit(AuthVerificationFailure(
        "Verification Failed: ${e.message ?? 'Invalid OTP'}",
        _verificationId!,
      ));
    } catch (e) {
      log("Error verifying OTP: ${e.toString()}");
      emit(AuthError("Failed to verify OTP: ${e.toString()}"));
    }
  }

  Future<void> registerUser({
    required String email,
    required String password,
    required String fullName,
    required String mobileNumber,
    required int age,
    required String gender,
    required String verificationId,
    required String smsCode,
  }) async {
    emit(AuthLoading());
    try {
      log("--- Registering User --- ");
      log("Email: $email");
      log("Mobile: $mobileNumber");

      // 1. Create user with email and password
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      User? user = userCredential.user;

      if (user == null) {
        throw Exception("User creation failed.");
      }
      log("Firebase Auth user created: ${user.uid}");

      // 2. Link phone number credential
      PhoneAuthCredential credential = PhoneAuthProvider.credential(
        verificationId: verificationId,
        smsCode: smsCode,
      );
      await user.linkWithCredential(credential);
      log("Phone number linked to user: ${user.uid}");

      // 3. Save user profile to Firestore
      log("--- Saving user profile to Firestore --- ");
      Map<String, dynamic> userData = {
        'uid': user.uid,
        'email': email,
        'fullName': fullName,
        'mobileNumber': mobileNumber,
        'age': age,
        'gender': gender,
        'createdAt': FieldValue.serverTimestamp(),
      };
      await _firestore.collection('users').doc(user.uid).set(userData);
      log("Firestore profile saved for user: ${user.uid}");

      emit(AuthRegistrationSuccess());

    } on FirebaseAuthException catch (e) {
      log("Firebase Auth Error during registration: ${e.code} - ${e.message}");
      emit(AuthError("Registration failed: ${e.message ?? 'Unknown error'}"));
    } catch (e) {
      log("General Error during registration: ${e.toString()}");
      emit(AuthError("An unexpected error occurred during registration: ${e.toString()}"));
    }
  }

  Future<void> logout() async {
    emit(AuthLoading());
    try {
      await _auth.signOut();
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('user_email');
      await prefs.remove('is_logged_in');
      await prefs.remove('user_uid');
      log("User logged out and session cleared.");
      emit(AuthLoggedOut());
    } catch (e) {
      log("Error during logout: ${e.toString()}");
      emit(AuthError("Logout failed: ${e.toString()}"));
    }
  }

  Future<void> checkAuthStatus() async {
    emit(AuthLoading());
    try {
      final prefs = await SharedPreferences.getInstance();
      final bool isLoggedIn = prefs.getBool('is_logged_in') ?? false;
      final String? uid = prefs.getString('user_uid');

      User? currentUser = _auth.currentUser;

      if (isLoggedIn && uid != null && currentUser != null && currentUser.uid == uid) {
        log("User is logged in: $uid");
        emit(AuthLoggedIn(user: currentUser));
      } else {
        log("User is not logged in.");
        if (currentUser != null) await _auth.signOut();
        if (isLoggedIn || uid != null) {
          await prefs.remove('user_email');
          await prefs.remove('is_logged_in');
          await prefs.remove('user_uid');
        }
        emit(AuthLoggedOut());
      }
    } catch (e) {
      log("Error checking auth status: ${e.toString()}");
      emit(AuthError("Failed to check authentication status: ${e.toString()}"));
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('user_email');
      await prefs.remove('is_logged_in');
      await prefs.remove('user_uid');
      await _auth.signOut();
      emit(AuthLoggedOut());
    }
  }
}