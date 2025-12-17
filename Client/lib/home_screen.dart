import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  final String? username;
  const HomeScreen({super.key, this.username});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Home')),
      body: Center(
        child: Text('Welcome ${username ?? ''}', style: const TextStyle(fontSize: 20)),
      ),
    );
  }
}
