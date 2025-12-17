import 'dart:convert';
import 'package:http/http.dart' as http;

class BackendService {
  BackendService._privateConstructor();
  static final BackendService instance = BackendService._privateConstructor();

  /// Set this to your Express backend base URL, e.g. http://192.168.0.10:3000
  String baseUrl = 'http://localhost:3000';

  Uri _url(String path) => Uri.parse('$baseUrl$path');

  Future<Map<String, dynamic>> _processResponse(http.Response res) async {
    final body = res.body.isNotEmpty ? jsonDecode(res.body) as Map<String, dynamic> : <String, dynamic>{};
    if (res.statusCode >= 200 && res.statusCode < 300) return body;
    throw Exception(body['message'] ?? 'Request failed with status: ${res.statusCode}');
  }

  /// Login
  /// Sends { Username, Password }
  Future<Map<String, dynamic>> login(String username, String password) async {
    final res = await http.post(
      _url('/api/user/login'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'Username': username, 'Password': password}),
    );
    return _processResponse(res);
  }

  /// Change password
  /// Sends { Username, Password, NewPassword }
  Future<Map<String, dynamic>> changePassword(String username, String password, String newPassword) async {
    final res = await http.put(
      _url('/api/user/changepassword'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'Username': username, 'Password': password, 'NewPassword': newPassword}),
    );
    return _processResponse(res);
  }

  /// Update email
  /// Sends { Username, Password, Email }
  Future<Map<String, dynamic>> updateEmail(String username, String password, String email) async {
    final res = await http.put(
      _url('/api/user/changeemail'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'Username': username, 'Password': password, 'Email': email}),
    );
    return _processResponse(res);
  }

  /// Send OTP to registered user email
  /// Sends { Username }
  Future<Map<String, dynamic>> sendOtp(String username) async {
    final res = await http.post(
      _url('/api/user/sendotp'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'Username': username}),
    );
    return _processResponse(res);
  }

  /// Verify OTP and set new password
  /// Sends { Email, EnteredOtp, NewPassword }
  Future<Map<String, dynamic>> verifyOtp(String email, String enteredOtp, String newPassword) async {
    final res = await http.post(
      _url('/api/user/verifyotp'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'Email': email, 'EnteredOtp': enteredOtp, 'NewPassword': newPassword}),
    );
    return _processResponse(res);
  }
}

// Usage example:
// final resp = await BackendService.instance.login('alice', 'pass123');
// print(resp['message']);
