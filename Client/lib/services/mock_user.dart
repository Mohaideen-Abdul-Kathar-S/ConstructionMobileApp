/// Simple mock user service to hold editable profile data.
class MockUser {
  static String username = '';
  static String name = '';
  static String email = '';
  static String employeeId = '';

  /// Populate from a backend user map (expects keys like `Username`, `Email`).
  static void setFromMap(Map<String, dynamic> map) {
    username = map['Username'] ?? username;
    name = map['Name'] ?? map['Username'] ?? name;
    email = map['Email'] ?? email;
    employeeId = map['EmployeeId'] ?? employeeId;
  }

  /// Simulate local update; fields left null are unchanged.
  static Future<void> update({String? newName, String? newEmail, String? newEmployeeId}) async {
    await Future.delayed(const Duration(milliseconds: 400));
    if (newName != null) name = newName;
    if (newEmail != null) email = newEmail;
    if (newEmployeeId != null) employeeId = newEmployeeId;
  }
}
