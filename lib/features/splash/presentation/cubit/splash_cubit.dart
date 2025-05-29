import 'package:bloc/bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_task_app/features/splash/presentation/cubit/splash_state.dart';


class SplashCubit extends Cubit<SplashState> {
  SplashCubit() : super(SplashInitial());

  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> loadAppConfig() async {
    try {
      emit(SplashLoading());

      await Future.delayed(const Duration(seconds: 2));

      
      final user = _auth.currentUser;
      final bool isAuthenticated = user != null;


      emit(SplashLoaded(isAuthenticated: isAuthenticated));

    } catch (e) {
      emit(SplashError('Failed to load app configuration: ${e.toString()}'));
    }
  }
}

