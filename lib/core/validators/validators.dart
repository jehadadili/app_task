class Validators {
  static String? validateMobile(String? value, String regex) {
    if (value == null || value.isEmpty) {
      return 'Mobile number is required'; // Needs localization
    }
    if (!RegExp(regex).hasMatch(value)) {
      return 'Invalid mobile number format'; // Needs localization
    }
    return null;
  }

  static String? validatePassword(String? value, String regex) {
    if (value == null || value.isEmpty) {
      return 'Password is required'; // Needs localization
    }
    if (!RegExp(regex).hasMatch(value)) {
      return 'Password must contain at least 8 characters, one uppercase, one lowercase, and one number'; // Needs localization
    }
    return null;
  }

  static String? validateName(String? value) {
    if (value == null || value.isEmpty) {
      return 'Name is required'; // Needs localization
    }
    if (value.length < 2) {
      return 'Name must be at least 2 characters'; // Needs localization
    }
    return null;
  }

  static String? validateAge(int? value) {
    if (value == null || value < 1) {
      return 'Please select a valid age'; // Needs localization
    }
    if (value < 13) {
      return 'Age must be at least 13 years'; // Needs localization
    }
    return null;
  }

  static String? validateConfirmPassword(String? value, String password) {
    if (value == null || value.isEmpty) {
      return 'Confirm password is required'; // Needs localization
    }
    if (value != password) {
      return 'Passwords do not match'; // Needs localization
    }
    return null;
  }

  static String? validateOTP(String? value, int length) {
    if (value == null || value.isEmpty) {
      return 'OTP is required'; // Needs localization
    }
    if (value.length != length) {
      return 'OTP must be $length digits'; // Needs localization
    }
    if (!RegExp(r'^\d+$').hasMatch(value)) {
      return 'OTP must contain only numbers'; // Needs localization
    }
    return null;
  }
}
