class Validators {
  static String? validateMobile(String? value) {
    // Expecting the full E.164 format like +962790119723
    const String pattern =
        r'^\+9627[789]\d{7}$'; // Adjust regex based on valid Jordanian mobile prefixes (77, 78, 79)
    final RegExp regex = RegExp(pattern);

    if (value == null || value.trim().isEmpty) {
      return 'Mobile number is required';
    }

    final String trimmedValue = value.trim();

    if (!trimmedValue.startsWith('+962')) {
      return 'Mobile number must start with +962';
    }

    // Length check for +962 followed by 9 digits
    if (trimmedValue.length != 13) {
      return 'Mobile number must be in the format +962XXXXXXXXX (13 digits total)';
    }

    if (!regex.hasMatch(trimmedValue)) {
      return 'Invalid Jordanian mobile number format (e.g., +9627XXXXXXXX)';
    }

    return null;
  }

  static String? validatePassword(String? value, {String? customRegex}) {
    if (value == null || value.isEmpty) {
      return 'Password is required';
    }
    if (value.length < 6) {
      return 'Password must be at least 6 characters';
    }

    // إذا تم تمرير regex مخصص
    if (customRegex != null && !RegExp(customRegex).hasMatch(value)) {
      return 'Password must contain at least 8 characters, one uppercase, one lowercase, and one number';
    }
    return null;
  }

  static String? validateName(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Full name is required';
    }
    if (value.trim().length < 2) {
      return 'Full name must be at least 2 characters';
    }
    return null;
  }

  static String? validateAge(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Age is required';
    }
    final age = int.tryParse(value);
    if (age == null) {
      return 'Please enter a valid age';
    }
    if (age < 13 || age > 120) {
      return 'Age must be between 13 and 120';
    }
    return null;
  }

  static String? validateConfirmPassword(String? value, String password) {
    if (value == null || value.isEmpty) {
      return 'Please confirm your password';
    }
    if (value != password) {
      return 'Passwords do not match';
    }
    return null;
  }

  static String? validateGender(String? value) {
    if (value == null || value.isEmpty) {
      return 'Gender is required';
    }
    return null;
  }

  static String? validateOTP(String? value, int length) {
    if (value == null || value.isEmpty) {
      return 'OTP is required';
    }
    if (value.length != length) {
      return 'OTP must be $length digits';
    }
    if (!RegExp(r'^\d+$').hasMatch(value)) {
      return 'OTP must contain only numbers';
    }
    return null;
  }
}
