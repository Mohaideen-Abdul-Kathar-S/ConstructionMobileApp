import 'package:flutter/material.dart';
import '../services/backend_service.dart';
import '../services/mock_user.dart';

class ChangePasswordPage extends StatefulWidget {
  const ChangePasswordPage({super.key});

  @override
  State<ChangePasswordPage> createState() => _ChangePasswordPageState();
}

class _ChangePasswordPageState extends State<ChangePasswordPage> {
  final _formKey = GlobalKey<FormState>();
  final _currentController = TextEditingController();
  final _newController = TextEditingController();
  final _confirmController = TextEditingController();

  @override
  void dispose() {
    _currentController.dispose();
    _newController.dispose();
    _confirmController.dispose();
    super.dispose();
  }

  void _clear() {
    _formKey.currentState?.reset();
    _currentController.clear();
    _newController.clear();
    _confirmController.clear();
  }

  Future<void> _update() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    final current = _currentController.text;
    final next = _newController.text;
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Updating password...')));
    try {
      final resp = await BackendService.instance.changePassword(MockUser.username, current, next);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(resp['message'] ?? 'Password changed')));
      _clear();
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: ${e.toString()}')));
    }
  }

  @override
  Widget build(BuildContext context) {
    const navy = Color(0xFF0B3D91);

    return Scaffold(
      backgroundColor: navy,
      appBar: AppBar(
        backgroundColor: Colors.white,
        iconTheme: const IconThemeData(color: Colors.black87),
        title: const Text('Change Password', style: TextStyle(color: Colors.black87)),
        elevation: 0,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              _passwordCard(),
              const SizedBox(height: 16),
              _alternateCard(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _passwordCard() {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _labelledField('Current Password', _currentController, obscure: true),
              const SizedBox(height: 12),
              _labelledField('New Password', _newController, obscure: true),
              const SizedBox(height: 12),
              _labelledField('Re-enter new Password', _confirmController, obscure: true, validator: (v) {
                if (v == null || v.isEmpty) return 'Please confirm new password';
                if (v != _newController.text) return 'Passwords do not match';
                return null;
              }),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: _clear,
                      child: const Text('Clear'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: _update,
                      style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF0B3D91)),
                      child: const Text('Update'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _alternateCard() {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _labelledField('E-Mail', TextEditingController()),
            const SizedBox(height: 12),
            _labelledField('Current Password', TextEditingController(), obscure: true),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(child: OutlinedButton(onPressed: () {}, child: const Text('Clear'))),
                const SizedBox(width: 12),
                Expanded(child: ElevatedButton(onPressed: () {}, style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF0B3D91)), child: const Text('Update'))),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _labelledField(String label, TextEditingController controller, {bool obscure = false, String? Function(String?)? validator}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(color: Colors.black54, fontSize: 13)),
        TextFormField(
          controller: controller,
          obscureText: obscure,
          validator: validator ?? (v) => (v == null || v.isEmpty) ? 'Required' : null,
          decoration: const InputDecoration(border: UnderlineInputBorder(), isDense: true, contentPadding: EdgeInsets.symmetric(vertical: 10)),
        ),
      ],
    );
  }
}
