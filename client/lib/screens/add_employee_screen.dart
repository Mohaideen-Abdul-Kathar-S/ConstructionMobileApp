import 'package:InfraVision/apis/employee_service.dart';
import 'package:InfraVision/models/employees_model.dart';
import 'package:flutter/material.dart';
import '../widgets/bouncy_wrapper.dart';
import 'package:intl/intl.dart';

class AddEmployeeScreen extends StatefulWidget {
  final String? username;
  const AddEmployeeScreen({super.key, this.username});

  @override
  State<AddEmployeeScreen> createState() => _AddEmployeeScreenState();
}

class _AddEmployeeScreenState extends State<AddEmployeeScreen> {
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = true;

  // Controllers
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _dobController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _salaryController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();

  String _selectedType = 'Type A';
  DateTime? _selectedDate;

@override
void initState() {
  super.initState();
  if (widget.username != null) {
    
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await loaduserdata(widget.username);
    });
  } else {
    _isLoading = false;
  }
}

  Future<void> loaduserdata(String? username) async {
    if (username == null) return;

    EmployeesDetails? employee = await getEmployeeByUsername(username);
print('Fetched employee: $employee');
if (employee == null) return;

    DateTime? dob;

    try {
      dob = DateTime.parse(employee.dateofbirth);
    } catch (e) {
      dob = null;
    }

    setState(() {
      _nameController.text = employee.name;
      _dobController.text = employee.dateofbirth;
      _addressController.text = employee.address;
      _salaryController.text = employee.salary.toString();
      _usernameController.text = employee.username;
      _selectedType = employee.type;

      _selectedDate = dob; // important
      _isLoading = false;
    });
  }

  @override
  void dispose() {
    _nameController.dispose();
    _dobController.dispose();
    _addressController.dispose();
    _salaryController.dispose();
    _usernameController.dispose();
    super.dispose();
  }

  void _clearForm() {
    _nameController.clear();
    _dobController.clear();
    _addressController.clear();
    _salaryController.clear();
    _usernameController.clear();
    setState(() {
      _selectedType = 'Type A';
      _selectedDate = null;
    });
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now().subtract(
        const Duration(days: 365 * 18),
      ), // 18 years ago
      firstDate: DateTime(1950),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: Theme.of(context).colorScheme.copyWith(
              primary: Theme.of(context).colorScheme.primary, // Indigo
              onPrimary: Colors.white,
              onSurface: Theme.of(context).colorScheme.secondary,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
        _dobController.text = DateFormat('yyyy-MM-dd').format(picked);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final bool isUpdating = widget.username != null;

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
              _buildAppBar(context, theme, colorScheme, isUpdating),
              Expanded(
                child: _isLoading
                    ? Center(
                        child: CircularProgressIndicator(color: colorScheme.primary),
                      )
                    : SingleChildScrollView(
                        physics: const BouncingScrollPhysics(),
                        padding: const EdgeInsets.all(24.0),
                        child: Form(
                          key: _formKey,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                isUpdating ? 'Update Employee' : 'Employee Details',
                                style: theme.textTheme.headlineSmall?.copyWith(
                                  color: colorScheme.onSurface,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: -0.5,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                isUpdating
                                    ? 'Modify the information below to update this profile.'
                                    : 'Please fill in the information below to enrol a new employee.',
                                style: theme.textTheme.bodyMedium?.copyWith(
                                  color: colorScheme.onSurface.withOpacity(0.6),
                                ),
                              ),
                              const SizedBox(height: 32),

                              // Employee Type Selector
                              Text(
                                'Employee Type',
                                style: theme.textTheme.titleMedium?.copyWith(
                                  color: colorScheme.onSurface,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 16),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(child: _buildTypeOption('Type A', theme, colorScheme)),
                                  const SizedBox(width: 8),
                                  Expanded(child: _buildTypeOption('Type B', theme, colorScheme)),
                                  const SizedBox(width: 8),
                                  Expanded(child: _buildTypeOption('Type C', theme, colorScheme)),
                                ],
                              ),
                              const SizedBox(height: 32),

                              // Form Fields
                              _buildTextField(
                                controller: _nameController,
                                label: 'Employee Name',
                                icon: Icons.person_outline_rounded,
                                theme: theme,
                                colorScheme: colorScheme,
                                textInputAction: TextInputAction.next,
                              ),
                              const SizedBox(height: 20),

                              // Date of Birth
                              GestureDetector(
                                onTap: () => _selectDate(context),
                                child: AbsorbPointer(
                                  child: _buildTextField(
                                    controller: _dobController,
                                    label: 'Date of Birth',
                                    icon: Icons.calendar_today_rounded,
                                    theme: theme,
                                    colorScheme: colorScheme,
                                    hint: 'YYYY-MM-DD',
                                  ),
                                ),
                              ),
                              const SizedBox(height: 20),

                              _buildTextField(
                                controller: _addressController,
                                label: 'Address of Employee',
                                icon: Icons.location_on_outlined,
                                theme: theme,
                                colorScheme: colorScheme,
                                maxLines: 3,
                                textInputAction: TextInputAction.next,
                              ),
                              const SizedBox(height: 20),

                              _buildTextField(
                                controller: _salaryController,
                                label: 'Salary',
                                icon: Icons.attach_money_rounded,
                                theme: theme,
                                colorScheme: colorScheme,
                                keyboardType: TextInputType.number,
                                textInputAction: TextInputAction.next,
                              ),
                              const SizedBox(height: 20),

                              _buildTextField(
                                controller: _usernameController,
                                label: 'Username',
                                icon: Icons.account_circle_outlined,
                                theme: theme,
                                colorScheme: colorScheme,
                                textInputAction: TextInputAction.done,
                                enabled: !isUpdating,
                              ),
                              const SizedBox(height: 48),

                              // Action Buttons
                              Row(
                                children: [
                                  if (!isUpdating) ...[
                                    Expanded(
                                      child: BouncyWrapper(
                                        onTap: () {
                                          _clearForm();
                                          ScaffoldMessenger.of(context).showSnackBar(
                                            SnackBar(
                                              content: const Text('Form cleared'),
                                              backgroundColor: colorScheme.secondary,
                                              behavior: SnackBarBehavior.floating,
                                            ),
                                          );
                                        },
                                        child: Container(
                                          padding: const EdgeInsets.symmetric(vertical: 16),
                                          decoration: BoxDecoration(
                                            color: colorScheme.surface,
                                            borderRadius: BorderRadius.circular(16),
                                            boxShadow: [
                                              BoxShadow(
                                                color: Colors.black.withOpacity(0.04),
                                                blurRadius: 10,
                                                offset: const Offset(0, 4),
                                              ),
                                            ],
                                          ),
                                          child: Center(
                                            child: Text(
                                              'Clear',
                                              style: TextStyle(
                                                color: colorScheme.onSurface,
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 16),
                                  ],
                                  Expanded(
                                    flex: 2,
                                    child: BouncyWrapper(
                                      onTap: () async {
                                        if (_formKey.currentState!.validate()) {
                                          String result;
                                          if (isUpdating) {
                                            // Update existing employee
                                            result = await updateEmployee(
                                              username: _usernameController.text,
                                              name: _nameController.text,
                                              type: _selectedType,
                                              dateOfBirth: _dobController.text,
                                              address: _addressController.text,
                                              salary: _salaryController.text,
                                              profile: "Empty",
                                            );
                                          } else {
                                            // Add new employee
                                            result = await employeeEnrollment(
                                              username: _usernameController.text,
                                              name: _nameController.text,
                                              type: _selectedType,
                                              dateOfBirth: _dobController.text,
                                              address: _addressController.text,
                                              salary: _salaryController.text,
                                              profile: "Empty",
                                            );
                                          }
                                          if (result == "Employee added successfully" ||
                                              result == "Employee updated successfully") {
                                            if (context.mounted) {
                                              ScaffoldMessenger.of(context).showSnackBar(
                                                SnackBar(
                                                  content: Text(
                                                    isUpdating
                                                        ? '$_selectedType Updated Successfully!'
                                                        : '$_selectedType Enrolled Successfully!',
                                                  ),
                                                  backgroundColor: Colors.green.shade600,
                                                  behavior: SnackBarBehavior.floating,
                                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                                                ),
                                              );
                                              Navigator.pop(context, true); // Go back after submission
                                            }
                                          } else {
                                            if (context.mounted) {
                                              ScaffoldMessenger.of(context).showSnackBar(
                                                SnackBar(
                                                  content: Text(result),
                                                  backgroundColor: colorScheme.error,
                                                  behavior: SnackBarBehavior.floating,
                                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                                                ),
                                              );
                                            }
                                          }
                                        }
                                      },
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(vertical: 16),
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
                                              blurRadius: 10,
                                              offset: const Offset(0, 4),
                                            ),
                                          ],
                                        ),
                                        child: Center(
                                          child: Text(
                                            isUpdating ? 'Update Profile' : 'Enrol Now',
                                            style: const TextStyle(
                                              color: Colors.white,
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                              letterSpacing: 0.5,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 24),
                            ],
                          ),
                        ),
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAppBar(BuildContext context, ThemeData theme, ColorScheme colorScheme, bool isUpdating) {
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
            isUpdating ? 'Edit Employee' : 'Enrol Employee',
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
              color: colorScheme.onSurface,
              letterSpacing: -0.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTypeOption(String type, ThemeData theme, ColorScheme colorScheme) {
    bool isSelected = _selectedType == type;
    return BouncyWrapper(
      onTap: () {
        setState(() {
          _selectedType = type;
        });
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeOutCubic,
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          color: isSelected ? colorScheme.primary : theme.cardColor,
          borderRadius: BorderRadius.circular(16),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: colorScheme.primary.withOpacity(0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ]
              : [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.02),
                    blurRadius: 6,
                    offset: const Offset(0, 2),
                  ),
                ],
          border: Border.all(
            color: isSelected ? colorScheme.primary : colorScheme.onSurface.withOpacity(0.1),
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Center(
          child: Text(
            type,
            style: TextStyle(
              color: isSelected ? Colors.white : colorScheme.onSurface.withOpacity(0.7),
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    required ThemeData theme,
    required ColorScheme colorScheme,
    int maxLines = 1,
    TextInputType keyboardType = TextInputType.text,
    TextInputAction textInputAction = TextInputAction.done,
    String? hint,
    bool enabled = true,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: enabled ? theme.cardColor : theme.cardColor.withOpacity(0.5),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: TextFormField(
        controller: controller,
        maxLines: maxLines,
        keyboardType: keyboardType,
        textInputAction: textInputAction,
        enabled: enabled,
        style: theme.textTheme.bodyMedium?.copyWith(
          color: enabled ? colorScheme.onSurface : colorScheme.onSurface.withOpacity(0.5),
          fontWeight: FontWeight.w500,
        ),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Please enter $label';
          }
          return null;
        },
        decoration: InputDecoration(
          labelText: label,
          hintText: hint,
          labelStyle: TextStyle(
            color: colorScheme.onSurface.withOpacity(0.5),
            fontWeight: FontWeight.w500,
          ),
          prefixIcon: Icon(icon, color: colorScheme.primary.withOpacity(enabled ? 0.7 : 0.4)),
          filled: true,
          fillColor: Colors.transparent,
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide(color: colorScheme.primary.withOpacity(0.5), width: 1.5),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide(color: colorScheme.error.withOpacity(0.5), width: 1.5),
          ),
        ),
      ),
    );
  }
}
