import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/attendance_record.dart';
import '../services/mock_data.dart';
import '../services/pdf_service.dart';

class AttendanceDetailPage extends StatelessWidget {
  const AttendanceDetailPage({super.key});

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
    final DateTime? start = args?['start'];
    final DateTime? end = args?['end'];
    final dateFmt = DateFormat('dd.MM.yyyy');

    // For demo, filter mock data similarly
    List<AttendanceRecord> list = MockData.attendance;
    if (start != null && end != null) {
      list = list.where((r) => !r.date.isBefore(start) && !r.date.isAfter(end)).toList();
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Attendance Detail')),
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            if (start != null && end != null) Text('From ${dateFmt.format(start)} to ${dateFmt.format(end)}'),
            const SizedBox(height: 12),
            ElevatedButton(onPressed: () async { await PdfService.exportAttendancePdf(start: start, end: end); if (context.mounted) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Exported (mock)'))); }, child: const Text('Export to PDF')),
            const SizedBox(height: 12),
            Expanded(
              child: ListView.separated(
                itemCount: list.length,
                separatorBuilder: (context, index) => const SizedBox(height: 8),
                itemBuilder: (context, i) {
                  final r = list[i];
                  return Card(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    child: ListTile(
                      title: Text(dateFmt.format(r.date)),
                      subtitle: Text('FN: ${r.fnStatus} • AN: ${r.anStatus}'),
                      trailing: Text(r.fnStatus == 'Present' || r.anStatus == 'Present' ? 'Present' : (r.fnStatus == 'Leave' || r.anStatus == 'Leave' ? 'Leave' : 'Absent')),
                    ),
                  );
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
