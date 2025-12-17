/// Mock authentication service for demo purposes.
class MockAuthService {
  /// Simulate a login call. Returns true if both fields are non-empty.
  static Future<bool> login(String username, String password) async {
    await Future.delayed(const Duration(milliseconds: 600));
    if (username.trim().isEmpty || password.trim().isEmpty) {
      return false;
    }
    return true;
  }
}
