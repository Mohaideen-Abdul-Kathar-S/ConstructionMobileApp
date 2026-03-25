

import 'package:InfraVision/apis/attendance_service.dart';
import 'package:flutter/material.dart';

class AttendanceScreen extends StatefulWidget {
  final String date;
  const AttendanceScreen({super.key, required this.date});

  @override
  State<AttendanceScreen> createState() => _AttendanceScreenState();
}

class _AttendanceScreenState extends State<AttendanceScreen>
   with TickerProviderStateMixin {
  

  final Color primaryColor = const Color(0xFF4F46E5); // Indigo
  final Color backgroundColor = const Color(0xFFF8FAFC); // Very light slate
  final Color cardColor = Colors.white;
  final Color textColor = const Color(0xFF334155); // Slate
  final Color textLightColor = const Color(0xFF64748B); // Slate lighter
  final Color dividerColor = const Color(0xFFE2E8F0); // Slate light

  final Color presentColor = const Color(0xFF10B981); // Emerald
  final Color absentColor = const Color(0xFFEF4444); // Red

  final TextEditingController _searchController = TextEditingController();

  TabController? _tabController;
  Map<String, dynamic>? data;
  List<String> employeeTypes = [];

  bool _isAN = true; // true for AF (Afternoon), false for FN (Forenoon)

  // Dummy data state for toggle switches


  @override
  void initState() {
    super.initState();
    loadData();
  }

  @override
  void dispose() {
    _tabController?.dispose();
    _searchController.dispose();
    super.dispose();
  }

  

void loadData() async {

String convertDate(String date) {
  List<String> parts = date.split(".");
  return "${parts[2]}-${parts[1]}-${parts[0]}";
}

  Map<String, dynamic> tdata =
      await viewAttendanceByDateAndShift(convertDate(widget.date), _isAN ? "AN" : "FN");

  print("Data loaded: $tdata");

  List<String> types = tdata.keys
      .where((k) => k != "presentCount" && k != "absentCount")
      .toList();

  if (types.isNotEmpty) {
     _tabController?.dispose();
    setState(() {
      _tabController = TabController(length: types.length, vsync: this);
      employeeTypes = types.sublist(0, types.length);
      data = tdata;
    });
  }
}

  @override
  Widget build(BuildContext context) {
    if (_tabController == null) {
      return Scaffold(
        backgroundColor: backgroundColor,
        body: const Center(child: CircularProgressIndicator()),
      );
    }
    
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    
    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
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
              _buildAppBar(context, theme, colorScheme),
              _buildSummarySection(theme, colorScheme),
              _buildTabs(theme, colorScheme),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
                child: _buildSearchSection(theme, colorScheme),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0),
                  child: _buildEmployeeList(theme, colorScheme),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAppBar(BuildContext context, ThemeData theme, ColorScheme colorScheme) {
    return Padding(
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
              onPressed: () => Navigator.of(context).pop(),
            ),
          ),
          const SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Attendance',
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: colorScheme.onSurface,
                  letterSpacing: -0.5,
                ),
              ),
              Text(
                widget.date,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: colorScheme.onSurface.withOpacity(0.6),
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          const Spacer(),
          Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () {
                _isAN = !_isAN;
                loadData();
              },
              borderRadius: BorderRadius.circular(12),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: colorScheme.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: colorScheme.primary.withOpacity(0.3)),
                ),
                child: Text(
                  _isAN ? 'AF' : 'FN',
                  style: TextStyle(
                    color: colorScheme.primary,
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSummarySection(ThemeData theme, ColorScheme colorScheme) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
        decoration: BoxDecoration(
          color: theme.cardColor,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.03),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _buildSummaryItem(data?['presentCount'].toString() ?? '0', 'Present', presentColor, theme, colorScheme),
            Container(height: 40, width: 1, color: colorScheme.onSurface.withOpacity(0.1)),
            _buildSummaryItem(data?['absentCount'].toString() ?? '0', 'Absent', absentColor, theme, colorScheme),
            Container(height: 40, width: 1, color: colorScheme.onSurface.withOpacity(0.1)),
            _buildSummaryItem(
              ((data?['presentCount'] ?? 0) + (data?['absentCount'] ?? 0)).toString(),
              'Total',
              colorScheme.primary,
              theme,
              colorScheme,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryItem(String count, String label, Color color, ThemeData theme, ColorScheme colorScheme) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          count,
          style: theme.textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: theme.textTheme.bodySmall?.copyWith(
            fontWeight: FontWeight.w600,
            color: colorScheme.onSurface.withOpacity(0.6),
          ),
        ),
      ],
    );
  }

  Widget _buildTabs(ThemeData theme, ColorScheme colorScheme) {
    if (_tabController == null) {
      return const SizedBox();
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: Container(
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
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: TabBar(
            controller: _tabController,
            labelColor: theme.colorScheme.onPrimary,
            unselectedLabelColor: colorScheme.onSurface.withOpacity(0.6),
            indicatorSize: TabBarIndicatorSize.tab,
            indicator: BoxDecoration(
              color: colorScheme.primary,
              borderRadius: BorderRadius.circular(16),
            ),
            labelStyle: const TextStyle(fontWeight: FontWeight.bold),
            tabs: employeeTypes.map((type) => Tab(text: type)).toList(),
          ),
        ),
      ),
    );
  }

  Widget _buildSearchSection(ThemeData theme, ColorScheme colorScheme) {
    return Container(
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: TextField(
        controller: _searchController,
        style: theme.textTheme.bodyMedium?.copyWith(
          color: colorScheme.onSurface,
          fontWeight: FontWeight.w500,
        ),
        decoration: InputDecoration(
          hintText: 'Search employees...',
          hintStyle: TextStyle(color: colorScheme.onSurface.withOpacity(0.5), fontSize: 14),
          prefixIcon: Icon(Icons.search_rounded, color: colorScheme.primary.withOpacity(0.7)),
          filled: true,
          fillColor: Colors.transparent,
          contentPadding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide.none,
          ),
        ),
      ),
    );
  }

  Widget _buildEmployeeList(ThemeData theme, ColorScheme colorScheme) {
    if (data == null || _tabController == null) {
      return const Center(child: CircularProgressIndicator());
    }

    return AnimatedBuilder(
      animation: _tabController!,
      builder: (context, child) {
        final currentType = employeeTypes[_tabController!.index];
        final List employees = (data?[currentType] as List?) ?? [];

        if (employees.isEmpty) {
          return Center(
            child: Text(
              'No records found.',
              style: theme.textTheme.bodyLarge?.copyWith(
                color: colorScheme.onSurface.withOpacity(0.5),
              ),
            ),
          );
        }

        return ListView.separated(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.only(bottom: 24),
          itemCount: employees.length,
          separatorBuilder: (context, index) => const SizedBox(height: 12),
          itemBuilder: (context, index) {
            final employee = employees[index];
            final bool isPresent = employee['isPresent'];
            final String name = employee['Name'];

            return Container(
              decoration: BoxDecoration(
                color: theme.cardColor,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.02),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                child: Row(
                  children: [
                    Container(
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        color: colorScheme.primary.withOpacity(0.1),
                        shape: BoxShape.circle,
                      ),
                      child: Center(
                        child: Text(
                          name.isNotEmpty ? name[0].toUpperCase() : '?',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: colorScheme.primary,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Text(
                        name,
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: colorScheme.onSurface,
                        ),
                      ),
                    ),
                    Switch(
                      value: isPresent,
                      activeColor: Colors.white,
                      activeTrackColor: presentColor,
                      inactiveThumbColor: Colors.white,
                      inactiveTrackColor: absentColor,
                      trackOutlineColor: MaterialStateProperty.all(Colors.transparent),
                      onChanged: (value) {
                        setState(() {
                          employees[index]['isPresent'] = value;
                        });
                      },
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}
