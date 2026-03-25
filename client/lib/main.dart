import 'package:InfraVision/core/secure_storage_service.dart';
import 'package:InfraVision/screens/dashboard_screen.dart';
import 'package:flutter/material.dart';
import 'screens/login_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  Future<String?> _getUsername() async {
    return await SecureStorageService.getUsername();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Construction Mobile App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: const ColorScheme(
          brightness: Brightness.light,
          primary: Color(0xFF4F46E5),
          onPrimary: Colors.white,
          secondary: Color(0xFF334155),
          onSecondary: Colors.white,
          background: Color(0xFFFFFFFF),
          onBackground: Color(0xFF334155),
          surface: Color(0xFFFFFFFF),
          onSurface: Color(0xFF334155),
          error: Color(0xFFEF4444),
          onError: Colors.white,
          tertiary: Color(0xFF10B981),
          onTertiary: Colors.white,
        ),
        scaffoldBackgroundColor: const Color(0xFFFFFFFF),
        useMaterial3: true,
      ),

      home: FutureBuilder<String?>(
        future: _getUsername(),
        builder: (context, snapshot) {

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Scaffold(
              body: Center(child: CircularProgressIndicator()),
            );
          }

          if (snapshot.data != null) {
            return const DashboardScreen();
          }

          return const LoginScreen();
        },
      ),
    );
  }
}