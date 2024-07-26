import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' as http;
import 'package:zelda_pensamiento/model/equipment.dart';

class EquipmentDisplay extends StatefulWidget {
  final int id;

  const EquipmentDisplay({Key? key, required this.id}) : super(key: key);

  @override
  _EquipmentDisplayState createState() => _EquipmentDisplayState();
}

class _EquipmentDisplayState extends State<EquipmentDisplay> {
  late Future<Equipment?> futureEquipment;
  Equipment? _equipment;
  List<dynamic>? _jsonList;

  @override
  void initState() {
    super.initState();
    futureEquipment = fetchEquipment();
  }

  Future<File> _getLocalFile() async {
    final directory = await getApplicationDocumentsDirectory();
    return File('${directory.path}/equipmentlist.json');
  }

  Future<void> _copyAssetToLocal() async {
    final file = await _getLocalFile();
    if (!file.existsSync()) {
      final response = await http.get(Uri.parse('https://botw-compendium.herokuapp.com/api/v3/compendium/category/equipment'));
      if (response.statusCode == 200) {
        await file.writeAsString(response.body);
      } else {
        throw Exception('Failed to load equipment');
      }
    }
  }

  Future<Equipment?> fetchEquipment() async {
    await _copyAssetToLocal();
    final file = await _getLocalFile();
    String jsonString = await file.readAsString();
    _jsonList = json.decode(jsonString)["data"];
    Equipment? equipment;
    for (var json in _jsonList!) {
      if (json['id'] == widget.id) {
        equipment = Equipment.fromJson(json);
        break;
      }
    }
    return equipment;
  }

  Future<void> _guardarCambios() async {
    final file = await _getLocalFile();
    if (_jsonList != null && _equipment != null) {
      for (var json in _jsonList!) {
        if (json['id'] == widget.id) {
          json['favorite'] = _equipment!.favorite;
          break;
        }
      }
      await file.writeAsString(json.encode({"data": _jsonList}));
    }
  }

  void _cambiarSeleccionado() {
    setState(() {
      if (_equipment != null) {
        _equipment!.cambiarSeleccionado();
        _guardarCambios();
      }
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Favorite: ${_equipment?.favorite == true ? 'Yes' : 'No'}'),
        backgroundColor: Colors.green,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Equipment Details',
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
        child: FutureBuilder<Equipment?>(
          future: futureEquipment,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text("Error: ${snapshot.error}", style: TextStyle(color: Colors.white)));
            } else if (!snapshot.hasData || snapshot.data == null) {
              return Center(child: Text("No data available", style: TextStyle(color: Colors.white)));
            } else {
              _equipment = snapshot.data!;
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
                          _equipment!.image,
                          fit: BoxFit.cover,
                          height: 200,
                          width: double.infinity,
                        ),
                      ),
                    ),
                    SizedBox(height: 16),
                    Text(
                      _equipment!.name,
                      style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'zelda',
                        color: Color.fromARGB(255, 253, 255, 224),
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      _equipment!.description,
                      style: TextStyle(
                        fontSize: 20,
                        fontFamily: 'zelda',
                        color: Colors.white70,
                      ),
                    ),
                    SizedBox(height: 8),
                    if (_equipment!.commonLocations.isNotEmpty)
                      Text(
                        'Common Locations:',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'zelda',
                          color: Color.fromARGB(255, 253, 255, 224),
                        ),
                      ),
                    ..._equipment!.commonLocations.map(
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
                    Text(
                      'DLC: ${_equipment!.dlc ? 'Yes' : 'No'}',
                      style: TextStyle(
                        fontSize: 22,
                        fontFamily: 'zelda',
                        color: Color.fromARGB(255, 253, 255, 224),
                      ),
                    ),
                    SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        IconButton(
                          icon: Icon(
                            _equipment!.favorite ? Icons.star : Icons.star_border,
                            color: Color.fromARGB(255, 146, 197, 130),
                          ),
                          onPressed: _cambiarSeleccionado,
                        ),
                        /*Text(
                          'Favorite: ${_equipment!.favorite ? 'Yes' : 'No'}',
                          style: TextStyle(
                            fontSize: 22,
                            fontFamily: 'zelda',
                            color: Color.fromARGB(255, 253, 255, 224),
                          ),
                        ),*/
                      ],
                    ),
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
