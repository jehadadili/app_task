import 'dart:developer';
import 'package:bloc/bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_task_app/core/config/firebase_config.dart';
import 'package:flutter_task_app/features/auth/register/cubit/register_state.dart';
import 'package:flutter_task_app/features/auth/register/model/registration_data.dart';
import 'package:flutter_task_app/features/auth/register/screen/widgets/registration_validator.dart';
import 'package:flutter_task_app/features/auth/register/services/otp_service.dart';
import 'package:flutter_task_app/features/auth/register/services/phone_formatter.dart';
import 'package:flutter_task_app/features/auth/register/services/user_repository.dart';

class RegisterCubit extends Cubit<RegisterState> {
  final FirebaseConfig firebaseConfig;
  final RegistrationValidator _validator;
  final OtpService _otpService;
  final UserRepository _userRepository;

  RegistrationData? _tempRegistrationData;

  RegisterCubit({
    required this.firebaseConfig,
    RegistrationValidator? validator,
    OtpService? otpService,
    UserRepository? userRepository,
  }) : _validator =
           validator ?? RegistrationValidator(firebaseConfig: firebaseConfig),
       _otpService = otpService ?? OtpService(),
       _userRepository = userRepository ?? UserRepository(),
       super(RegisterInitial());

  Future<void> initiateRegistration({
    required String fullName,
    required String mobile,
    required int? age,
    required String? gender,
    required String password,
    required String confirmPassword,
  }) async {
    emit(RegisterLoading());

    final validationError = _validator.validateRegistrationData(
      fullName: fullName,
      mobile: mobile,
      age: age,
      gender: gender,
      password: password,
      confirmPassword: confirmPassword,
    );

    if (validationError != null) {
      emit(RegisterFailure(validationError));
      return;
    }

    try {
      String formattedMobileForDB = PhoneFormatter.formatForDatabase(mobile);
      String formattedMobileForAuth = PhoneFormatter.formatForAuth(mobile);

      bool userExists = await _userRepository.userExistsWithMobile(
        formattedMobileForDB,
      );
      if (userExists) {
        emit(
          RegisterFailure('This number is already registered. Please log in.'),
        );
        return;
      }

      _tempRegistrationData = RegistrationData(
        fullName: fullName,
        mobile: formattedMobileForDB,
        age: age!,
        gender: gender!,
        password: password,
      );

      log('Formatted phone for DB: $formattedMobileForDB');
      log('Formatted phone for Auth: $formattedMobileForAuth');

      await _sendOtpCode(formattedMobileForAuth);
    } catch (e) {
      log('Registration initiation error: $e');
      emit(
        RegisterFailure(
          'An error occurred while starting registration: ${e.toString()}',
        ),
      );
    }
  }

  Future<void> _sendOtpCode(String phoneNumber) async {
    await _otpService.sendOtp(
      phoneNumber: phoneNumber,
      onCodeSent: (verificationId) {
        emit(
          RegisterOtpRequired(
            _tempRegistrationData!.mobile,
            verificationId: verificationId,
          ),
        );
      },
      onError: (error) {
        emit(RegisterFailure(error));
      },
      onAutoVerified: (credential) async {
        await _handlePhoneCredential(credential);
      },
    );
  }

  Future<void> verifyOtpAndCompleteRegistration(String otpCode) async {
    final otpError = _validator.validateOtpCode(otpCode);
    if (otpError != null) {
      emit(RegisterFailure(otpError));
      return;
    }

    if (_otpService.verificationId == null) {
      emit(
        RegisterFailure("The verification process did not start correctly."),
      );
      return;
    }

    emit(RegisterLoading());

    try {
      PhoneAuthCredential? credential = await _otpService.verifyOtp(otpCode);
      if (credential != null) {
        await _handlePhoneCredential(credential);
      }
    } catch (e) {
      log("OTP verification failed: $e");
      emit(RegisterFailure(e.toString()));
    }
  }

  Future<void> _handlePhoneCredential(PhoneAuthCredential credential) async {
    try {
      UserCredential userCredential = await _otpService.signInWithCredential(
        credential,
      );
      await _completeRegistration(userCredential.user!);
    } catch (e) {
      log("Credential handling failed: $e");
      emit(RegisterFailure(e.toString()));
    }
  }

  Future<void> _completeRegistration(User currentUser) async {
    if (_tempRegistrationData == null) {
      log("Error: Temporary registration data missing.");
      emit(RegisterFailure("Registration data is missing. Please try again."));
      return;
    }

    try {
      await _userRepository.saveUserData(
        user: currentUser,
        fullName: _tempRegistrationData!.fullName,
        mobile: _tempRegistrationData!.mobile,
        age: _tempRegistrationData!.age,
        gender: _tempRegistrationData!.gender,
        password: _tempRegistrationData!.password,
      );

      _clearTempData();
      emit(RegisterSuccess());
    } catch (e) {
      log("Registration completion failed: $e");
      _clearTempData();
      emit(RegisterFailure(e.toString()));
    }
  }

  void _clearTempData() {
    _tempRegistrationData = null;
    _otpService.clearVerificationId();
  }

  void cancelOtpProcess() {
    _clearTempData();
    emit(RegisterInitial());
  }

  Future<void> resendOtp() async {
    if (_tempRegistrationData?.mobile != null) {
      String phoneForAuth = PhoneFormatter.formatForAuth(
        _tempRegistrationData!.mobile,
      );
      await _sendOtpCode(phoneForAuth);
    } else {
      emit(
        RegisterFailure(
          "There is no phone number to resend the verification code to.",
        ),
      );
    }
  }
}
