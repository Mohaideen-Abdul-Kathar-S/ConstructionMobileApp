class AttendanceRecord {
  final DateTime date;
  final String fnStatus; // Forenoon
  final String anStatus; // Afternoon

  AttendanceRecord({required this.date, required this.fnStatus, required this.anStatus});
}
