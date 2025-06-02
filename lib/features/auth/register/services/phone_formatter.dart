import 'dart:developer';

class PhoneFormatter {
  static const String _countryCode = '+962';
  static const String _validPrefix = '7';
  static const int _expectedLength = 9;

  static String formatForDatabase(String mobile) {
    String cleanMobile = _cleanPhoneNumber(mobile);

    if (!cleanMobile.startsWith(_validPrefix) && cleanMobile.length == 8) {
      cleanMobile = '$_validPrefix$cleanMobile';
    }

    if (cleanMobile.length == _expectedLength && cleanMobile.startsWith(_validPrefix)) {
      return '$_countryCode ${cleanMobile.substring(0, 1)} ${cleanMobile.substring(1, 5)} ${cleanMobile.substring(5)}';
    }

    log("Warning: Phone number format might be unexpected for DB: $mobile");
    return '$_countryCode $cleanMobile';
  }

  static String formatForAuth(String mobile) {
    String cleanMobile = _cleanPhoneNumber(mobile);

    if (!cleanMobile.startsWith(_validPrefix) && cleanMobile.length == 8) {
      cleanMobile = '$_validPrefix$cleanMobile';
    }
    
    return '$_countryCode$cleanMobile';
  }

  static bool isValid(String mobile) {
    String cleanMobile = _cleanPhoneNumber(mobile);
    return cleanMobile.length == _expectedLength && cleanMobile.startsWith(_validPrefix);
  }

  static String _cleanPhoneNumber(String mobile) {
    return mobile
        .replaceAll(_countryCode, '')
        .replaceAll(' ', '')
        .replaceAll('-', '')
        .trim();
  }
}