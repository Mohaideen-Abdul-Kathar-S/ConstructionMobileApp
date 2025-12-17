import 'dart:ui';
import 'package:flutter/material.dart';

class GlassCard extends StatelessWidget {
  final Widget child;
  final EdgeInsets padding;
  final BorderRadius borderRadius;

  const GlassCard({super.key, required this.child, this.padding = const EdgeInsets.all(16), this.borderRadius = const BorderRadius.all(Radius.circular(16))});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: borderRadius,
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
        child: Container(
          padding: padding,
          decoration: BoxDecoration(
            color: Color.fromRGBO(255, 255, 255, 0.66),
            borderRadius: borderRadius,
            border: Border.all(color: Color.fromRGBO(255, 255, 255, 0.6)),
            boxShadow: const [BoxShadow(color: Color(0x0A000000), blurRadius: 12, offset: Offset(0, 6))],
          ),
          child: child,
        ),
      ),
    );
  }
}
