import 'package:bloc/bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_task_app/core/config/firebase_config.dart';
import 'package:flutter_task_app/core/validators/validators.dart';
import 'package:flutter_task_app/features/auth/login/cubit/login_state.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginCubit extends Cubit<LoginState> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseConfig firebaseConfig;

  LoginCubit({required this.firebaseConfig}) : super(LoginInitial());

  Future<void> loginUser(String mobile, String password) async {
    emit(LoginLoading());

    final mobileError = Validators.validateMobile(
      mobile,
      firebaseConfig.mobileRegex,
    );
    if (mobileError != null) {
      emit(LoginFailure(mobileError));
      return;
    }
    final passwordError = Validators.validatePassword(
      password,
      firebaseConfig.passwordRegex,
    );
    if (passwordError != null) {
      emit(LoginFailure(passwordError));
      return;
    }

    try {
      String formattedMobile = mobile;

      var userQuery = await _firestore
          .collection('users')
          .where('mobile', isEqualTo: formattedMobile)
          .limit(1)
          .get();

      if (userQuery.docs.isEmpty) {
        emit(LoginUserNotRegistered(mobile));
        return;
      }

      String emailForAuth = "$formattedMobile@placeholder.com";

      try {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('user_email', emailForAuth);
        await prefs.setBool('is_logged_in', true);

        emit(LoginSuccess());
      } on FirebaseAuthException catch (e) {
        if (e.code == 'user-not-found') {
          emit(LoginUserNotRegistered(mobile));
        } else if (e.code == 'wrong-password') {
          emit(
            LoginFailure(
              firebaseConfig.errorMessages['wrongPassword'] ??
                  'Incorrect password.',
            ),
          );
        } else {
          emit(LoginFailure('Login failed: ${e.message}'));
        }
      }
    } catch (e) {
      emit(LoginFailure('An unexpected error occurred: ${e.toString()}'));
    }
  }

  Future<void> logoutUser() async {
    await _auth.signOut();
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('user_email');
    await prefs.remove('is_logged_in');
  }
}
