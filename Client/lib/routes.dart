import 'package:flutter/material.dart';
import 'screens/splash_screen.dart';
import 'screens/login_page.dart';
import 'screens/forgot_password.dart';
import 'screens/dashboard.dart';
import 'screens/attendance_report.dart';
import 'screens/attendance_detail.dart';
import 'screens/salary_report.dart';
import 'screens/salary_detail.dart';
import 'screens/settings_page.dart';
import 'screens/edit_profile.dart';
import 'screens/change_password.dart';

class Routes {
  static const splash = '/';
  static const login = '/login';
  static const forgot = '/forgot';
  static const dashboard = '/dashboard';
  static const attendance = '/attendance';
  static const attendanceDetail = '/attendance/detail';
  static const salary = '/salary';
  static const salaryDetail = '/salary/detail';
  static const settings = '/settings';
  static const editProfile = '/edit-profile';
  static const changePassword = '/change-password';
}

class AppRoutes {
  static final Map<String, WidgetBuilder> routes = {
    Routes.splash: (context) => const SplashScreen(),
    Routes.login: (context) => const LoginPage(),
    Routes.forgot: (context) => const ForgotPasswordPage(),
    Routes.dashboard: (context) => const DashboardPage(),
    Routes.attendance: (context) => const AttendanceReportPage(),
    Routes.attendanceDetail: (context) => const AttendanceDetailPage(),
    Routes.salary: (context) => const SalaryReportPage(),
    Routes.salaryDetail: (context) => const SalaryDetailPage(),
    Routes.settings: (context) => const SettingsPage(),
    Routes.editProfile: (context) => const EditProfilePage(),
    Routes.changePassword: (context) => const ChangePasswordPage(),
  };
}
