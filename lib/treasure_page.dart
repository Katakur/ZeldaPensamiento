import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'model/treasure.dart';

class TreasurePage extends StatefulWidget {
  const TreasurePage({super.key});

  @override
  _TreasurePageState createState() => _TreasurePageState();
}

class _TreasurePageState extends State<TreasurePage> {
  late Future<List<Treasure>> futureTreasure;

  @override
  void initState() {
    super.initState();
    futureTreasure = fetchMonster();
  }

  Future<List<Treasure>> fetchMonster() async {
    final response = await http.get(Uri.parse('https://botw-compendium.herokuapp.com/api/v3/compendium/category/treasure'));

    if (response.statusCode == 200) {
      final List<dynamic> jsonDecoded = jsonDecode(response.body)["data"] as List<dynamic>;
      return jsonDecoded.map((dynamic item) => Treasure.fromJson(item as Map<String, dynamic>)).toList();
    } else {
      throw Exception('Failed to load Treasure');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Treasure Page'),
      ),
      body: Center(
        child: FutureBuilder<List<Treasure>>(
          future: futureTreasure,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const CircularProgressIndicator();
            } else if (snapshot.hasError) {
              return Text("Error: ${snapshot.error}");
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return const Text("No data available");
            } else {
              return ListView.builder(
                itemCount: snapshot.data!.length,
                itemBuilder: (context, index) {
                  final treasure = snapshot.data![index];
                  return ListTile(
                    leading: Image.network(treasure.image, width: 50, height: 50, fit: BoxFit.cover),
                    title: Text(treasure.name),
                    subtitle: Text(treasure.category),
                  );
                },
              );
            }
          },
        ),
      ),
    );
  }
}
