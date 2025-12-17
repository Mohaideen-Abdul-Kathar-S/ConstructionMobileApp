import 'dart:async';
import 'package:flutter/material.dart';
import '../routes.dart';
import '../theme/app_theme.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;
  late final Animation<double> _scale;
  late final Animation<double> _fade;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 900));
    _scale = CurvedAnimation(parent: _ctrl, curve: Curves.easeOutBack);
    _fade = CurvedAnimation(parent: _ctrl, curve: Curves.easeIn);
    _ctrl.forward();
    Timer(const Duration(milliseconds: 1300), () => Navigator.pushReplacementNamed(context, Routes.login));
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final grad = LinearGradient(colors: [AppTheme.primary, AppTheme.accent], begin: Alignment.topLeft, end: Alignment.bottomRight);

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(gradient: grad),
        child: Center(
          child: FadeTransition(
            opacity: _fade,
            child: ScaleTransition(
              scale: _scale,
              child: Container(
                width: 140,
                height: 140,
                decoration: BoxDecoration(color: Color.fromRGBO(255, 255, 255, 0.9), borderRadius: BorderRadius.circular(24), boxShadow: const [BoxShadow(color: Color(0x1F000000), blurRadius: 20, offset: Offset(0, 8))]),
                child: Center(
                  child: Column(mainAxisSize: MainAxisSize.min, children: [
                    Icon(Icons.apartment, size: 48, color: theme.colorScheme.primary),
                    const SizedBox(height: 8),
                    Text('Attendance', style: theme.textTheme.titleMedium?.copyWith(color: theme.colorScheme.primary)),
                  ]),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
