import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_task_app/features/home/profile/presentation/cubit/profile_state.dart';


class ProfileCubit extends Cubit<ProfileState> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  ProfileCubit() : super(ProfileInitial());

  Future<void> loadUserProfile() async {
    emit(ProfileLoading());
    try {
      final user = _auth.currentUser;
      if (user == null) {
        emit(ProfileError("User not logged in."));
        return;
      }

      log("--- Placeholder: Fetching user profile from Firestore ---");
      log("User ID: ${user.uid}");

      final docSnapshot = await _firestore.collection('users').doc(user.uid).get();

      if (docSnapshot.exists) {
        final userData = docSnapshot.data() as Map<String, dynamic>;
        log("User profile loaded: $userData");
        emit(ProfileLoaded(userProfileData: userData));
      } else {
        log("Error: User profile data not found in Firestore for UID: ${user.uid}");
        emit(ProfileError("User profile not found."));
      }

    } catch (e) {
      log("Error loading profile: ${e.toString()}");
      emit(ProfileError("Failed to load profile: ${e.toString()}"));
    }
  }

  Future<void> logout() async {
  
    try {
      await _auth.signOut();
      emit(ProfileLoggedOut());
    } catch (e) {
      log("Error during logout: ${e.toString()}");
      emit(ProfileError("Logout failed: ${e.toString()}"));
    }
  }
}

