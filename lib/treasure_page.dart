import 'package:flutter/material.dart';

class TreasurePage extends StatelessWidget {
  const TreasurePage({super.key});

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
