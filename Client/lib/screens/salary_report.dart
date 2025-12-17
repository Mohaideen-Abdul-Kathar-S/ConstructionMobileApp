import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../services/mock_data.dart';
import '../models/salary_record.dart';
import '../services/pdf_service.dart';
import '../routes.dart';

class SalaryReportPage extends StatefulWidget {
  const SalaryReportPage({super.key});

  @override
  State<SalaryReportPage> createState() => _SalaryReportPageState();
}

class _SalaryReportPageState extends State<SalaryReportPage> {
  DateTime? _start;
  DateTime? _end;

  List<SalaryRecord> get filtered {
    final list = MockData.salary;
    if (_start == null || _end == null) return list;
    return list.where((r) => !r.date.isBefore(_start!) && !r.date.isAfter(_end!)).toList();
  }

  Future<void> _pickStart() async {
    final now = DateTime.now();
    final d = await showDatePicker(context: context, initialDate: _start ?? now.subtract(const Duration(days: 30)), firstDate: DateTime(2020), lastDate: DateTime(2100));
    if (d != null) setState(() => _start = d);
  }

  Future<void> _pickEnd() async {
    final now = DateTime.now();
    final d = await showDatePicker(context: context, initialDate: _end ?? now, firstDate: DateTime(2020), lastDate: DateTime(2100));
    if (d != null) setState(() => _end = d);
  }

  @override
  Widget build(BuildContext context) {
    final df = DateFormat('dd.MM.yyyy');

    return Scaffold(
      appBar: AppBar(title: const Text('Salary Record')),
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(child: OutlinedButton(onPressed: _pickStart, child: Text(_start == null ? 'Start Date' : df.format(_start!)))),
                const SizedBox(width: 8),
                Expanded(child: OutlinedButton(onPressed: _pickEnd, child: Text(_end == null ? 'End Date' : df.format(_end!)))),
              ],
            ),
            const SizedBox(height: 12),
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              ElevatedButton(onPressed: () => Navigator.pushNamed(context, Routes.salaryDetail, arguments: {'start': _start, 'end': _end}), child: const Text('View Salary Details')),
              OutlinedButton(onPressed: () async {
                await PdfService.exportSalaryPdf(start: _start, end: _end);
                if (!context.mounted) return;
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Exported (mock)')));
              }, child: const Text('Export as pdf')),
            ]),
            const SizedBox(height: 12),
            Expanded(
              child: filtered.isEmpty
                  ? Center(child: Column(mainAxisSize: MainAxisSize.min, children: const [Icon(Icons.inbox, size: 48), SizedBox(height: 8), Text('No salary records')]))
                  : ListView.separated(
                      itemCount: filtered.length,
                      separatorBuilder: (context, index) => const SizedBox(height: 8),
                      itemBuilder: (context, i) {
                        final r = filtered[i];
                        return Card(
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          child: ListTile(
                            title: Text(df.format(r.date)),
                            subtitle: Text('Type: Monthly • Working days: ${r.workingDays}'),
                            trailing: Column(mainAxisAlignment: MainAxisAlignment.center, crossAxisAlignment: CrossAxisAlignment.end, children: [Text('\$${r.amount.toStringAsFixed(2)}', style: const TextStyle(fontWeight: FontWeight.w600)), Text('Present: ${r.presentDays}, Absent: ${r.absentDays}', style: const TextStyle(fontSize: 12))]),
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
