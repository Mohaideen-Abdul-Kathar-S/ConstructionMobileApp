import 'dart:convert';

import 'package:InfraVision/apis/api_config.dart';
import 'package:http/http.dart' as http;

Future<Map<String, dynamic>?> saveSalaryReport({
  required String username,
  required String? startDate,
  required String? endDate,
  required int shiftCount,
  required int amount,
  required String type,
}) async {
  try {
    final response = await http.post(
      Uri.parse(ApiConfig.updateSalary),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "dateTime": DateTime.now().toIso8601String().split('T')[0],
        "Username": username,
        "StartDate": (startDate == null || startDate.isEmpty)
            ? DateTime.now().toIso8601String().split('T')[0]
            : startDate,
        "EndDate": (endDate == null || endDate.isEmpty)
            ? DateTime.now().toIso8601String().split('T')[0]
            : endDate,
        "ShiftCount": shiftCount,
        "amount": amount,
        "Type": type,
      }),
    );

    final data = jsonDecode(response.body);

    if (response.statusCode == 200 || response.statusCode == 201) {
      print("Salary saved successfully");
      return data;
    } else {
      print("Error: ${data["message"]}");
      return null;
    }
  } catch (e) {
    print("API Error: $e");
    return null;
  }
}

Future<Map<String, dynamic>?> getSalaryReport(String dateTime) async {
  try {
    final response = await http.get(
      Uri.parse("${ApiConfig.getSalaryDetails}/$dateTime"),
      headers: {"Content-Type": "application/json"},
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data;
    } else if (response.statusCode == 404) {
      print("No salary report found");
      return null;
    } else {
      print("Error: ${response.body}");
      return null;
    }
  } catch (e) {
    print("API Error: $e");
    return null;
  }
}

Future<List<dynamic>> getAllSalaryReportByRange(
  String? startDate,
  String? endDate,
) async {
  DateTime now = DateTime.now();
  startDate = (startDate == null || startDate.isEmpty)
      ? now.subtract(Duration(days: 21)).toIso8601String().split('T')[0]
    : startDate;
  endDate = (endDate == null || endDate.isEmpty)
      ? now.toIso8601String().split('T')[0]
    : endDate;
      
  try {
    final response = await http.get(
      Uri.parse("${ApiConfig.getAllSalaryReportByRange}/$startDate/$endDate"),
      headers: {"Content-Type": "application/json"},
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      print(data);
      return data;
    } else if (response.statusCode == 404) {
      return [];
    } else {
      throw Exception("Failed to load salary reports");
    }
  } catch (e) {
    print("Error fetching salary reports: $e");
    return [];
  }
}
