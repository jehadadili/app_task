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

  // دالة موحدة لتنسيق رقم الهاتف مثل Firebase (مع مسافات)
  String _formatPhoneForFirebase(String mobile) {
    // إزالة أي رموز أو مسافات موجودة
    String cleanMobile = mobile
        .replaceAll('+962', '')
        .replaceAll(' ', '')
        .replaceAll('-', '')
        .trim();

    // التأكد من أن الرقم يبدأ بـ 7
    if (!cleanMobile.startsWith('7') && cleanMobile.length == 8) {
      cleanMobile = '7$cleanMobile';
    }

    // تنسيق الرقم مثل Firebase: +962 7 9011 9723
    if (cleanMobile.length == 9) {
      String part1 = cleanMobile.substring(0, 1); // 7
      String part2 = cleanMobile.substring(1, 5); // 9011
      String part3 = cleanMobile.substring(5); // 9723
      return '+962 $part1 $part2 $part3';
    }

    // إذا لم يكن التنسيق صحيح، إرجاع الرقم مع رمز البلد فقط
    return '+962 $cleanMobile';
  }

  // دالة للتحقق من صحة تنسيق الرقم

  Future<void> loginUserSimple(String mobile, String password) async {
    emit(LoginLoading());
 bool isValidPhoneNumber(String mobile) {
    String cleanMobile = mobile
        .replaceAll('+962', '')
        .replaceAll(' ', '')
        .replaceAll('-', '')
        .trim();

    // يجب أن يكون الرقم 9 أرقام ويبدأ بـ 7
    return cleanMobile.length == 9 && cleanMobile.startsWith('7');
  }

    // تنظيف رقم الهاتف من أي رموز أو مسافات
    String cleanMobile = mobile
        .replaceAll('+962', '')
        .replaceAll(' ', '')
        .replaceAll('-', '')
        .trim();

    // التحقق من صحة الرقم باستخدام Validators
  if (!isValidPhoneNumber(mobile)) {
      emit(LoginFailure('رقم الهاتف يجب أن يكون 9 أرقام ويبدأ بـ 7'));
      return;
    }

    final mobileError = Validators.validateMobile(
      mobile,
    );
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
      // تنسيق رقم الهاتف بنفس طريقة Firebase (مع مسافات)
      String formattedMobile = _formatPhoneForFirebase(cleanMobile);

      log('Searching for user with mobile: $formattedMobile');

      // البحث في قاعدة البيانات باستخدام الرقم المنسق
      var userQuery = await _firestore
          .collection('users')
          .where('mobile', isEqualTo: formattedMobile)
          .limit(1)
          .get();

      if (userQuery.docs.isEmpty) {
        log('User not found with mobile: $formattedMobile');
        emit(LoginUserNotRegistered(cleanMobile)); // إرسال الرقم المنظف
        return;
      }

      // باقي الكود...
      final userData = userQuery.docs.first.data();
      final userUid = userData['uid'] as String;

      log('User found: $userUid');

      // حفظ بيانات تسجيل الدخول في SharedPreferences
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

  // الطريقة المحدثة لتسجيل الدخول (يمكن استخدامها حسب الحاجة)
  Future<void> loginUser(String mobile, String password) async {
    // استخدام الطريقة المبسطة
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
      // يمكن معالجة خطأ تسجيل الخروج هنا إذا لزم الأمر
    }
  }

  // دالة للتحقق من حالة تسجيل الدخول
  Future<bool> checkLoginStatus() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getBool('is_logged_in') ?? false;
    } catch (e) {
      log('Error checking login status: $e');
      return false;
    }
  }

  // دالة للحصول على بيانات المستخدم المحفوظة
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
