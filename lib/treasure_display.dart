import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' as http;
import 'package:zelda_pensamiento/model/treasure.dart';

class TreasureDisplay extends StatefulWidget {
  final int id;

  const TreasureDisplay({Key? key, required this.id}) : super(key: key);

  @override
  _TreasureDisplayState createState() => _TreasureDisplayState();
}

class _TreasureDisplayState extends State<TreasureDisplay> {
  late Future<Treasure?> futureTreasure;
  Treasure? _treasure;
  List<dynamic>? _jsonList;

  @override
  void initState() {
    super.initState();
    futureTreasure = fetchTreasure();
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
        throw Exception('Failed to load treasure');
      }
    }
  }

  Future<Treasure?> fetchTreasure() async {
    await _copyAssetToLocal();
    final file = await _getLocalFile();
    String jsonString = await file.readAsString();
    _jsonList = json.decode(jsonString)["data"];
    Treasure? treasure;
    for (var json in _jsonList!) {
      if (json['id'] == widget.id) {
        treasure = Treasure.fromJson(json);
        break;
      }
    }
    return treasure;
  }

  Future<void> _guardarCambios() async {
    final file = await _getLocalFile();
    if (_jsonList != null && _treasure != null) {
      for (var json in _jsonList!) {
        if (json['id'] == widget.id) {
          json['favorite'] = _treasure!.favorite;
          break;
        }
      }
      await file.writeAsString(json.encode({"data": _jsonList}));
    }
  }

  void _cambiarSeleccionado() {
    setState(() {
      if (_treasure != null) {
        _treasure!.cambiarSeleccionado();
        _guardarCambios();
      }
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Favorite: ${_treasure?.favorite == true ? 'Yes' : 'No'}')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Treasure Details'),
      ),

      body: FutureBuilder<Treasure?>(
        future: futureTreasure,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          } else if (!snapshot.hasData || snapshot.data == null) {
            return Center(child: Text("No data available"));
          } else {
            _treasure = snapshot.data!;
            return SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  
                  Image.network(
                    _treasure!.image,
                    fit: BoxFit.cover,
                    height: 200,
                    width: double.infinity,
                  ),
                  SizedBox(height: 16),
                  Text(
                    _treasure!.name,
                    style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 8),
                  Text(
                    _treasure!.description,
                    style: TextStyle(fontSize: 25),
                  ),
                  SizedBox(height: 8),
                  if (_treasure!.commonLocations.isNotEmpty)
                    Text(
                      'Common Locations:',
                      style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                    ),
                  ..._treasure!.commonLocations.map(
                    (location) => Text(
                      location,
                      style: TextStyle(fontSize: 20),
                    ),
                  ),
                  SizedBox(height: 8),
                  if (_treasure!.drops.isNotEmpty)
                    Text(
                      'Drops:',
                      style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                    ),
                  ..._treasure!.drops.map(
                    (drop) => Text(
                      drop,
                      style: TextStyle(fontSize: 20),
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'DLC: ${_treasure!.dlc ? 'Yes' : 'No'}',
                    style: TextStyle(fontSize: 25),
                  ),
                  SizedBox(height: 8),
                  ElevatedButton(
                    onPressed: _cambiarSeleccionado,
                    child: Text('Toggle Favorite'),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Favorite: ${_treasure!.favorite ? 'Yes' : 'No'}',
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
