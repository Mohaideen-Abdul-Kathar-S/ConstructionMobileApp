import 'package:flutter/material.dart';

class ARViewerScreen extends StatelessWidget {
  final String modelName;

  const ARViewerScreen({super.key, required this.modelName});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.background,
      appBar: AppBar(
        title: Text(modelName),
        backgroundColor: colorScheme.background,
        foregroundColor: colorScheme.onSurface,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.info_outline),
            onPressed: () {
              // Info action
            },
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.view_in_ar,
              size: 100,
              color: colorScheme.tertiary, // Cyan accent
            ),
            const SizedBox(height: 24),
            Text(
              'AR Viewer Module',
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: colorScheme.onSurface,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Loading 3D Model:\n$modelName',
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyLarge?.copyWith(
                color: colorScheme.secondary,
              ),
            ),
            const SizedBox(height: 32),
            CircularProgressIndicator(
              color: colorScheme.tertiary,
            ),
            const SizedBox(height: 48),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 48.0),
              child: Text(
                'Point your camera at a flat surface to place the model once loaded.',
                textAlign: TextAlign.center,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: colorScheme.secondary.withOpacity(0.7),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
