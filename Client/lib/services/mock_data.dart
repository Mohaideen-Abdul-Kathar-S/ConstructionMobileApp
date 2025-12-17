import '../models/attendance_record.dart';
import '../models/salary_record.dart';

class MockData {
  static List<AttendanceRecord> attendance = List.generate(10, (i) {
    final d = DateTime.now().subtract(Duration(days: i));
    final fn = (i % 6 == 0) ? 'Leave' : ((i % 3 == 0) ? 'Present' : 'Absent');
    final an = (i % 4 == 0) ? 'Present' : ((i % 5 == 0) ? 'Leave' : 'Absent');
    return AttendanceRecord(date: d, fnStatus: fn, anStatus: an);
  });

  static List<SalaryRecord> salary = List.generate(6, (i) {
    final d = DateTime.now().subtract(Duration(days: i * 30));
    final working = 22;
    final present = 18 - i;
    final absent = working - present;
    final amount = 3000.0 + i * 250;
    return SalaryRecord(date: d, amount: amount, workingDays: working, presentDays: present, absentDays: absent);
  });
}
