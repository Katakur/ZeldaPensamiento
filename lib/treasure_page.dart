import 'dart:convert';
import 'dart:io'; 
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart'; 
import 'package:http/http.dart' as http; 
import 'package:zelda_pensamiento/model/treasure.dart';
import 'package:zelda_pensamiento/treasure_display.dart';

class TreasurePage extends StatefulWidget {
  @override
  _TreasurePageState createState() => _TreasurePageState();
}

class _TreasurePageState extends State<TreasurePage> {
  late Future<List<Treasure>> futureTreasure;

  @override
  void initState() {
    super.initState();
    futureTreasure = fetchTreasures();
  }

  Future<File> _getLocalFile() async {
    final directory = await getApplicationDocumentsDirectory();
    return File('${directory.path}/treasurelist.json');
  }

  Future<void> _copyAssetToLocal() async {
    final file = await _getLocalFile();
    if (!file.existsSync()) {
      final response = await http.get(Uri.parse('https://botw-compendium.herokuapp.com/api/v3/compendium/category/treasure'));
      if (response.statusCode == 200) {
        await file.writeAsString(response.body);
      } else {
        throw Exception('Failed to load treasures');
      }
    }
  }

  Future<List<Treasure>> fetchTreasures() async {
    await _copyAssetToLocal();
    final file = await _getLocalFile();
    final String jsonString = await file.readAsString();
    final List<dynamic> jsonDecoded = jsonDecode(jsonString)["data"] as List<dynamic>;

    final List<Treasure> treasures = jsonDecoded.map((dynamic item) => Treasure.fromJson(item as Map<String, dynamic>)).toList();
    return treasures;
  }

  Future<void> _refreshData() async {
    setState(() {
      futureTreasure = fetchTreasures(); // Refresh the Future
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Treasure Page',
          style: TextStyle(
            fontFamily: 'zelda', 
            fontSize: 20, 
          ),
        ),
        backgroundColor: Color.fromARGB(255, 205, 247, 253),
        actions: [
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: _refreshData,
          ),
        ],
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
        child: FutureBuilder<List<Treasure>>(
          future: futureTreasure,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text("Error: ${snapshot.error}"));
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return Center(child: Text("No data available"));
            } else {
              final treasures = snapshot.data!;
              final favoriteTreasures = treasures.where((treasure) => treasure.favorite).toList();
              final otherTreasures = treasures.where((treasure) => !treasure.favorite).toList();

              return ListView(
                children: [
                  if (favoriteTreasures.isNotEmpty) ...[
                    _buildSectionTitle('Favorites'),
                    ...favoriteTreasures.map((treasure) => _buildListTile(treasure)),
                  ] else ...[
                    Center(child: Text("No favorite treasures")),
                  ],
                  if (otherTreasures.isNotEmpty) ...[
                    _buildSectionTitle('Others'),
                    ...otherTreasures.map((treasure) => _buildListTile(treasure)),
                  ] else ...[
                    Center(child: Text("No other treasures")),
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
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.bold,
          fontFamily: 'zelda',
        ),
      ),
    );
  }

  Widget _buildListTile(Treasure treasure) {
    return Card(
      color: Color.fromARGB(255, 253, 255, 224), 
      child: ListTile(
        leading: Image.network(treasure.image, width: 50, height: 50, fit: BoxFit.cover),
        title: Text(
          treasure.name,
          style: TextStyle(color: Color.fromARGB(255, 118, 118, 118), fontFamily: 'zelda'), 
        ),
        subtitle: Text(
          "${treasure.category}",
          style: TextStyle(color: Color.fromARGB(255, 118, 118, 118), fontFamily: 'zelda'), 
        ),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => TreasureDisplay(id: treasure.id),
            ),
          ).then((_) => _refreshData()); // Refresh data after returning from TreasureDisplay
        },
      ),
    );
  }
}
