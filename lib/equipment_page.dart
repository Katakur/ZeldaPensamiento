import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:zelda_pensamiento/model/equipment.dart';
import 'package:zelda_pensamiento/equipment_display.dart';

class EquipmentPage extends StatefulWidget {
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

  Future<File> _getLocalFile() async {
    final directory = await getApplicationDocumentsDirectory();
    return File('${directory.path}/equipmentlist.json');
  }

  Future<List<Equipment>> fetchEquipment() async {
    final file = await _getLocalFile();
    if (!file.existsSync()) {
      throw Exception('Local file does not exist');
    }

    final jsonString = await file.readAsString();
    final List<dynamic> jsonDecoded = jsonDecode(jsonString)["data"];
    return jsonDecoded.map((dynamic item) => Equipment.fromJson(item as Map<String, dynamic>)).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Equipment Page',
          style: TextStyle(
            fontFamily: 'zelda', 
            fontSize: 20, 
          ),
        ),
        backgroundColor: Color.fromARGB(255, 205, 247, 253), 
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color.fromARGB(255, 146, 197, 130), 
              Color.fromARGB(255, 80, 121, 76)    
            ], 
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: FutureBuilder<List<Equipment>>(
          future: futureEquipment,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text("Error: ${snapshot.error}"));
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return Center(child: Text("No data available"));
            } else {
              final equipmentList = snapshot.data!;
              final favorites = equipmentList.where((item) => item.favorite).toList();
              final others = equipmentList.where((item) => !item.favorite).toList();

              return ListView(
                children: [
                  if (favorites.isNotEmpty) ...[
                    _buildSectionTitle('Favorites'),
                    ...favorites.map((item) => _buildListTile(item)),
                  ] else ...[
                    _buildSectionTitle('Favorites'),
                    ListTile(title: Text("No favorite items")),
                  ],
                  if (others.isNotEmpty) ...[
                    _buildSectionTitle('Others'),
                    ...others.map((item) => _buildListTile(item)),
                  ] else ...[
                    _buildSectionTitle('Others'),
                    ListTile(title: Text("No other items")),
                  ],
                ],
              );
            }
          },
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Container(
      padding: EdgeInsets.all(8.0),
      color: Color.fromARGB(255, 80, 121, 76),
      child: Text(
        title,
        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
      ),
    );
  }

  Widget _buildListTile(Equipment equipment) {
    return Card(
      color: Color.fromARGB(255, 253, 255, 224), 
      child: ListTile(
        leading: Image.network(equipment.image, width: 50, height: 50, fit: BoxFit.cover),
        title: Text(
          equipment.name,
          style: TextStyle(color: Color.fromARGB(255, 118, 118, 118), fontFamily: 'zelda'),
        ),
        subtitle: Text(
          "${equipment.category}",
          style: TextStyle(color: Color.fromARGB(255, 118, 118, 118), fontFamily: 'zelda'),
        ),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => EquipmentDisplay(id: equipment.id),
            ),
          );
        },
      ),
    );
  }
}
