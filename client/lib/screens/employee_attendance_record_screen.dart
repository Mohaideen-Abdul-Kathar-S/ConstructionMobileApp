import 'package:flutter/material.dart';

class EmployeeAttendanceRecordScreen extends StatefulWidget {
  const EmployeeAttendanceRecordScreen({super.key});

  @override
  State<EmployeeAttendanceRecordScreen> createState() =>
      _EmployeeAttendanceRecordScreenState();
}

class _EmployeeAttendanceRecordScreenState
    extends State<EmployeeAttendanceRecordScreen> {
  // Theme colors
  final Color primaryColor = const Color(0xFF4F46E5); // Indigo
  final Color backgroundColor = const Color(0xFFF8FAFC); // Very light slate
  final Color cardColor = Colors.white;
  final Color textColor = const Color(0xFF334155); // Slate
  final Color textLightColor = const Color(0xFF64748B); // Slate lighter
  final Color dividerColor = const Color(0xFFE2E8F0); // Slate light
  final Color presentColor = const Color(0xFF10B981); // Emerald
  final Color absentColor = const Color(0xFFEF4444); // Red
  final Color leaveColor = const Color(0xFFF59E0B); // Amber

  final TextEditingController _startDateController = TextEditingController();
  final TextEditingController _endDateController = TextEditingController();

  @override
  void dispose() {
    _startDateController.dispose();
    _endDateController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: _buildAppBar(context),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildSearchByDate(),
              const SizedBox(height: 24),
              _buildRecordsHeader(),
              const SizedBox(height: 16),
              Expanded(
                child: _buildRecordsList(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  AppBar _buildAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: cardColor,
      elevation: 0,
      leading: IconButton(
        icon: Icon(Icons.arrow_back, color: textColor),
        onPressed: () => Navigator.of(context).pop(),
      ),
      title: Text(
        'Attendance Record',
        style: TextStyle(
          color: textColor,
          fontWeight: FontWeight.bold,
          fontSize: 20,
        ),
      ),
      centerTitle: false,
    );
  }

  Widget _buildSearchByDate() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Search by Date',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: textColor,
          ),
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: _buildDateField('Start Date', _startDateController),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12.0),
              child: Text(
                '-',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w500,
                  color: textLightColor,
                ),
              ),
            ),
            Expanded(child: _buildDateField('End Date', _endDateController)),
          ],
        ),
      ],
    );
  }

  Widget _buildDateField(String hint, TextEditingController controller) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: TextStyle(color: textLightColor, fontSize: 14),
        contentPadding: const EdgeInsets.symmetric(
          vertical: 14,
          horizontal: 16,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: dividerColor, width: 1.5),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: primaryColor, width: 1.5),
        ),
        filled: true,
        fillColor: cardColor,
      ),
      readOnly: true,
      onTap: () async {
        DateTime? pickedDate = await showDatePicker(
          context: context,
          initialDate: DateTime.now(),
          firstDate: DateTime(2000),
          lastDate: DateTime(2101),
        );
        if (pickedDate != null) {
          String formattedDate =
              "${pickedDate.day.toString().padLeft(2, '0')}.${pickedDate.month.toString().padLeft(2, '0')}.${pickedDate.year}";
          setState(() {
            controller.text = formattedDate;
          });
        }
      },
    );
  }

  Widget _buildRecordsHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          'Records',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: textColor,
          ),
        ),
        ElevatedButton(
          onPressed: () {
            // Functionality to export as pdf
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: primaryColor,
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            minimumSize: Size.zero,
            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          ),
          child: const Text(
            'Export as pdf',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildRecordsList() {
    // Generate some mock records for the list
    final List<Map<String, String>> mockData = [
      {'date': '12.10.2023', 'fn': 'Present', 'an': 'Present'},
      {'date': '11.10.2023', 'fn': 'Present', 'an': 'Absent'},
      {'date': '10.10.2023', 'fn': 'Leave', 'an': 'Leave'},
      {'date': '09.10.2023', 'fn': 'Absent', 'an': 'Absent'},
      {'date': '08.10.2023', 'fn': 'Present', 'an': 'Present'},
      {'date': '07.10.2023', 'fn': 'Present', 'an': 'Present'},
    ];

    return ListView.separated(
      itemCount: mockData.length,
      separatorBuilder: (context, index) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        final data = mockData[index];
        return Row(
          children: [
            Expanded(
              child: _buildStatusCard(
                'FN - ${data['fn']}',
                data['date']!,
                data['fn']!,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildStatusCard(
                'AN - ${data['an']}',
                data['date']!,
                data['an']!,
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildStatusCard(String title, String date, String status) {
    Color statusColor;
    if (status == 'Present') {
      statusColor = presentColor;
    } else if (status == 'Absent') {
      statusColor = absentColor;
    } else {
      statusColor = leaveColor;
    }

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: dividerColor),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w600,
              color: statusColor,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            date,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: textLightColor,
            ),
          ),
        ],
      ),
    );
  }
}
