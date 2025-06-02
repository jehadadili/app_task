import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_task_app/core/config/firebase_config.dart';
import 'package:flutter_task_app/core/validators/validators.dart';
import 'package:flutter_task_app/features/auth/login/cubit/login_state.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:developer';


class LoginCubit extends Cubit<LoginState> {
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

    if (cleanMobile.length == 9 && cleanMobile.startsWith('7')) {
       return '+962 ${cleanMobile.substring(0, 1)} ${cleanMobile.substring(1, 5)} ${cleanMobile.substring(5)}';
    }

    log("Warning: Phone number format might be unexpected: $mobile");
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

    if (!isValidPhoneNumber(mobile)) {
      emit(LoginFailure('رقم الهاتف يجب أن يكون 9 أرقام ويبدأ بـ 7 بعد رمز الدولة'));
      return;
    }

    final passwordError = Validators.validatePassword(
      password,
      customRegex: firebaseConfig.passwordRegex,
    );
    if (passwordError != null) {
      emit(LoginFailure('كلمة المرور غير صالحة. $passwordError'));
      return;
    }

    try {
      String cleanMobile = mobile
          .replaceAll('+962', '')
          .replaceAll(' ', '')
          .replaceAll('-', '')
          .trim();
      String formattedMobile = _formatPhoneForFirebase(cleanMobile);

      log('Attempting login for mobile: $formattedMobile');

      var userQuery = await _firestore
          .collection('users')
          .where('mobile', isEqualTo: formattedMobile)
          .limit(1)
          .get();

      if (userQuery.docs.isEmpty) {
        log('User not found with mobile: $formattedMobile');
        emit(LoginFailure('The phone number or password is incorrect.')); 
        return;
      }

      final userData = userQuery.docs.first.data();
      final userUid = userData['uid'] as String? ?? 'UID not found'; 
      final storedPassword = userData['password'] as String?; 

      log('User found: $userUid. Checking password.');
      log('Stored password from Firestore: [$storedPassword]');
      log('Password entered by user: [$password]');

      if (storedPassword == null) {
        log('Password field missing or null in Firestore for user: $userUid');
        emit(LoginFailure('Account data error. Password not found.'));
        return;
      }

      if (password != storedPassword) {
        log('Password mismatch for user: $userUid. Entered: [$password], Stored: [$storedPassword]');
        emit(LoginFailure('The phone number or password is incorrect.'));
        return;
      }

      log('Password match! Login successful for user: $userUid');

      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('user_uid', userUid);
      await prefs.setString('user_phone', formattedMobile);
      await prefs.setString('user_name', userData['fullName'] ?? '');
      await prefs.setString('user_age', userData['age']?.toString() ?? '');
      await prefs.setString('user_gender', userData['gender'] ?? '');
      await prefs.setBool('is_logged_in', true); 

      emit(LoginSuccess());

    } catch (e, stackTrace) {
      log('Login error: $e');
      log('Stack trace: $stackTrace');
      emit(LoginFailure('An unexpected error occurred while logging in: ${e.toString()}'));
    }
  }

  Future<void> loginUser(String mobile, String password) async {
    await loginUserSimple(mobile, password);
  }

  Future<void> logoutUser() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('user_uid');
      await prefs.remove('user_phone');
      await prefs.remove('user_name');
      await prefs.remove('user_age');
      await prefs.remove('user_gender');
      await prefs.setBool('is_logged_in', false); 

      log('User logged out successfully');
    } catch (e) {
      log('Logout error: $e');
    }
  }

  Future<bool> checkLoginStatus() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final isLoggedIn = prefs.getBool('is_logged_in') ?? false;
      log('Checked login status: $isLoggedIn');
      return isLoggedIn;
    } catch (e) {
      log('Error checking login status: $e');
      return false;
    }
  }

  Future<Map<String, String?>> getUserData() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      if (!(prefs.getBool('is_logged_in') ?? false)) {
        log('Attempted to get user data, but user is not logged in.');
        return {}; 
      }
      final userData = {
        'uid': prefs.getString('user_uid'),
        'phone': prefs.getString('user_phone'),
        'name': prefs.getString('user_name'),
        'age': prefs.getString('user_age'),
        'gender': prefs.getString('user_gender'),
      };
      log('Retrieved user data from prefs: $userData');
      return userData;
    } catch (e) {
      log('Error getting user data from prefs: $e');
      return {};
    }
  }
}

