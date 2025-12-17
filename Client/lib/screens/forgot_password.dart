import 'package:flutter/material.dart';
import '../routes.dart';
import '../services/backend_service.dart';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({super.key});

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  bool _sending = false;

  @override
  void dispose() {
    _usernameController.dispose();
    super.dispose();
  }

  Future<void> _send() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _sending = true);
    try {
      await BackendService.instance.sendOtp(_usernameController.text.trim());
      if (!mounted) return;
      setState(() => _sending = false);
      // Prompt for OTP + new password
      await showDialog(
        context: context,
        builder: (ctx) {
          final otpCtl = TextEditingController();
          final emailCtl = TextEditingController();
          final newPassCtl = TextEditingController();
          return AlertDialog(
            title: const Text('Enter OTP and new password'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(controller: emailCtl, decoration: const InputDecoration(labelText: 'Email')),
                TextField(controller: otpCtl, decoration: const InputDecoration(labelText: 'OTP')),
                TextField(controller: newPassCtl, decoration: const InputDecoration(labelText: 'New password'), obscureText: true),
              ],
            ),
            actions: [
              TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
              TextButton(
                onPressed: () async {
                  final email = emailCtl.text.trim();
                  final otp = otpCtl.text.trim();
                  final np = newPassCtl.text;
                  final navigator = Navigator.of(context);
                  try {
                    final v = await BackendService.instance.verifyOtp(email, otp, np);
                    if (!mounted) return;
                    navigator.pop();
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(v['message'] ?? 'Password reset')));
                  } catch (e) {
                    if (!mounted) return;
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Verify failed: ${e.toString()}')));
                  }
                },
                child: const Text('Submit'),
              ),
            ],
          );
        },
      );
    } catch (e) {
      if (!mounted) return;
      setState(() => _sending = false);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Send OTP failed: ${e.toString()}')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Forgot Password')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 8),
            Form(
              key: _formKey,
                child: TextFormField(
                controller: _usernameController,
                decoration: const InputDecoration(labelText: 'Username'),
                validator: (v) => v == null || v.trim().isEmpty ? 'Required' : null,
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(onPressed: _sending ? null : _send, child: const Text('Send Reset Link')),
            const SizedBox(height: 8),
            TextButton(onPressed: () => Navigator.pushReplacementNamed(context, Routes.login), child: const Text('Back to Login')),
          ],
        ),
      ),
    );
  }
}
