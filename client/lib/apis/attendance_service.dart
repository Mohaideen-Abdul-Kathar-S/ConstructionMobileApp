import 'dart:convert';

import 'package:InfraVision/apis/api_config.dart';
import 'package:http/http.dart' as http;

Future<Map<String, dynamic>?> initializeAttendance() async {
  try {
    // Format the dateTime as ISO string for the URL
    DateTime dateTime = DateTime.now();
    final String isoDateTime = dateTime.toIso8601String();
    print("Initializing attendance for dateTime: $isoDateTime");

    // Make the POST request
    final response = await http.post(
      Uri.parse(
        '${ApiConfig.initializeAttendance}'
        '/$isoDateTime',
      ),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      // Decode JSON response
      final data = jsonDecode(response.body);
      print('Attendance initialized: $data');
      return data;
    } else {
      print('Failed to initialize attendance: ${response.body}');
      return null;
    }
  } catch (e) {
    print('Error initializing attendance: $e');
    return null;
  }
}

Future<Map<String, dynamic>?> getAttendance(String date, String shift) async {
  try {
    final response = await http.get(
      Uri.parse('${ApiConfig.getAttendance}/$date/$shift'),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      print('Attendance data: $data');
      return data;
    } else {
      print("Failed: ${response.body}");
      return null;
    }
  } catch (e) {
    print("Error fetching attendance: $e");
    return null;
  }
}

Future<bool> markAttendance(
  Map<String, dynamic> attendance,
  Map<String, dynamic>? currentShiftandDate,
) async {
  try {
    final response = await http.put(
      Uri.parse(ApiConfig.markAttendance),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        "AttendanceDate": attendance["AttendanceDate"],
        "Shift": currentShiftandDate?["Shift"] ?? "Unknown",
        "PresentList": attendance["PresentList"],
        "AbsentList": attendance["AbsentList"],
      }),
    );

    if (response.statusCode == 200) {
      print("Attendance saved");
      return true;
    } else {
      print("Failed: ${response.body}");
      return false;
    }
  } catch (e) {
    print("Error: $e");
    return false;
  }
}

Future<Map<String, dynamic>?> viewAttendance(String date, String shift) async {
  try {
    final response = await http.get(
      Uri.parse('${ApiConfig.getViewAttendance}/$date/$shift'),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);

      print("Attendance: ${data["attendance"]}");
      print("Previous: ${data["previousAttendances"]}");

      return data;
    } else {
      print("Failed: ${response.body}");
      return null;
    }
  } catch (e) {
    print("Error fetching attendance: $e");
    return null;
  }
}

Future<Map<String, dynamic>> viewAttendanceByDateAndShift(
  String date,
  String shift,
) async {
  try {
    final response = await http.get(
      Uri.parse('${ApiConfig.getViewAttendanceByDateAndShift}/$date/$shift'),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);

      print("data: $data");

      return data;
    } else {
      print("Failed: ${response.body}");
      return {};
    }
  } catch (e) {
    print("Error fetching attendance: $e");
    return {};
  }
}

Future<int> getShiftCount(
  String username,
  String? startDate,
  String? endDate,
) async {
  try {
    final response = await http.post(
      Uri.parse("${ApiConfig.getShiftCount}"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "Username": username,
        "StartDate": (startDate == null || startDate.isEmpty)
            ? DateTime.now().toIso8601String().split('T')[0]
            : startDate,
        "EndDate": (endDate == null || endDate.isEmpty)
            ? DateTime.now().toIso8601String().split('T')[0]
            : endDate,
      }),
    );

    final data = jsonDecode(response.body);
    print(data);

    if (response.statusCode == 200) {
      return data["shiftCount"] ?? 2;
    } else {
      print("Error: ${data["message"]}");
      return 0;
    }
  } catch (e) {
    print("API Error: $e");
    return 0;
  }
}
