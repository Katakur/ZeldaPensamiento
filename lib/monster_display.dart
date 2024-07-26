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
      SnackBar(
        content: Text('Favorite: ${_monster?.favorite == true ? 'Yes' : 'No'}'),
        backgroundColor: Colors.green,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Monster Details',
          style: TextStyle(
            fontFamily: 'zelda',
            fontSize: 20,
            color: Colors.white,
          ),
        ),
        backgroundColor: Color.fromARGB(255, 146, 197, 130),
      ),
      body: Container(
        decoration: BoxDecoration(
          color: Color.fromARGB(255, 58, 56, 56), // Fondo oscuro
        ),
        child: FutureBuilder<Monster?>(
          future: futureMonster,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text("Error: ${snapshot.error}", style: TextStyle(color: Colors.white)));
            } else if (!snapshot.hasData || snapshot.data == null) {
              return Center(child: Text("No data available", style: TextStyle(color: Colors.white)));
            } else {
              _monster = snapshot.data!;
              return SingleChildScrollView(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black26,
                            blurRadius: 8,
                            offset: Offset(0, 4),
                          ),
                        ],
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.network(
                          _monster!.image,
                          fit: BoxFit.cover,
                          height: 200,
                          width: double.infinity,
                        ),
                      ),
                    ),
                    SizedBox(height: 16),
                    Text(
                      _monster!.name,
                      style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'zelda',
                        color: Color.fromARGB(255, 253, 255, 224),
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      _monster!.description,
                      style: TextStyle(
                        fontSize: 20,
                        fontFamily: 'zelda',
                        color: Colors.white70,
                      ),
                    ),
                    SizedBox(height: 8),
                    if (_monster!.commonLocations.isNotEmpty)
                      Text(
                        'Common Locations:',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'zelda',
                          color: Color.fromARGB(255, 253, 255, 224),
                        ),
                      ),
                    ..._monster!.commonLocations.map(
                      (location) => Text(
                        location,
                        style: TextStyle(
                          fontSize: 18,
                          fontFamily: 'zelda',
                          color: Colors.white70,
                        ),
                      ),
                    ),
                    SizedBox(height: 8),
                    if (_monster!.drops != null && _monster!.drops!.isNotEmpty)
                      Text(
                        'Drops:',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'zelda',
                          color: Color.fromARGB(255, 253, 255, 224),
                        ),
                      ),
                    ...? _monster!.drops?.map(
                      (drop) => Text(
                        drop,
                        style: TextStyle(
                          fontSize: 18,
                          fontFamily: 'zelda',
                          color: Colors.white70,
                        ),
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'DLC: ${_monster!.dlc ? 'Yes' : 'No'}',
                      style: TextStyle(
                        fontSize: 22,
                        fontFamily: 'zelda',
                        color: Color.fromARGB(255, 253, 255, 224),
                      ),
                    ),
                    SizedBox(height: 16),
                    IconButton(
                      icon: Icon(
                        _monster!.favorite ? Icons.favorite : Icons.favorite_border,
                        color: Color.fromARGB(255, 146, 197, 130),
                        size: 32,
                      ),
                      onPressed: _cambiarSeleccionado,
                    ),
                    /*SizedBox(height: 16),
                    Text(
                      'Favorite: ${_monster!.favorite ? 'Yes' : 'No'}',
                      style: TextStyle(
                        fontSize: 22,
                        fontFamily: 'zelda',
                        color: Color.fromARGB(255, 253, 255, 224),
                      ),
                    ),*/
                  ],
                ),
              );
            }
          },
        ),
      ),
    );
  }
}
