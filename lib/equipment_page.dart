import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'model/equipment.dart';

class EquipmentPage extends StatefulWidget {
  const EquipmentPage({super.key});

  @override
  _EquipmentPageState createState() => _EquipmentPageState();
}

class _EquipmentPageState extends State<EquipmentPage> {
  late Future<List<Equipment>> futureEquipment;

  @override
  void initState() {
    super.initState();
    futureEquipment = fetchEquipment();
  }

  Future<List<Equipment>> fetchEquipment() async {
    final response = await http.get(Uri.parse('https://botw-compendium.herokuapp.com/api/v3/compendium/category/equipment'));

    if (response.statusCode == 200) {
      final List<dynamic> jsonDecoded = jsonDecode(response.body)["data"] as List<dynamic>;
      return jsonDecoded.map((dynamic item) => Equipment.fromJson(item as Map<String, dynamic>)).toList();
    } else {
      throw Exception('Failed to load Equipment');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Equipment Page'),
      ),
      body: Center(
        child: FutureBuilder<List<Equipment>>(
          future: futureEquipment,
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
                  final equipment = snapshot.data![index];
                  return ListTile(
                    leading: Image.network(equipment.image, width: 50, height: 50, fit: BoxFit.cover),
                    title: Text(equipment.name),
                    subtitle: Text(equipment.category),
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
