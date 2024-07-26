import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' as http;
import 'package:zelda_pensamiento/model/monster.dart';

class MonsterDisplay extends StatefulWidget {
  final int id;

  const MonsterDisplay({Key? key, required this.id}) : super(key: key);

  @override
  _MonsterDisplayState createState() => _MonsterDisplayState();
}

class _MonsterDisplayState extends State<MonsterDisplay> {
  late Future<Monster?> futureMonster;
  Monster? _monster;
  List<dynamic>? _jsonList;

  @override
  void initState() {
    super.initState();
    futureMonster = fetchMonster();
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

  Future<Monster?> fetchMonster() async {
    await _copyAssetToLocal();
    final file = await _getLocalFile();
    String jsonString = await file.readAsString();
    _jsonList = json.decode(jsonString)["data"];
    Monster? monster;
    for (var json in _jsonList!) {
      if (json['id'] == widget.id) {
        monster = Monster.fromJson(json);
        break;
      }
    }
    return monster;
  }

  Future<void> _guardarCambios() async {
    final file = await _getLocalFile();
    if (_jsonList != null && _monster != null) {
      for (var json in _jsonList!) {
        if (json['id'] == widget.id) {
          json['favorite'] = _monster!.favorite;
          break;
        }
      }
      await file.writeAsString(json.encode({"data": _jsonList}));
    }
  }

  void _cambiarSeleccionado() {
    setState(() {
      if (_monster != null) {
        _monster!.cambiarSeleccionado();
        _guardarCambios();
      }
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Favorite: ${_monster?.favorite == true ? 'Yes' : 'No'}')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Monster Details'),
      ),
      
      body: FutureBuilder<Monster?>(
        future: futureMonster,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          } else if (!snapshot.hasData || snapshot.data == null) {
            return Center(child: Text("No data available"));
          } else {
            _monster = snapshot.data!;
            return SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  Image.network(
                    _monster!.image,
                    fit: BoxFit.cover,
                    height: 200,
                    width: double.infinity,
                  ),
                  SizedBox(height: 16),
                  Text(
                    _monster!.name,
                    style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 8),
                  Text(
                    _monster!.description,
                    style: TextStyle(fontSize: 25),
                  ),
                  SizedBox(height: 8),
                  if (_monster!.commonLocations.isNotEmpty)
                    Text(
                      'Common Locations:',
                      style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                    ),
                  ..._monster!.commonLocations.map(
                    (location) => Text(
                      location,
                      style: TextStyle(fontSize: 20),
                    ),
                  ),
                  SizedBox(height: 8),
                  if (_monster!.drops != null && _monster!.drops!.isNotEmpty)
                    Text(
                      'Drops:',
                      style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                    ),
                  ...? _monster!.drops?.map(
                    (drop) => Text(
                      drop,
                      style: TextStyle(fontSize: 20),
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'DLC: ${_monster!.dlc ? 'Yes' : 'No'}',
                    style: TextStyle(fontSize: 25),
                  ),
                  SizedBox(height: 8),
                  ElevatedButton(
                    onPressed: _cambiarSeleccionado,
                    child: Text('Toggle Favorite'),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Favorite: ${_monster!.favorite ? 'Yes' : 'No'}',
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
