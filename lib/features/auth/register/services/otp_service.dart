import 'dart:developer';
import 'package:firebase_auth/firebase_auth.dart';

class OtpService {
  final FirebaseAuth _auth;
  String? _verificationId;

  OtpService({FirebaseAuth? auth}) : _auth = auth ?? FirebaseAuth.instance;

  String? get verificationId => _verificationId;

  Future<void> sendOtp({
    required String phoneNumber,
    required Function(String verificationId) onCodeSent,
    required Function(String error) onError,
    Function(PhoneAuthCredential credential)? onAutoVerified,
  }) async {
    try {
      log('Sending OTP to: $phoneNumber');
      
      await _auth.verifyPhoneNumber(
        phoneNumber: phoneNumber,
        verificationCompleted: (PhoneAuthCredential credential) async {
          log("Phone verification completed automatically");
          if (onAutoVerified != null) {
            onAutoVerified(credential);
          }
        },
        verificationFailed: (FirebaseAuthException e) {
          log("Phone verification failed: ${e.code} - ${e.message}");
          String errorMessage = _getPhoneVerificationError(e);
          onError(errorMessage);
        },
        codeSent: (String verificationId, int? resendToken) {
          log("OTP code sent successfully. VerificationId: $verificationId");
          _verificationId = verificationId;
          onCodeSent(verificationId);
        },
        codeAutoRetrievalTimeout: (String verificationId) {
          log("Code auto retrieval timeout: $verificationId");
          _verificationId = verificationId;
        },
        timeout: const Duration(seconds: 60),
      );
    } catch (e) {
      log("Error sending OTP: $e");
      onError('Failed to send verification code: ${e.toString()}');
    }
  }

  Future<PhoneAuthCredential?> verifyOtp(String otpCode) async {
    if (_verificationId == null) {
      throw Exception("The verification process did not start correctly.");
    }

    try {
      PhoneAuthCredential credential = PhoneAuthProvider.credential(
        verificationId: _verificationId!,
        smsCode: otpCode,
      );
      return credential;
    } catch (e) {
      log("OTP verification failed: $e");
      throw Exception("The verification code is incorrect. Please try again.");
    }
  }

  Future<UserCredential> signInWithCredential(PhoneAuthCredential credential) async {
    try {
      UserCredential userCredential = await _auth.signInWithCredential(credential);
      
      if (userCredential.user != null) {
        log("User signed in successfully via OTP: ${userCredential.user!.uid}");
        return userCredential;
      } else {
        throw Exception("Phone number verification failed");
      }
    } on FirebaseAuthException catch (e) {
      log("Firebase Auth Exception during OTP sign in: ${e.code} - ${e.message}");
      String errorMessage = _getAuthError(e);
      throw Exception(errorMessage);
    } catch (e) {
      log("General Exception during OTP sign in: $e");
      throw Exception("An error occurred during verification: ${e.toString()}");
    }
  }

  void clearVerificationId() {
    _verificationId = null;
  }

  String _getPhoneVerificationError(FirebaseAuthException e) {
    switch (e.code) {
      case 'invalid-phone-number':
        return 'Invalid phone number';
      case 'too-many-requests':
        return 'A large number of requests have been sent. Please try again later.';
      case 'quota-exceeded':
        return 'Limit exceeded. Please try again later.';
      default:
        return e.message ?? 'Phone number verification failed';
    }
  }

  String _getAuthError(FirebaseAuthException e) {
    switch (e.code) {
      case 'invalid-verification-code':
        return 'Invalid verification code';
      case 'session-expired':
        return 'Session has expired. Please try again.';
      default:
        return e.message ?? 'Verification failed';
    }
  }
}