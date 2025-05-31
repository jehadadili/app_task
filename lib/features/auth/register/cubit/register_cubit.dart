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

  RegisterCubit({required this.firebaseConfig}) : super(RegisterInitial());

  Future<void> initiateRegistration({
    required String fullName,
    required String mobile,
    required int? age,
    required String? gender,
    required String password,
    required String confirmPassword,
  }) async {
    emit(RegisterLoading());

    final nameError = Validators.validateName(fullName);
    if (nameError != null) {
      emit(RegisterFailure(nameError));
      return;
    }
    final mobileError = Validators.validateMobile(
      mobile,
      firebaseConfig.mobileRegex,
    );
    if (mobileError != null) {
      emit(RegisterFailure(mobileError));
      return;
    }
    final ageError = Validators.validateAge(age);
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
      firebaseConfig.passwordRegex,
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

    String formattedMobile = firebaseConfig.countryCode + mobile;

    _tempFullName = fullName;
    _tempMobile = formattedMobile;
    _tempAge = age;
    _tempGender = gender;
    _tempPassword = password;

    log("Simulating OTP requirement for: $formattedMobile");
    await Future.delayed(const Duration(seconds: 1));
    emit(RegisterOtpRequired(formattedMobile));
  }

  Future<void> completeRegistrationAfterOtp() async {
    if (_tempMobile == null ||
        _tempPassword == null ||
        _tempFullName == null ||
        _tempAge == null ||
        _tempGender == null) {
      emit(RegisterFailure("Registration details missing. Please try again."));
      return;
    }

    emit(RegisterLoading());

    try {
      String emailForAuth = "$_tempMobile@placeholder.com";
      UserCredential userCredential = await _auth
          .createUserWithEmailAndPassword(
            email: emailForAuth,
            password: _tempPassword!,
          );

      User? firebaseUser = userCredential.user;
      if (firebaseUser == null) {
        throw Exception("Firebase user creation failed.");
      }

      await _firestore.collection('users').doc(firebaseUser.uid).set({
        'uid': firebaseUser.uid,
        'fullName': _tempFullName,
        'mobile': _tempMobile,
        'age': _tempAge,
        'gender': _tempGender,
        'email': emailForAuth,
        'createdAt': FieldValue.serverTimestamp(),
      });

      _clearTempData();
      emit(RegisterSuccess());
    } on FirebaseAuthException catch (e) {
      _clearTempData();
      emit(RegisterFailure('Registration failed: ${e.message}'));
    } catch (e) {
      _clearTempData();
      emit(RegisterFailure('An unexpected error occurred: ${e.toString()}'));
    }
  }

  void _clearTempData() {
    _tempFullName = null;
    _tempMobile = null;
    _tempAge = null;
    _tempGender = null;
    _tempPassword = null;
  }

  void cancelOtpProcess() {
    _clearTempData();
    emit(RegisterInitial());
  }
}
