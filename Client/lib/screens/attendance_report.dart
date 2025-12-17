import 'package:flutter/material.dart';
import '../models/attendance_record.dart';
import '../services/mock_data.dart';
import '../services/pdf_service.dart';
import 'package:intl/intl.dart';
import '../routes.dart';

class AttendanceReportPage extends StatefulWidget {
  const AttendanceReportPage({super.key});

  @override
  State<AttendanceReportPage> createState() => _AttendanceReportPageState();
}

class _AttendanceReportPageState extends State<AttendanceReportPage> {
  DateTime? _start;
  DateTime? _end;

  List<AttendanceRecord> get filtered {
    final list = MockData.attendance;
    if (_start == null || _end == null) return list;
    return list.where((r) => !r.date.isBefore(_start!) && !r.date.isAfter(_end!)).toList();
  }

  Future<void> _pickStart() async {
    final now = DateTime.now();
    final d = await showDatePicker(context: context, initialDate: _start ?? now.subtract(const Duration(days: 7)), firstDate: DateTime(2020), lastDate: DateTime(2100));
    if (d != null) setState(() => _start = d);
  }

  Future<void> _pickEnd() async {
    final now = DateTime.now();
    final d = await showDatePicker(context: context, initialDate: _end ?? now, firstDate: DateTime(2020), lastDate: DateTime(2100));
    if (d != null) setState(() => _end = d);
  }

  @override
  Widget build(BuildContext context) {
    final dateFmt = DateFormat('dd.MM.yyyy');

    return Scaffold(
      appBar: AppBar(title: const Text('Attendance Record')),
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: _pickStart,
                    child: Text(_start == null ? 'Start Date' : dateFmt.format(_start!)),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: OutlinedButton(onPressed: _pickEnd, child: Text(_end == null ? 'End Date' : dateFmt.format(_end!))),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                ElevatedButton(onPressed: () => Navigator.pushNamed(context, Routes.attendanceDetail, arguments: {'start': _start, 'end': _end}), child: const Text('View Report')),
                OutlinedButton(onPressed: () async {
                  final messenger = ScaffoldMessenger.of(context);
                  await PdfService.exportAttendancePdf(start: _start, end: _end);
                  if (!mounted) return;
                  messenger.showSnackBar(const SnackBar(content: Text('Exported (mock)')));
                }, child: const Text('Export as pdf')),
              ],
            ),
            const SizedBox(height: 12),
            Expanded(
              child: filtered.isEmpty
                  ? Center(child: Column(mainAxisSize: MainAxisSize.min, children: const [Icon(Icons.inbox, size: 48), SizedBox(height: 8), Text('No records')]))
                  : ListView.separated(
                      itemCount: filtered.length,
                      separatorBuilder: (context, index) => const SizedBox(height: 8),
                      itemBuilder: (context, index) {
                        final r = filtered[index];
                        return Card(
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          child: ListTile(
                            title: Text(dateFmt.format(r.date)),
                            subtitle: Row(children: [Text('FN: ${r.fnStatus}'), const SizedBox(width: 12), Text('AN: ${r.anStatus}')]),
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
