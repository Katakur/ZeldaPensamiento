import 'package:flutter/material.dart';

class AboutPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'About This App',
          style: TextStyle(fontFamily: 'zelda', fontSize: 20),
        ),
        backgroundColor: Color.fromARGB(255, 205, 247, 253),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Welcome to Our Application!',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Color.fromARGB(255, 80, 121, 76),
              ),
            ),
            SizedBox(height: 16),
            Text(
              'This application is designed to help you manage and explore equipment with ease. Here, you can view details, mark your favorite items, and explore various categories.',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 16),
            Text(
              'Features:',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Color.fromARGB(255, 80, 121, 76),
              ),
            ),
            SizedBox(height: 8),
            Text(
              '- View detailed information about equipment\n'
              '- Toggle favorite status\n'
              '- Explore different categories\n'
              '- Search and filter items',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 16),
            Text(
              'Thank you for using our application!',
              style: TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}
