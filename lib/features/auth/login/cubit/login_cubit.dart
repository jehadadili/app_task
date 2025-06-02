import 'package:bloc/bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_task_app/core/config/firebase_config.dart';
import 'package:flutter_task_app/core/validators/validators.dart';
import 'package:flutter_task_app/features/auth/login/cubit/login_state.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:developer';

class LoginCubit extends Cubit<LoginState> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseConfig firebaseConfig;

  LoginCubit({required this.firebaseConfig}) : super(LoginInitial());

  String _formatPhoneForFirebase(String mobile) {
    String cleanMobile = mobile
        .replaceAll('+962', '')
        .replaceAll(' ', '')
        .replaceAll('-', '')
        .trim();

    if (!cleanMobile.startsWith('7') && cleanMobile.length == 8) {
      cleanMobile = '7$cleanMobile';
    }

    if (cleanMobile.length == 9) {
      String part1 = cleanMobile.substring(0, 1); 
      String part2 = cleanMobile.substring(1, 5); 
      String part3 = cleanMobile.substring(5); 
      return '+962 $part1 $part2 $part3';
    }

    return '+962 $cleanMobile';
  }


  Future<void> loginUserSimple(String mobile, String password) async {
    emit(LoginLoading());
    bool isValidPhoneNumber(String mobile) {
      String cleanMobile = mobile
          .replaceAll('+962', '')
          .replaceAll(' ', '')
          .replaceAll('-', '')
          .trim();

      return cleanMobile.length == 9 && cleanMobile.startsWith('7');
    }

    String cleanMobile = mobile
        .replaceAll('+962', '')
        .replaceAll(' ', '')
        .replaceAll('-', '')
        .trim();

    if (!isValidPhoneNumber(mobile)) {
      emit(LoginFailure('رقم الهاتف يجب أن يكون 9 أرقام ويبدأ بـ 7'));
      return;
    }

    final mobileError = Validators.validateMobile(mobile);
    if (mobileError != null) {
      emit(LoginFailure(mobileError));
      return;
    }

    final passwordError = Validators.validatePassword(
      password,
      customRegex: firebaseConfig.passwordRegex,
    );
    if (passwordError != null) {
      emit(LoginFailure(passwordError));
      return;
    }

    try {
      String formattedMobile = _formatPhoneForFirebase(cleanMobile);

      log('Searching for user with mobile: $formattedMobile');

      var userQuery = await _firestore
          .collection('users')
          .where('mobile', isEqualTo: formattedMobile)
          .limit(1)
          .get();

      if (userQuery.docs.isEmpty) {
        log('User not found with mobile: $formattedMobile');
        emit(LoginUserNotRegistered(cleanMobile)); 
        return;
      }

      final userData = userQuery.docs.first.data();
      final userUid = userData['uid'] as String;

      log('User found: $userUid');

      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('user_uid', userUid);
      await prefs.setString('user_phone', formattedMobile);
      await prefs.setString('user_name', userData['fullName'] ?? '');
      await prefs.setString('user_age', userData['age']?.toString() ?? '');
      await prefs.setString('user_gender', userData['gender'] ?? '');
      await prefs.setBool('is_logged_in', true);

      log('Login successful for user: $userUid');
      emit(LoginSuccess());
    } catch (e) {
      log('Login error: $e');
      emit(LoginFailure('حدث خطأ غير متوقع: ${e.toString()}'));
    }
  }

  Future<void> loginUser(String mobile, String password) async {
    await loginUserSimple(mobile, password);
  }

  Future<void> logoutUser() async {
    try {
      await _auth.signOut();
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('user_uid');
      await prefs.remove('user_phone');
      await prefs.remove('user_name');
      await prefs.remove('user_age');
      await prefs.remove('user_gender');
      await prefs.remove('user_email');
      await prefs.remove('is_logged_in');

      log('User logged out successfully');
    } catch (e) {
      log('Logout error: $e');
    }
  }

  Future<bool> checkLoginStatus() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getBool('is_logged_in') ?? false;
    } catch (e) {
      log('Error checking login status: $e');
      return false;
    }
  }

  Future<Map<String, String?>> getUserData() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return {
        'uid': prefs.getString('user_uid'),
        'phone': prefs.getString('user_phone'),
        'name': prefs.getString('user_name'),
        'age': prefs.getString('user_age'),
        'gender': prefs.getString('user_gender'),
      };
    } catch (e) {
      log('Error getting user data: $e');
      return {};
    }
  }
}
