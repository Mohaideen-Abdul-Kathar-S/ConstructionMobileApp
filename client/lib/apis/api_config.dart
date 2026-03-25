class ApiConfig {

  static const String baseUrl = "http://10.204.73.153:5000/api";

// User
  static String loginUrl = "$baseUrl/user/login";

// Employee
  static const String addEmployee = "$baseUrl/employee/addemployee";
  static const String deleteEmployee = "$baseUrl/employee/deleteemployee";
  static const String updateEmployee = "$baseUrl/employee/updateemployee";
  static const String getEmployees = "$baseUrl/employee/employees";
  static const String getEmployeesbyusername = "$baseUrl/employee/employeebyusername";
  static const String getAllEmployees = "$baseUrl/employee/allemployee";

// Attendance
  static const String initializeAttendance = "$baseUrl/attendance/initializeattendance";
  static const String getAttendance = "$baseUrl/attendance/getattendance";
  static const String markAttendance = "$baseUrl/attendance/markattendance";
  static const String getViewAttendance = "$baseUrl/attendance/viewattendance";
  static const String getViewAttendanceByDateAndShift = "$baseUrl/attendance/viewattendancebydateandshift";
  static const String getShiftCount = "$baseUrl/attendance/getshiftcount";

// Salary
  static const String updateSalary = "$baseUrl/salary/savesalary";
  static const String getSalaryDetails = "$baseUrl/salary/getsalaryreport";
  static const String getAllSalaryReportByRange = "$baseUrl/salary/getallSalary";
  
}
