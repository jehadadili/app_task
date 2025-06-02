import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_task_app/core/config/firebase_config.dart';
import 'package:flutter_task_app/features/splash/cubit/splash_state.dart';
import 'package:shared_preferences/shared_preferences.dart'; // Import SharedPreferences

class SplashCubit extends Cubit<SplashState> {
  SplashCubit() : super(SplashInitial());

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> loadConfigAndCheckAuth() async {
    try {
      emit(SplashLoading());
      log("SplashCubit: Loading config and checking auth...");

      // 1. Load Firebase Config (with fallback)
      FirebaseConfig config;
      try {
        DocumentSnapshot configDoc =
            await _firestore.collection('config').doc('system').get();
        if (configDoc.exists) {
          config = FirebaseConfig.fromFirestore(configDoc);
          log("SplashCubit: Firebase config loaded successfully.");
        } else {
          log("SplashCubit: Warning - Firebase config document not found, using default.");
          config = FirebaseConfig.defaultConfig();
        }
      } catch (e) {
        log("SplashCubit: Error loading Firebase config: $e. Using default config.");
        config = FirebaseConfig.defaultConfig();
      }

      // 2. Check Login Status from SharedPreferences
      bool isLoggedIn = false;
      try {
        final prefs = await SharedPreferences.getInstance();
        isLoggedIn = prefs.getBool('is_logged_in') ?? false;
        log("SplashCubit: Checked login status from SharedPreferences: $isLoggedIn");
      } catch (e) {
        log("SplashCubit: Error reading SharedPreferences: $e. Assuming not logged in.");
        isLoggedIn = false; // Default to not logged in on error
      }

      // 3. Add delay for splash screen visibility
      await Future.delayed(const Duration(seconds: 2));

      // 4. Emit the appropriate navigation state
      if (isLoggedIn) {
        log("SplashCubit: User is logged in. Navigating to Home.");
        emit(NavigateToHome(config));
      } else {
        log("SplashCubit: User is not logged in. Navigating to Login.");
        emit(NavigateToLogin(config));
      }

    } catch (e) {
      // General error during the process
      log("SplashCubit: Unexpected error during splash process: $e");
      // Fallback to NavigateToLogin with default config after delay
      FirebaseConfig config = FirebaseConfig.defaultConfig();
      await Future.delayed(const Duration(seconds: 2));
      emit(NavigateToLogin(config)); // Navigate to login on any major error
      // Optionally emit a specific error state if needed:
      // emit(SplashError("Failed to initialize app: $e", config));
    }
  }
}

