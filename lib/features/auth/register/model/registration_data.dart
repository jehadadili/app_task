class RegistrationData {
  final String fullName;
  final String mobile;
  final int age;
  final String gender;
  final String password;

  RegistrationData({
    required this.fullName,
    required this.mobile,
    required this.age,
    required this.gender,
    required this.password,
  });

  RegistrationData copyWith({
    String? fullName,
    String? mobile,
    int? age,
    String? gender,
    String? password,
  }) {
    return RegistrationData(
      fullName: fullName ?? this.fullName,
      mobile: mobile ?? this.mobile,
      age: age ?? this.age,
      gender: gender ?? this.gender,
      password: password ?? this.password,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'fullName': fullName,
      'mobile': mobile,
      'age': age,
      'gender': gender,
      'password': password,
    };
  }

  @override
  String toString() {
    return 'RegistrationData(fullName: $fullName, mobile: $mobile, age: $age, gender: $gender)';
  }
}