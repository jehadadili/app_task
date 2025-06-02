import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_task_app/core/config/firebase_config.dart';
import 'package:flutter_task_app/core/validators/validators.dart';
import 'package:flutter_task_app/features/auth/register/cubit/register_state.dart';

class RegisterCubit extends Cubit<RegisterState> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseConfig firebaseConfig;
  String? _tempFullName;
  String? _tempMobile;
  int? _tempAge;
  String? _tempGender;
  String? _tempPassword;
  String? _verificationId;

  RegisterCubit({required this.firebaseConfig}) : super(RegisterInitial());

  // دالة موحدة لتنسيق رقم الهاتف للحفظ في قاعدة البيانات
  String _formatPhoneForDatabase(String mobile) {
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

  // دالة لتنسيق رقم الهاتف للـ Phone Auth (بدون مسافات)
  String _formatPhoneForAuth(String mobile) {
    String cleanMobile = mobile
        .replaceAll('+962', '')
        .replaceAll(' ', '')
        .replaceAll('-', '')
        .trim();

    // التأكد من أن الرقم يبدأ بـ 7
    if (!cleanMobile.startsWith('7') && cleanMobile.length == 8) {
      cleanMobile = '7$cleanMobile';
    }

    return '+962$cleanMobile';
  }

  // دالة للتحقق من صحة تنسيق الرقم
  bool _isValidPhoneNumber(String mobile) {
    String cleanMobile = mobile
        .replaceAll('+962', '')
        .replaceAll(' ', '')
        .replaceAll('-', '')
        .trim();

    // يجب أن يكون الرقم 9 أرقام ويبدأ بـ 7
    return cleanMobile.length == 9 && cleanMobile.startsWith('7');
  }

  Future<void> initiateRegistration({
    required String fullName,
    required String mobile,
    required int? age,
    required String? gender,
    required String password,
    required String confirmPassword,
  }) async {
    emit(RegisterLoading());

    // التحقق من صحة البيانات
    final nameError = Validators.validateName(fullName);
    if (nameError != null) {
      emit(RegisterFailure(nameError));
      return;
    }

    // التحقق من صحة رقم الهاتف
    if (!_isValidPhoneNumber(mobile)) {
      emit(RegisterFailure('رقم الهاتف يجب أن يكون 9 أرقام ويبدأ بـ 7'));
      return;
    }

    final mobileError = Validators.validateMobile(
      mobile,
    );
    if (mobileError != null) {
      emit(RegisterFailure(mobileError));
      return;
    }

    final ageError = Validators.validateAge(age?.toString());
    if (ageError != null) {
      emit(RegisterFailure(ageError));
      return;
    }

    if (gender == null || gender.isEmpty) {
      emit(RegisterFailure('Gender is required'));
      return;
    }

    final passwordError = Validators.validatePassword(
      password,
      customRegex: firebaseConfig.passwordRegex,
    );
    if (passwordError != null) {
      emit(RegisterFailure(passwordError));
      return;
    }

    final confirmPasswordError = Validators.validateConfirmPassword(
      confirmPassword,
      password,
    );
    if (confirmPasswordError != null) {
      emit(RegisterFailure(confirmPasswordError));
      return;
    }

    try {
      // تنسيق الرقم للحفظ في قاعدة البيانات
      String formattedMobileForDB = _formatPhoneForDatabase(mobile);
      // تنسيق الرقم للـ Phone Auth
      String formattedMobileForAuth = _formatPhoneForAuth(mobile);

      // التحقق من وجود المستخدم مسبقاً
      var existingUserQuery = await _firestore
          .collection('users')
          .where('mobile', isEqualTo: formattedMobileForDB)
          .limit(1)
          .get();

      if (existingUserQuery.docs.isNotEmpty) {
        emit(RegisterFailure('هذا الرقم مسجل مسبقاً. يرجى تسجيل الدخول.'));
        return;
      }

      // حفظ البيانات المؤقتة
      _tempFullName = fullName;
      _tempMobile = formattedMobileForDB;
      _tempAge = age;
      _tempGender = gender;
      _tempPassword = password;

      log('Formatted phone for DB: $formattedMobileForDB');
      log('Formatted phone for Auth: $formattedMobileForAuth');

      // إرسال OTP
      await _sendOtpCode(formattedMobileForAuth);
    } catch (e) {
      log('Registration initiation error: $e');
      emit(RegisterFailure('حدث خطأ أثناء بدء التسجيل: ${e.toString()}'));
    }
  }

  Future<void> _sendOtpCode(String phoneNumber) async {
    try {
      log('Sending OTP to: $phoneNumber');

      await _auth.verifyPhoneNumber(
        phoneNumber: phoneNumber,
        verificationCompleted: (PhoneAuthCredential credential) async {
          log("Phone verification completed automatically");
          await _signInWithCredential(credential);
        },
        verificationFailed: (FirebaseAuthException e) {
          log("Phone verification failed: ${e.code} - ${e.message}");

          String errorMessage = 'فشل في التحقق من رقم الهاتف';

          switch (e.code) {
            case 'invalid-phone-number':
              errorMessage = 'رقم الهاتف غير صحيح';
              break;
            case 'too-many-requests':
              errorMessage =
                  'تم إرسال عدد كبير من الطلبات. يرجى المحاولة لاحقاً';
              break;
            case 'quota-exceeded':
              errorMessage = 'تم تجاوز الحد المسموح. يرجى المحاولة لاحقاً';
              break;
            default:
              errorMessage = e.message ?? errorMessage;
          }

          emit(RegisterFailure(errorMessage));
        },
        codeSent: (String verificationId, int? resendToken) {
          log("OTP code sent successfully. VerificationId: $verificationId");
          _verificationId = verificationId;
          emit(
            RegisterOtpRequired(_tempMobile!, verificationId: verificationId),
          );
        },
        codeAutoRetrievalTimeout: (String verificationId) {
          log("Code auto retrieval timeout: $verificationId");
          _verificationId = verificationId;
        },
        timeout: const Duration(seconds: 60),
      );
    } catch (e) {
      log("Error sending OTP: $e");
      emit(RegisterFailure('فشل في إرسال رمز التحقق: ${e.toString()}'));
    }
  }

  Future<void> verifyOtpAndCompleteRegistration(String otpCode) async {
    if (_verificationId == null) {
      emit(RegisterFailure("عملية التحقق لم تبدأ بشكل صحيح"));
      return;
    }

    if (otpCode.length != 6) {
      emit(RegisterFailure("رمز التحقق يجب أن يكون 6 أرقام"));
      return;
    }

    emit(RegisterLoading());

    try {
      PhoneAuthCredential credential = PhoneAuthProvider.credential(
        verificationId: _verificationId!,
        smsCode: otpCode,
      );

      await _signInWithCredential(credential);
    } catch (e) {
      log("OTP verification failed: $e");
      emit(RegisterFailure("رمز التحقق غير صحيح. يرجى المحاولة مرة أخرى"));
    }
  }

  Future<void> _signInWithCredential(PhoneAuthCredential credential) async {
    try {
      UserCredential userCredential = await _auth.signInWithCredential(
        credential,
      );

      if (userCredential.user != null) {
        log("User signed in successfully: ${userCredential.user!.uid}");
        await _completeRegistration();
      } else {
        emit(RegisterFailure("فشل في التحقق من رقم الهاتف"));
      }
    } on FirebaseAuthException catch (e) {
      log("Firebase Auth Exception: ${e.code} - ${e.message}");

      String errorMessage = 'فشل في التحقق';

      switch (e.code) {
        case 'invalid-verification-code':
          errorMessage = 'رمز التحقق غير صحيح';
          break;
        case 'session-expired':
          errorMessage = 'انتهت صلاحية الجلسة. يرجى إعادة المحاولة';
          break;
        default:
          errorMessage = e.message ?? errorMessage;
      }

      emit(RegisterFailure(errorMessage));
    } catch (e) {
      log("General Exception: $e");
      emit(RegisterFailure("حدث خطأ: ${e.toString()}"));
    }
  }

  Future<void> _completeRegistration() async {
    if (_tempMobile == null ||
        _tempPassword == null ||
        _tempFullName == null ||
        _tempAge == null ||
        _tempGender == null) {
      emit(RegisterFailure("بيانات التسجيل مفقودة. يرجى المحاولة مرة أخرى"));
      return;
    }

    try {
      User? currentUser = _auth.currentUser;
      if (currentUser == null) {
        throw Exception("لا يوجد مستخدم متحقق منه");
      }

      log("Saving user data to Firestore...");
      log("Mobile format for DB: $_tempMobile");

      // حفظ بيانات المستخدم في Firestore
      await _firestore.collection('users').doc(currentUser.uid).set({
        'uid': currentUser.uid,
        'fullName': _tempFullName,
        'mobile': _tempMobile, // الرقم بتنسيق Firebase مع المسافات
        'age': _tempAge,
        'gender': _tempGender,
        'phoneNumber':
            currentUser.phoneNumber, // الرقم المتحقق منه من Firebase Auth
        'createdAt': FieldValue.serverTimestamp(),
      });

      log("User data saved successfully");
      _clearTempData();
      emit(RegisterSuccess());
    } catch (e) {
      log("Registration completion failed: $e");
      _clearTempData();
      emit(RegisterFailure('فشل في إتمام التسجيل: ${e.toString()}'));
    }
  }

  void _clearTempData() {
    _tempFullName = null;
    _tempMobile = null;
    _tempAge = null;
    _tempGender = null;
    _tempPassword = null;
    _verificationId = null;
  }

  void cancelOtpProcess() {
    _clearTempData();
    emit(RegisterInitial());
  }

  Future<void> resendOtp() async {
    if (_tempMobile != null) {
      // تحويل الرقم من تنسيق قاعدة البيانات إلى تنسيق Phone Auth
      String phoneForAuth = _tempMobile!.replaceAll(' ', '');
      await _sendOtpCode(phoneForAuth);
    } else {
      emit(RegisterFailure("لا يوجد رقم هاتف لإعادة إرسال رمز التحقق إليه"));
    }
  }
}
