import 'package:flutter/material.dart';

class MonsterPage extends StatelessWidget {
  const MonsterPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Equipment Page'),
      ),
      body: const Center(
        child: Text('This is the Equipment Page'),
      ),
    );
  }
}
