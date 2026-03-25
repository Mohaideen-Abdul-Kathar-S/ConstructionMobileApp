import 'package:InfraVision/apis/attendance_service.dart';
import 'package:flutter/material.dart';

class AttendanceManagementScreen extends StatefulWidget {
  final Map<String, dynamic>? currentShiftandDate;
  const AttendanceManagementScreen({
    super.key,
    required this.currentShiftandDate,
  });

  @override
  State<AttendanceManagementScreen> createState() =>
      _AttendanceManagementScreenState();
}

class _AttendanceManagementScreenState extends State<AttendanceManagementScreen>
    with SingleTickerProviderStateMixin {
  TabController? _tabController;
  Map<String, dynamic>? attendance;
  List<String> employeeTypes = [];
  List<dynamic> employeesList = [];

  bool isLoading = true;
  List<dynamic> filteredEmployees = [];
  List<dynamic> searchResults = [];

  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();

    loadAttendanceData();
    _searchController.addListener(_onSearchChanged);
  }

  void _onSearchChanged() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      searchResults = filteredEmployees.where((emp) {
        return emp["Username"].toLowerCase().contains(query) ||
            emp["Type"].toLowerCase().contains(query);
      }).toList();
    });
  }

  Future<void> saveAttendance() async {
    if (attendance == null) return;

    attendance!["AbsentList"] = calculateAbsentList();

    await markAttendance(attendance!, widget.currentShiftandDate);
  }

  List<String> calculateAbsentList() {
    List<String> present = List<String>.from(attendance?["PresentList"] ?? []);

    List<String> allEmployees = employeesList
        .map((e) => e["Username"].toString())
        .toList();

    return allEmployees.where((emp) => !present.contains(emp)).toList();
  }

  void loadAttendanceData() async {
    setState(() {
      isLoading = true;
    });

    String date = widget.currentShiftandDate?["Date"] ?? DateTime.now().toIso8601String().split('T')[0];
    String shift = widget.currentShiftandDate?["Shift"] ?? "Unknown";

    final result = await getAttendance(date, shift);

    if (result != null) {
      List<dynamic> employees = result["TypeList"];

      List<String> types = employees
          .map((e) => e["Type"].toString())
          .toSet()
          .toList();

      if (types.isNotEmpty) {
        _tabController = TabController(length: types.length, vsync: this);

        _tabController!.addListener(() {
          setState(() {
            filteredEmployees = employees
                .where(
                  (emp) => emp["Type"] == employeeTypes[_tabController!.index],
                )
                .toList();
          });
        });
      }

      setState(() {
        attendance = result["attendance"];
        employeeTypes = types;
        employeesList = employees;

        filteredEmployees = employees
            .where((emp) => emp["Type"] == types.first)
            .toList();

        isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    _tabController?.dispose();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return WillPopScope(
      onWillPop: () async {
        await saveAttendance();
        return true; // allow navigation
      },
      child: Scaffold(
        body: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                colorScheme.surface,
                colorScheme.primary.withOpacity(0.05),
                colorScheme.secondary.withOpacity(0.05),
              ],
            ),
          ),
          child: SafeArea(
            child: Column(
              children: [
                // Custom App Bar
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                  child: Row(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          color: colorScheme.surface,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.05),
                              blurRadius: 10,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: IconButton(
                          icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20),
                          color: colorScheme.onSurface,
                          onPressed: () => Navigator.pop(context),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Text(
                        'Attendance',
                        style: theme.textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: colorScheme.onSurface,
                          letterSpacing: -0.5,
                        ),
                      ),
                      const Spacer(),
                      if (isLoading)
                        const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      else
                        Container(
                          decoration: BoxDecoration(
                            color: colorScheme.primary.withOpacity(0.1),
                            shape: BoxShape.circle,
                          ),
                          child: IconButton(
                            icon: Icon(Icons.refresh_rounded, color: colorScheme.primary),
                            onPressed: loadAttendanceData,
                          ),
                        ),
                    ],
                  ),
                ),

                // Search Section
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
                  child: Container(
                    decoration: BoxDecoration(
                      color: theme.cardColor,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.04),
                          blurRadius: 20,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: TextField(
                      controller: _searchController,
                      style: theme.textTheme.bodyLarge,
                      decoration: InputDecoration(
                        hintText: 'Search employees...',
                        hintStyle: TextStyle(color: colorScheme.onSurface.withOpacity(0.4)),
                        prefixIcon: Icon(Icons.search_rounded, color: colorScheme.primary.withOpacity(0.7)),
                        border: InputBorder.none,
                        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                      ),
                    ),
                  ),
                ),

                // Tabs Section
                if (_tabController != null)
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 24.0),
                    decoration: BoxDecoration(
                      color: colorScheme.surface,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.03),
                          blurRadius: 10,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: TabBar(
                        controller: _tabController,
                        labelColor: colorScheme.onPrimary,
                        unselectedLabelColor: colorScheme.onSurface.withOpacity(0.6),
                        indicatorSize: TabBarIndicatorSize.tab,
                        indicator: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          color: colorScheme.primary,
                        ),
                        dividerColor: Colors.transparent,
                        labelStyle: const TextStyle(fontWeight: FontWeight.bold),
                        unselectedLabelStyle: const TextStyle(fontWeight: FontWeight.w500),
                        tabs: employeeTypes
                            .map((type) => Tab(
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                                    child: Text(type),
                                  ),
                                ))
                            .toList(),
                      ),
                    ),
                  ),

                const SizedBox(height: 16),

                // Employee Attendance List
                Expanded(
                  child: isLoading
                      ? Center(child: CircularProgressIndicator(color: colorScheme.primary))
                      : ListView.builder(
                          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 8.0),
                          itemCount: searchResults.isEmpty && _searchController.text.isEmpty
                              ? filteredEmployees.length
                              : searchResults.length,
                          itemBuilder: (context, index) {
                            final employeeListToUse = searchResults.isEmpty && _searchController.text.isEmpty
                                ? filteredEmployees
                                : searchResults;
                            
                            if (index >= employeeListToUse.length) return const SizedBox.shrink();
                            
                            final employee = employeeListToUse[index];
                            final isPresent = attendance?['PresentList']?.contains(employee['Username']) ?? false;

                            return Container(
                              margin: const EdgeInsets.only(bottom: 12.0),
                              decoration: BoxDecoration(
                                color: theme.cardColor,
                                borderRadius: BorderRadius.circular(16),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.03),
                                    blurRadius: 10,
                                    offset: const Offset(0, 4),
                                  ),
                                ],
                              ),
                              child: Material(
                                color: Colors.transparent,
                                child: InkWell(
                                  borderRadius: BorderRadius.circular(16),
                                  onTap: () {
                                    setState(() {
                                      if (isPresent) {
                                        attendance?['PresentList']?.remove(employee['Username']);
                                      } else {
                                        attendance?['PresentList']?.add(employee['Username']);
                                      }
                                    });
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.all(16.0),
                                    child: Row(
                                      children: [
                                        Container(
                                          padding: const EdgeInsets.all(10),
                                          decoration: BoxDecoration(
                                            color: isPresent 
                                                ? Colors.green.withOpacity(0.1) 
                                                : Colors.red.withOpacity(0.1),
                                            shape: BoxShape.circle,
                                          ),
                                          child: Icon(
                                            Icons.person,
                                            color: isPresent ? Colors.green : Colors.red,
                                            size: 20,
                                          ),
                                        ),
                                        const SizedBox(width: 16),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                employee['Username'],
                                                style: const TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),
                                              const SizedBox(height: 4),
                                              Text(
                                                isPresent ? 'Present' : 'Absent',
                                                style: TextStyle(
                                                  fontSize: 13,
                                                  fontWeight: FontWeight.w500,
                                                  color: isPresent ? Colors.green : Colors.red,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Switch.adaptive(
                                          value: isPresent,
                                          activeColor: Colors.green,
                                          activeTrackColor: Colors.green.withOpacity(0.3),
                                          inactiveThumbColor: Colors.red.shade400,
                                          inactiveTrackColor: Colors.red.withOpacity(0.2),
                                          onChanged: (value) {
                                            setState(() {
                                              if (isPresent) {
                                                attendance?['PresentList']?.remove(employee['Username']);
                                              } else {
                                                attendance?['PresentList']?.add(employee['Username']);
                                              }
                                            });
                                          },
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                ),

                // Save Button
                Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          colorScheme.primary,
                          colorScheme.primary.withOpacity(0.8),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: colorScheme.primary.withOpacity(0.3),
                          blurRadius: 12,
                          offset: const Offset(0, 6),
                        ),
                      ],
                    ),
                    child: ElevatedButton.icon(
                      onPressed: () async {
                        try {
                          await saveAttendance();
                          if (context.mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text("Attendance saved successfully ✅"),
                                backgroundColor: Colors.green,
                                duration: Duration(seconds: 2),
                              ),
                            );
                            Navigator.pop(context);
                          }
                        } catch (e) {
                          if (context.mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text("Error saving record: $e"),
                                backgroundColor: Colors.red,
                                duration: const Duration(seconds: 3),
                              ),
                            );
                          }
                        }
                      },
                      icon: const Icon(Icons.save_rounded, color: Colors.white),
                      label: const Text(
                        "Save Record",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.transparent,
                        shadowColor: Colors.transparent,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
