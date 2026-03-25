import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStorageService {
  static const FlutterSecureStorage storage = FlutterSecureStorage();

  static Future<void> saveUsername(String username) async {
    await storage.write(key: "username", value: username);
  }

  static Future<String?> getUsername() async {
    return await storage.read(key: "username");
  }

  static Future<void> logout() async {
    await storage.deleteAll();
  }
}