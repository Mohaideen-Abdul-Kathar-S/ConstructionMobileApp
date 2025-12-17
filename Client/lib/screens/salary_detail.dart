import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../services/mock_data.dart';
import '../services/pdf_service.dart';

class SalaryDetailPage extends StatelessWidget {
  const SalaryDetailPage({super.key});

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
    final DateTime? start = args?['start'];
    final DateTime? end = args?['end'];
    final df = DateFormat('dd.MM.yyyy');

    // For demo, pick the first matching salary record
    var list = MockData.salary;
    if (start != null && end != null) list = list.where((r) => !r.date.isBefore(start) && !r.date.isAfter(end)).toList();
    final record = list.isNotEmpty ? list.first : null;

    return Scaffold(
      appBar: AppBar(title: const Text('Salary Detail')),
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: record == null
            ? const Center(child: Text('No salary data for selected range'))
            : Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  if (start != null && end != null) Text('From ${df.format(start)} to ${df.format(end)}'),
                  const SizedBox(height: 12),
                  Card(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                        Text('Date: ${df.format(record.date)}', style: const TextStyle(fontWeight: FontWeight.w600)),
                        const SizedBox(height: 8),
                        Text('Total Working Days: ${record.workingDays}'),
                        Text('Present Days: ${record.presentDays}'),
                        Text('Absent Days: ${record.absentDays}'),
                        const SizedBox(height: 12),
                        Text('Final Salary: \$${record.amount.toStringAsFixed(2)}', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
                      ]),
                    ),
                  ),
                  const SizedBox(height: 12),
                  ElevatedButton(onPressed: () async { await PdfService.exportSalaryPdf(start: start, end: end); if (!context.mounted) return; ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Exported (mock)'))); }, child: const Text('Export as PDF'))
                ],
              ),
      ),
    );
  }
}
