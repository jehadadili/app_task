import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseConfig {
  final String mobileRegex;
  final String passwordRegex;
  final String countryCode;
  final Map<String, String> errorMessages;

  FirebaseConfig({
    required this.mobileRegex,
    required this.passwordRegex,
    required this.countryCode,
    required this.errorMessages,
  });

  factory FirebaseConfig.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return FirebaseConfig(
      mobileRegex: data['mobileRegex'] ?? '^7[0-8]{8}\$', // تصحيح الـ regex
      passwordRegex:
          data['passwordRegex'] ??
          '^(?=.*[a-z])(?=.*[A-Z])(?=.*\\d)[a-zA-Z\\d@!%*?&]{8,}\$',
      countryCode: data['countryCode'] ?? '+962',
      errorMessages: Map<String, String>.from(data['errorMessages'] ?? {}),
    );
  }

  factory FirebaseConfig.defaultConfig() {
    return FirebaseConfig(
      mobileRegex: '^7[0-8]{8}\$', // تصحيح: يجب أن يكون 7 ثم 8 أرقام
      passwordRegex: '^(?=.*[a-z])(?=.*[A-Z])(?=.*\\d)[a-zA-Z\\d@!%*?&]{8,}\$',
      countryCode: '+962',
      errorMessages: {
        'wrongPassword': 'Incorrect password',
        'userNotFound': 'User not found',
        'mobileMustBe9Digits':
            'Mobile number must be 9 digits', // إضافة الرسالة
      },
    );
  }
}
