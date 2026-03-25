

import 'dart:convert';

import 'package:InfraVision/apis/api_config.dart';
import 'package:InfraVision/models/employees_model.dart';
import 'package:http/http.dart' as http;

Future<String> employeeEnrollment({
  required String username,
  required String name,
  required String type,
  required String dateOfBirth,
  required String address,
  required String salary,
  required String profile,
}) async {

  try {

    final response = await http.post(
      Uri.parse(ApiConfig.addEmployee),
      headers: {
        "Content-Type": "application/json",
      },
      body: jsonEncode({
        "Username": username,
        "Name": name,
        "Type": type,
        "DateOfBirth": dateOfBirth,
        "Address": address,
        "Salary": salary,
        "Profile": profile
      }),
    );

    final data = jsonDecode(response.body);

    return data["message"];

  } catch (e) {
    return "Employee enrollment failed";
  }
}


Future<List<Employees>> getEmployees() async {
  print("Fetching employees...");
  try {

    final response = await http.get(
      Uri.parse(ApiConfig.getEmployees),
    );

    if (response.statusCode == 200) {

      final data = jsonDecode(response.body);

      List employeesJson = data["employees"];

      return employeesJson
          .map((emp) => Employees.fromJson(emp))
          .toList();

    } else {
      return [];
    }

  } catch (e) {
    return [];
  }
}


Future<EmployeesDetails?> getEmployeeByUsername(String username) async {
  print("Fetching employee details for username: $username");

  try {
    final response = await http.get(
      Uri.parse(ApiConfig.getEmployeesbyusername + '/$username'),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final employeeList = data["employee"] as List;
    if (employeeList.isEmpty) return null;

    return EmployeesDetails.fromJson(employeeList[0]);
    } else {
      return null;
    }
  } catch (e) {
    return null;
  }
}

Future<String> updateEmployee({
  required String username,
  required String name,
  required String type,
  required String dateOfBirth,
  required String address,
  required String salary,
  required String profile,
}) async {
  try {
    final url = Uri.parse(ApiConfig.updateEmployee);

    final response = await http.put(
      url,
      headers: {
        "Content-Type": "application/json",
      },
      body: jsonEncode({
        "Username": username,
        "Name": name,
        "Type": type,
        "DateOfBirth": dateOfBirth,
        "Address": address,
        "Salary": salary,
        "Profile": profile,
      }),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      print("Update employee response: $data");
      return data['message'] ?? "Employee updated successfully";
    } else {
      final data = jsonDecode(response.body);
      return data['message'] ?? "Failed to update employee";
    }
  } catch (e) {
    print("Error updating employee: $e");
    return "Error updating employee";
  }
}

Future<String> deleteEmployee(String username) async {
  try {
    // Construct the URL with username as a path parameter
    final url = Uri.parse('${ApiConfig.deleteEmployee}/$username');

    final response = await http.delete(
      url,
      headers: {
        "Content-Type": "application/json",
      },
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      print("Delete employee response: $data");
      return data['message'] ?? "Employee deleted successfully";
    } else {
      final data = jsonDecode(response.body);
      return data['message'] ?? "Failed to delete employee";
    }
  } catch (e) {
    print("Error deleting employee: $e");
    return "Error deleting employee";
  }
}


Future<List<dynamic>> getAllEmployees() async {
  try {
    final response = await http.get(Uri.parse(ApiConfig.getAllEmployees));

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = jsonDecode(response.body);

      return data["employees"] ?? [];
    } else {
      print("Failed: ${response.body}");
      return [];
    }
  } catch (e) {
    print("Error: $e");
    return [];
  }
}