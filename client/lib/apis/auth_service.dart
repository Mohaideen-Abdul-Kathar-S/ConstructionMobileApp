import 'dart:convert';
import 'package:http/http.dart' as http;
import 'api_config.dart';

Future<String> loginUser(String username, String password) async {
  try {
    
    final response = await http.post(
      Uri.parse(ApiConfig.loginUrl),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"Username": username, "Password": password}),
    );
    

    if (response.statusCode == 200) {
      return "Login successful";
    } else {
      return "Invalid credentials";
    }
  } catch (e) {
    return e.toString();
  }
}


