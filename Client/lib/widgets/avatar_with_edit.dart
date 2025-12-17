import 'package:flutter/material.dart';

class AvatarWithEdit extends StatelessWidget {
  final String initials;
  final double radius;
  final VoidCallback? onEdit;

  const AvatarWithEdit({super.key, required this.initials, this.radius = 44, this.onEdit});

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        CircleAvatar(
          radius: radius,
          backgroundColor: Theme.of(context).colorScheme.primaryContainer,
          child: Text(initials, style: TextStyle(fontSize: radius / 2.2, color: Theme.of(context).colorScheme.onPrimaryContainer)),
        ),
        Positioned(
          right: -4,
          bottom: -4,
          child: Material(
            color: Theme.of(context).colorScheme.secondary,
            shape: const CircleBorder(),
            elevation: 3,
            child: InkWell(
              onTap: onEdit,
              customBorder: const CircleBorder(),
              child: Padding(
                padding: const EdgeInsets.all(6.0),
                child: Icon(Icons.camera_alt, size: radius * 0.35, color: Colors.white),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
