import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart'; 
import 'package:http/http.dart' as http;
import 'package:zelda_pensamiento/model/monster.dart';
import 'package:zelda_pensamiento/monster_display.dart';

class MonsterPage extends StatefulWidget {
  @override
  _MonsterPageState createState() => _MonsterPageState();
}

class _MonsterPageState extends State<MonsterPage> {
  late Future<List<Monster>> futureMonster;

  @override
  void initState() {
    super.initState();
    futureMonster = fetchMonsters();
  }

  Future<File> _getLocalFile() async {
    final directory = await getApplicationDocumentsDirectory();
    return File('${directory.path}/monsterlist.json');
  }

  Future<void> _copyAssetToLocal() async {
    final file = await _getLocalFile();
    if (!file.existsSync()) {
      final response = await http.get(Uri.parse('https://botw-compendium.herokuapp.com/api/v3/compendium/category/monsters'));
      if (response.statusCode == 200) {
        await file.writeAsString(response.body);
      } else {
        throw Exception('Failed to load monsters');
      }
    }
  }

  Future<List<Monster>> fetchMonsters() async {
    await _copyAssetToLocal();
    final file = await _getLocalFile();
    final String jsonString = await file.readAsString();
    final List<dynamic> jsonDecoded = jsonDecode(jsonString)["data"] as List<dynamic>;

    final List<Monster> monsters = jsonDecoded.map((dynamic item) => Monster.fromJson(item as Map<String, dynamic>)).toList();
    return monsters;
  }

  Future<void> _refreshData() async {
    setState(() {
      futureMonster = fetchMonsters(); // Refresh the Future
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Monster Page',
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
        child: FutureBuilder<List<Monster>>(
          future: futureMonster,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text("Error: ${snapshot.error}"));
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return Center(child: Text("No data available"));
            } else {
              final monsters = snapshot.data!;
              final favoriteMonsters = monsters.where((monster) => monster.favorite).toList();
              final otherMonsters = monsters.where((monster) => !monster.favorite).toList();

              return ListView(
                children: [
                  if (favoriteMonsters.isNotEmpty) ...[
                    _buildSectionTitle('Favorites'),
                    ...favoriteMonsters.map((monster) => _buildListTile(monster)),
                  ] else ...[
                    Center(child: Text("No favorite monsters")),
                  ],
                  if (otherMonsters.isNotEmpty) ...[
                    _buildSectionTitle('Others'),
                    ...otherMonsters.map((monster) => _buildListTile(monster)),
                  ] else ...[
                    Center(child: Text("No other monsters")),
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

  Widget _buildListTile(Monster monster) {
    return Card(
      color: Color.fromARGB(255, 253, 255, 224), 
      child: ListTile(
        leading: Image.network(monster.image, width: 50, height: 50, fit: BoxFit.cover),
        title: Text(monster.name, style: TextStyle(color: Color.fromARGB(255, 118, 118, 118), fontFamily: 'zelda')), 
        subtitle: Text(
          "${monster.category}",
          style: TextStyle(color: Color.fromARGB(255, 118, 118, 118), fontFamily: 'zelda'), 
        ),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => MonsterDisplay(id: monster.id),
            ),
          ).then((_) => _refreshData()); // Refresh data after returning from MonsterDisplay
        },
      ),
    );
  }
}
