import 'package:flutter/material.dart';
import '../services/mock_user.dart';
import '../routes.dart';
import '../widgets/avatar_with_edit.dart';
import '../widgets/primary_button.dart';
import '../widgets/glass_card.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> with SingleTickerProviderStateMixin {
  late final AnimationController _anim;

  @override
  void initState() {
    super.initState();
    _anim = AnimationController(vsync: this, duration: const Duration(milliseconds: 350))..forward();
  }

  @override
  void dispose() {
    _anim.dispose();
    super.dispose();
  }

  Future<void> _openEdit() async {
    await Navigator.pushNamed(context, Routes.editProfile);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Profile')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(children: [
          ScaleTransition(
            scale: CurvedAnimation(parent: _anim, curve: Curves.easeOutBack),
            child: GlassCard(
              padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
              child: Row(children: [
                AvatarWithEdit(initials: MockUser.name.isNotEmpty ? MockUser.name[0] : 'U', radius: 44, onEdit: _openEdit),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Text(MockUser.name, style: theme.textTheme.titleLarge),
                    const SizedBox(height: 6),
                    Text(MockUser.email, style: theme.textTheme.bodyMedium?.copyWith(color: Colors.black54)),
                    const SizedBox(height: 2),
                    Text('Employee ID: ${MockUser.employeeId}', style: theme.textTheme.bodyMedium?.copyWith(color: Colors.black54)),
                  ]),
                )
              ]),
            ),
          ),
          const SizedBox(height: 16),
          PrimaryButton(onPressed: _openEdit, child: const Text('Edit Profile')),
          const SizedBox(height: 8),
          PrimaryButton(onPressed: () => Navigator.pushNamed(context, Routes.changePassword), child: const Text('Change Password')),
          const SizedBox(height: 8),
          OutlinedButton(onPressed: () => Navigator.pushNamed(context, Routes.forgot), child: const Text('Forgot Password')),
          const Spacer(),
          TextButton(onPressed: () { Navigator.pushReplacementNamed(context, Routes.login); }, child: const Text('Logout')),
        ]),
      ),
    );
  }
}
