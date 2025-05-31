import 'package:bloc/bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_task_app/features/profile/cubit/profile_state.dart';
import 'package:flutter_task_app/features/profile/model/user_model.dart';
import 'package:shared_preferences/shared_preferences.dart';


class ProfileCubit extends Cubit<ProfileState> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  ProfileCubit() : super(ProfileInitial()) {
    fetchUserProfile(); 
  }

  Future<void> fetchUserProfile() async {
    emit(ProfileLoading());
    try {
      User? currentUser = _auth.currentUser;
      if (currentUser == null) {
        emit(ProfileError("User not logged in.")); 
      
        return;
      }

      DocumentSnapshot userDoc = await _firestore.collection('users').doc(currentUser.uid).get();

      if (userDoc.exists) {
        UserProfile userProfile = UserProfile.fromFirestore(userDoc);
        emit(ProfileLoaded(userProfile));
      } else {
        emit(ProfileError("User data not found in Firestore.")); 
      }
    } catch (e) {
      emit(ProfileError("Failed to load profile: ${e.toString()}")); 
    }
  }

  Future<void> logoutUser() async {
    try {
      await _auth.signOut();
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('user_email'); 
      await prefs.remove('is_logged_in');
      emit(ProfileLogoutSuccess()); 
    } catch (e) {
      emit(ProfileError("Logout failed: ${e.toString()}")); 
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('user_email');
      await prefs.remove('is_logged_in');
      emit(ProfileLogoutSuccess());
    }
  }
}
