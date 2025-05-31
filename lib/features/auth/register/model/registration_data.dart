class RegistrationData {
  final String fullName;
  final String mobile;
  final int? age;
  final String? gender;
  final String password;
  final String confirmPassword;

  RegistrationData({
    required this.fullName,
    required this.mobile,
    required this.age,
    required this.gender,
    required this.password,
    required this.confirmPassword,
  });
}