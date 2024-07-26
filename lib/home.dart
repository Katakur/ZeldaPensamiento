import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:zelda_pensamiento/model/monster.dart';
import 'package:zelda_pensamiento/model/equipment.dart';
import 'package:zelda_pensamiento/model/treasure.dart';
import 'package:zelda_pensamiento/treasure_display.dart';
import 'package:zelda_pensamiento/monster_display.dart';
import 'package:zelda_pensamiento/equipment_display.dart';
import 'package:zelda_pensamiento/equipment_page.dart';
import 'package:zelda_pensamiento/monster_page.dart';
import 'package:zelda_pensamiento/treasure_page.dart';
import 'package:zelda_pensamiento/about_page.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late Future<List<Treasure>> _treasures;
  late Future<List<Monster>> _monsters;
  late Future<List<Equipment>> _equipments;

  @override
  void initState() {
    super.initState();
    _treasures = _loadFavorites('treasurelist.json', (json) => Treasure.fromJson(json));
    _monsters = _loadFavorites('monsterlist.json', (json) => Monster.fromJson(json));
    _equipments = _loadFavorites('equipmentlist.json', (json) => Equipment.fromJson(json));
  }

  Future<File> _getLocalFile(String filename) async {
    final directory = await getApplicationDocumentsDirectory();
    return File('${directory.path}/$filename');
  }

  Future<List<T>> _loadFavorites<T>(String filename, T Function(Map<String, dynamic>) fromJson) async {
    try {
      final file = await _getLocalFile(filename);
      if (!file.existsSync()) {
        throw Exception('File not found');
      }
      final jsonString = await file.readAsString();
      final List<dynamic> jsonList = json.decode(jsonString)["data"];
      return jsonList
          .map((item) => fromJson(item as Map<String, dynamic>))
          .where((item) => (item as dynamic).favorite) 
          .toList();
    } catch (e) {
      print(e);
      return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Home Page',
          style: TextStyle(
            fontFamily: 'zelda',
            fontSize: 20,
          ),
        ),
        backgroundColor: Color.fromARGB(255, 205, 247, 253),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Color.fromARGB(255, 146, 197, 130),
                    Color.fromARGB(255, 80, 121, 76)
                  ],
                ),
              ),
              child: Text(
                'Menu',
                style: TextStyle(
                  color: Color.fromARGB(255, 253, 255, 224),
                  fontSize: 24,
                  fontFamily: 'zelda',
                ),
              ),
            ),
            ListTile(
              leading: Icon(Icons.star, color: Color.fromARGB(255, 118, 118, 118)),
              title: const Text('Treasure', style: TextStyle(fontFamily: 'zelda')),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => TreasurePage()),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.adb, color: Color.fromARGB(255, 118, 118, 118)),
              title: const Text('Monsters', style: TextStyle(fontFamily: 'zelda')),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => MonsterPage()),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.shield, color: Color.fromARGB(255, 118, 118, 118)),
              title: const Text('Equipment', style: TextStyle(fontFamily: 'zelda')),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => EquipmentPage()),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.add_home, color: Color.fromARGB(255, 118, 118, 118)),
              title: const Text('About', style: TextStyle(fontFamily: 'zelda')),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => AboutPage()),
                );
              },
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          Container(
            color: Color.fromARGB(255, 80, 121, 76),
            padding: EdgeInsets.all(16.0),
            child: Text(
              'The legends of Zelda: Breath of the Wild is a videogame',
              style: TextStyle(
                fontSize: 16,
                color: Colors.white,
                fontFamily: 'zelda',
              ),
            ),
          ),
          Expanded(
            child: Container(
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
              child: ListView(
                padding: EdgeInsets.all(8.0),
                children: [
                  Text('tesoros favoritos'),
                  _buildFavoritesList(
                    futureFavorites: _treasures,
                    onTap: (id) => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => TreasureDisplay(id: id)),
                    ),
                  ),
                  Text('mounstruos favoritos'),
                  _buildFavoritesList(
                    futureFavorites: _monsters,
                    onTap: (id) => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => MonsterDisplay(id: id)),
                    ),
                  ),
                  Text('equipamiento favoritos'),
                  _buildFavoritesList(
                    futureFavorites: _equipments,
                    onTap: (id) => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => EquipmentDisplay(id: id)),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFavoritesList<T>({
    required Future<List<T>> futureFavorites,
    required void Function(int id) onTap,
  }) {
    return FutureBuilder<List<T>>(
      future: futureFavorites,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text("Error: ${snapshot.error}"));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Center(child: Text("No hay ningún ítem favorito"));
        } else {
          final items = snapshot.data!;
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: items.map<Widget>((item) {
              final id = (item as dynamic).id; 
              final name = (item as dynamic).name; 
              return ListTile(
                leading: Icon(Icons.star, color: Color.fromARGB(255, 253, 255, 224)),
                title: Text(name, style: TextStyle(fontFamily: 'zelda')),
                onTap: () => onTap(id),
              );
            }).toList(),
          );
        }
      },
    );
  }
}
