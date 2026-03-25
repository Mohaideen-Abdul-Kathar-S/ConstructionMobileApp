
import 'package:InfraVision/apis/employee_service.dart';
import 'package:InfraVision/models/employees_model.dart';
import 'package:flutter/material.dart';
import 'add_employee_screen.dart';

class ManageEmployeeScreen extends StatefulWidget {
  const ManageEmployeeScreen({super.key});

  @override
  State<ManageEmployeeScreen> createState() => _ManageEmployeeScreenState();
}

class _ManageEmployeeScreenState extends State<ManageEmployeeScreen>
    with SingleTickerProviderStateMixin {
  late TabController? _tabController;
  List<Employees> employees = [];
  List<Employees> filteredEmployees = [];
  List<String> employeeTypes = [];

  final TextEditingController _searchController = TextEditingController();
  List<Employees> searchResults = [];

  @override
  void initState() {
    super.initState();

    loadEmployees();

    _searchController.addListener(_onSearchChanged);
  }


void _onSearchChanged() {
  final query = _searchController.text.toLowerCase();
  setState(() {
   searchResults = employees.where((emp) {
      return emp.name.toLowerCase().contains(query) ||
             emp.username.toLowerCase().contains(query) ||
             emp.type.toLowerCase().contains(query);
    }).toList();
  });
}

  @override
  void dispose() {
    _tabController?.dispose();
    _searchController.dispose();
    super.dispose();
  }


  Future<void> loadEmployees() async {
    List<Employees> data = await getEmployees();

    List<String> types = data.map((e) => e.type).toSet().toList();

    if (types.isNotEmpty) {
      _tabController = TabController(length: types.length, vsync: this);

      _tabController?.addListener(() {
        setState(() {
          filteredEmployees = employees
              .where((emp) => emp.type == employeeTypes[_tabController!.index])
              .toList();
        });
      });
    } else {
      _tabController = null;
    }

    setState(() {
      employees = data;
      employeeTypes = types;

      if (employeeTypes.isNotEmpty) {
        filteredEmployees = employees
            .where((emp) => emp.type == employeeTypes[0])
            .toList();
      } else {
        filteredEmployees = employees;
      }
    });
  }

  

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final Color textColor = colorScheme.onSurface;
    final Color textLightColor = colorScheme.onSurface.withOpacity(0.6);

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
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildAppBar(context, theme, colorScheme),
              if (employeeTypes.isNotEmpty && _tabController != null)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                  child: Container(
                    decoration: BoxDecoration(
                      color: theme.cardColor,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.04),
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
                        unselectedLabelColor: textColor.withOpacity(0.6),
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
                ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Employee ${employeeTypes.isNotEmpty && _tabController != null ? employeeTypes[_tabController!.index] : "All"}',
                            style: theme.textTheme.titleLarge?.copyWith(
                              color: textColor,
                              fontWeight: FontWeight.bold,
                              letterSpacing: -0.5,
                            ),
                          ),
                          Container(
                            decoration: BoxDecoration(
                              color: colorScheme.primary,
                              borderRadius: BorderRadius.circular(12),
                              boxShadow: [
                                BoxShadow(
                                  color: colorScheme.primary.withOpacity(0.3),
                                  blurRadius: 8,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: IconButton(
                              icon: const Icon(Icons.add_rounded, color: Colors.white),
                              onPressed: () async {
                                bool? update = await Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const AddEmployeeScreen(),
                                  ),
                                );
                                if (update == true) {
                                  await loadEmployees();
                                }
                              },
                              tooltip: 'Add Employee',
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),
                      Container(
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
                        child: TextField(
                          controller: _searchController,
                          style: theme.textTheme.bodyMedium?.copyWith(
                            fontWeight: FontWeight.w500,
                            color: textColor,
                          ),
                          decoration: InputDecoration(
                            hintText: 'Search employees...',
                            hintStyle: TextStyle(color: textLightColor, fontSize: 14),
                            prefixIcon: Icon(Icons.search_rounded, color: colorScheme.primary.withOpacity(0.7)),
                            contentPadding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(16),
                              borderSide: BorderSide.none,
                            ),
                            filled: true,
                            fillColor: Colors.transparent,
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),
                      Expanded(
                        child: _buildEmployeeList(theme, colorScheme),
                      ),
                    ],
                  ),
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
          Text(
            'Manage Employee',
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
              color: colorScheme.onSurface,
              letterSpacing: -0.5,
            ),
          ),
          const Spacer(),
          Container(
            decoration: BoxDecoration(
              color: colorScheme.primary.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: IconButton(
              icon: Icon(Icons.refresh_rounded, color: colorScheme.primary),
              onPressed: () async {
                await loadEmployees();
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmployeeList(ThemeData theme, ColorScheme colorScheme) {
    final list = searchResults.isEmpty && _searchController.text.isEmpty ? filteredEmployees : searchResults;

    if (list.isEmpty) {
      return Center(
        child: Text(
          'No employees found.',
          style: theme.textTheme.bodyLarge?.copyWith(
            color: colorScheme.onSurface.withOpacity(0.5),
          ),
        ),
      );
    }

    return ListView.separated(
      physics: const BouncingScrollPhysics(),
      itemCount: list.length,
      padding: const EdgeInsets.only(bottom: 24),
      separatorBuilder: (context, index) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        final emp = list[index];
        return Container(
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
              onTap: () async {
                bool? update = await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AddEmployeeScreen(username: emp.username),
                  ),
                );
                if (update == true) {
                  await loadEmployees();
                }
              },
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  children: [
                    Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        color: colorScheme.primary.withOpacity(0.1),
                        shape: BoxShape.circle,
                      ),
                      child: Center(
                        child: Text(
                          emp.name.isNotEmpty ? emp.name[0].toUpperCase() : '?',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: colorScheme.primary,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            emp.name,
                            style: theme.textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: colorScheme.onSurface,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            emp.type,
                            style: theme.textTheme.bodySmall?.copyWith(
                              fontWeight: FontWeight.w500,
                              color: colorScheme.onSurface.withOpacity(0.6),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: Icon(Icons.edit_rounded, color: colorScheme.primary.withOpacity(0.8), size: 22),
                          onPressed: () async {
                            bool? update = await Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => AddEmployeeScreen(username: emp.username),
                              ),
                            );
                            if (update == true) {
                              await loadEmployees();
                            }
                          },
                          tooltip: 'Edit',
                        ),
                        IconButton(
                          icon: Icon(Icons.delete_rounded, color: colorScheme.error.withOpacity(0.9), size: 22),
                          onPressed: () async {
                            String result = await deleteEmployee(emp.name);

                            if (context.mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(result),
                                  backgroundColor: result.contains("success") ? Colors.green : Colors.red,
                                  behavior: SnackBarBehavior.floating,
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                                  margin: const EdgeInsets.all(10),
                                ),
                              );
                            }
                            if (result.contains("success")) {
                              await loadEmployees();
                            }
                          },
                          tooltip: 'Delete',
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
