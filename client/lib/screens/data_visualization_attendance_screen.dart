import 'package:flutter/material.dart';

class DataVisualizationAttendanceScreen extends StatelessWidget {
  const DataVisualizationAttendanceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Theme colors
    final Color primaryColor = const Color(0xFF4F46E5); // Indigo
    final Color backgroundColor = const Color(0xFFF8FAFC); // Very light slate
    final Color cardColor = Colors.white;
    final Color textColor = const Color(0xFF334155); // Slate

    final Color dividerColor = const Color(0xFFE2E8F0); // Slate light

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: cardColor,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: textColor),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          'Data Visualization Attendance',
          style: TextStyle(
            color: textColor,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        titleSpacing: 0,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Information Text Section
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: primaryColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: primaryColor.withOpacity(0.2)),
                ),
                child: Text(
                  "I am Not sure about what kind of data going to visualize",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: primaryColor,
                    height: 1.5,
                  ),
                ),
              ),
              const SizedBox(height: 32),
              
              // Graph 1 Section
              Text(
                'Graph 1',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: textColor,
                ),
              ),
              const SizedBox(height: 16),
              Container(
                width: double.infinity,
                height: 250,
                decoration: BoxDecoration(
                  color: cardColor,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.04),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                  border: Border.all(color: dividerColor),
                ),
                child: Center(
                  child: Icon(
                    Icons.bar_chart_rounded,
                    size: 150,
                    color: primaryColor.withOpacity(0.3),
                  ),
                ),
              ),
              
              const SizedBox(height: 32),
              
              // Graph 2 Section
              Text(
                'Graph 2',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: textColor,
                ),
              ),
              const SizedBox(height: 16),
              Container(
                width: double.infinity,
                height: 250,
                decoration: BoxDecoration(
                  color: cardColor,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.04),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                  border: Border.all(color: dividerColor),
                ),
                child: Center(
                  child: Icon(
                    Icons.show_chart_rounded,
                    size: 150,
                    color: const Color(0xFF10B981).withOpacity(0.3), // Emerald
                  ),
                ),
              ),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }
}
