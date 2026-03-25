class Employees {
  final String name;
  final String username;
  final String type;

  Employees({
    required this.name,
    required this.username,
    required this.type,
  });

  factory Employees.fromJson(Map<String, dynamic> json) {
    return Employees(
      name: json['Name'],
      username: json['Username'],
      type: json['Type'],
    );
  }
}

class EmployeesDetails extends Employees {
  final String dateofbirth;
  final String address;
  final int salary;

  EmployeesDetails({
    required String name,
    required String username,
    required String type,
    required this.dateofbirth,
    required this.address,
    required this.salary,
  }) : super(name: name, username: username, type: type);

  factory EmployeesDetails.fromJson(Map<String, dynamic> json) {
    return EmployeesDetails(
      name: json['Name'],
      username: json['Username'],
      type: json['Type'],
      dateofbirth: json['DateOfBirth'],
      address: json['Address'],
      salary: json['Salary'],
    );
  }
}