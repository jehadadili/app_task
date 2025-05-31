class SystemConfigModel {
  final String mobileRegex;
  final String passwordRegex;
  final String defaultCountryCode;
  // Add other configuration fields as needed based on Firestore structure
  final String? someOtherConfig;

  SystemConfigModel({
    required this.mobileRegex,
    required this.passwordRegex,
    required this.defaultCountryCode,
    this.someOtherConfig,
  });

  // Factory constructor to create a SystemConfigModel from Firestore data
  factory SystemConfigModel.fromMap(Map<String, dynamic> map) {
    return SystemConfigModel(
      mobileRegex: map["mobileRegex"] as String? ?? ".*", // Provide a default regex
      passwordRegex: map["passwordRegex"] as String? ?? ".*", // Provide a default regex
      defaultCountryCode: map["defaultCountryCode"] as String? ?? "+1",
      someOtherConfig: map["someOtherConfig"] as String?,
    );
  }

  // Method to convert a SystemConfigModel instance to a map (less common for config)
  Map<String, dynamic> toMap() {
    return {
      "mobileRegex": mobileRegex,
      "passwordRegex": passwordRegex,
      "defaultCountryCode": defaultCountryCode,
      "someOtherConfig": someOtherConfig,
    };
  }
}

