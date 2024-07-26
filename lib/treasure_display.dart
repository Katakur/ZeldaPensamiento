import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:zelda_pensamiento/model/treasure.dart';

class TreasureDisplay extends StatefulWidget {
  final int id;

  const TreasureDisplay({Key? key, required this.id}) : super(key: key);

  @override
  _TreasureDisplayState createState() => _TreasureDisplayState();
}

class _TreasureDisplayState extends State<TreasureDisplay> {
  late Future<Treasure> futureTreasure;

  @override
  void initState() {
    super.initState();
    futureTreasure = fetchTreasure();
  }

  Future<Treasure> fetchTreasure() async {
    final response = await http.get(Uri.parse('https://botw-compendium.herokuapp.com/api/v3/compendium/category/treasure'));

    if (response.statusCode == 200) {
      final List<dynamic> jsonDecoded = jsonDecode(response.body)["data"] as List<dynamic>;
      final treasure = jsonDecoded
          .map((dynamic item) => Treasure.fromJson(item as Map<String, dynamic>))
          .firstWhere((treasure) => treasure.id == widget.id);

      return treasure;
    } else {
      throw Exception('Failed to load treasure');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Treasure Details'),
      ),
      body: FutureBuilder<Treasure>(
        future: futureTreasure,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          } else if (!snapshot.hasData) {
            return Center(child: Text("No data available"));
          } else {
            final treasure = snapshot.data!;

            return SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  //info
                  Image.network(
                    treasure.image,
                    fit: BoxFit.cover,
                    height: 200,
                    width: double.infinity,
                  ),
                  SizedBox(height: 16),

                  Text(
                    treasure.name,
                    style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 8),

                  Text(
                    treasure.description,
                    style: TextStyle(fontSize: 25),
                  ),
                  SizedBox(height: 8),

                  if (treasure.commonLocations.isNotEmpty) 
                    Text(
                      'Common Locations:',
                      style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                    ),
                  ...treasure.commonLocations.map(
                    (location) => Text(
                      location,
                      style: TextStyle(fontSize: 20),
                    ),
                  ),
                  SizedBox(height: 8),

                  if (treasure.drops.isNotEmpty) 
                    Text(
                      'Drops:',
                      style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                    ),
                  ...treasure.drops.map(
                    (drop) => Text(
                      drop,
                      style: TextStyle(fontSize: 20),
                    ),
                  ),
                  SizedBox(height: 8),

                  Text(
                    'DLC: ${treasure.dlc ? 'Yes' : 'No'}',
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
