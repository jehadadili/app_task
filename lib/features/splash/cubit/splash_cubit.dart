import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_task_app/core/config/firebase_config.dart';
import 'package:flutter_task_app/features/splash/cubit/splash_state.dart';


class SplashCubit extends Cubit<SplashState> {
  SplashCubit() : super(SplashInitial());

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> loadConfigAndNavigate() async {
    try {
      emit(SplashLoading());
      DocumentSnapshot configDoc = await _firestore.collection('config').doc('system').get();

      FirebaseConfig config;
      if (configDoc.exists) {
        config = FirebaseConfig.fromFirestore(configDoc);
      } else {
        log("Warning: Firebase config document not found, using default config.");
        config = FirebaseConfig.defaultConfig();
      }

      await Future.delayed(const Duration(seconds: 2));

      emit(SplashLoaded(config));


    } catch (e) {
      log("Error loading Firebase config: $e. Using default config.");
    
      FirebaseConfig config = FirebaseConfig.defaultConfig();
      await Future.delayed(const Duration(seconds: 2)); 
      emit(SplashLoaded(config)); 
    }
  }
}
