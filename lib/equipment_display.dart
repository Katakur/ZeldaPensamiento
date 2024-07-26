import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:zelda_pensamiento/model/equipment.dart';

class EquipmentDisplay extends StatefulWidget {
  final int id;

  const EquipmentDisplay({Key? key, required this.id}) : super(key: key);

  @override
  _EquipmentDisplayState createState() => _EquipmentDisplayState();
}

class _EquipmentDisplayState extends State<EquipmentDisplay> {
  late Future<Equipment> futureEquipment;

  @override
  void initState() {
    super.initState();
    futureEquipment = fetchEquipment();
  }

  Future<Equipment> fetchEquipment() async {
    final response = await http.get(Uri.parse('https://botw-compendium.herokuapp.com/api/v3/compendium/category/equipment'));

    if (response.statusCode == 200) {
      final List<dynamic> jsonDecoded = jsonDecode(response.body)["data"] as List<dynamic>;
      final equipment = jsonDecoded
          .map((dynamic item) => Equipment.fromJson(item as Map<String, dynamic>))
          .firstWhere((equipment) => equipment.id == widget.id);

      return equipment;
    } else {
      throw Exception('Failed to load equipment');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Equipment Details'),
      ),
      body: FutureBuilder<Equipment>(
        future: futureEquipment,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          } else if (!snapshot.hasData) {
            return Center(child: Text("No data available"));
          } else {
            final equipment = snapshot.data!;

            return SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  //info
                  Image.network(
                    equipment.image,
                    fit: BoxFit.cover,
                    height: 200,
                    width: double.infinity,
                  ),
                  SizedBox(height: 16),

                  Text(
                    equipment.name,
                    style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 8),

                  Text(
                    equipment.description,
                    style: TextStyle(fontSize: 25),
                  ),
                  SizedBox(height: 8),

                  if (equipment.commonLocations.isNotEmpty) 
                    Text(
                      'Common Locations:',
                      style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                    ),
                  ...equipment.commonLocations.map(
                    (location) => Text(
                      location,
                      style: TextStyle(fontSize: 20),
                    ),
                  ),
                  SizedBox(height: 8),

                  Text(
                    'DLC: ${equipment.dlc ? 'Yes' : 'No'}',
                    style: TextStyle(fontSize: 25),
                  ),
                ],
              ),
            );
          }
        },
      ),
    );
  }
}
