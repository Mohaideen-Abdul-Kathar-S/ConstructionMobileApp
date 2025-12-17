import 'package:flutter/material.dart';
import '../services/mock_user.dart';
import '../widgets/avatar_with_edit.dart';
import '../widgets/primary_button.dart';

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({super.key});

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameCtl;
  late final TextEditingController _emailCtl;
  late final TextEditingController _idCtl;
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    _nameCtl = TextEditingController(text: MockUser.name);
    _emailCtl = TextEditingController(text: MockUser.email);
    _idCtl = TextEditingController(text: MockUser.employeeId);
  }

  @override
  void dispose() {
    _nameCtl.dispose();
    _emailCtl.dispose();
    _idCtl.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _saving = true);
    await MockUser.update(newName: _nameCtl.text.trim(), newEmail: _emailCtl.text.trim(), newEmployeeId: _idCtl.text.trim());
    if (!mounted) return;
    setState(() => _saving = false);
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Profile updated')));
    Navigator.pop(context);
  }

  void _changeAvatar() {
    // Avatar change stub: show a dialog
    showDialog(context: context, builder: (_) => AlertDialog(title: const Text('Change Avatar'), content: const Text('Avatar change is a stub in this demo.'), actions: [TextButton(onPressed: () => Navigator.pop(context), child: const Text('OK'))]));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Edit Profile')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(children: [
            AvatarWithEdit(initials: MockUser.name.isNotEmpty ? MockUser.name[0] : 'U', radius: 54, onEdit: _changeAvatar),
            const SizedBox(height: 16),
            TextFormField(controller: _nameCtl, decoration: const InputDecoration(labelText: 'Name'), validator: (v) => v == null || v.trim().isEmpty ? 'Required' : null),
            const SizedBox(height: 12),
            TextFormField(controller: _emailCtl, decoration: const InputDecoration(labelText: 'E-Mail'), validator: (v) => v == null || v.trim().isEmpty ? 'Required' : null),
            const SizedBox(height: 12),
            TextFormField(controller: _idCtl, decoration: const InputDecoration(labelText: 'Employee ID'), validator: (v) => v == null || v.trim().isEmpty ? 'Required' : null),
            const SizedBox(height: 20),
            SizedBox(width: double.infinity, child: PrimaryButton(onPressed: _saving ? () {} : _save, loading: _saving, child: _saving ? const Text('Saving...') : const Text('Save'))),
          ]),
        ),
      ),
    );
  }
}
