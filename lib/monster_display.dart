import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:zelda_pensamiento/model/monster.dart';

class MonsterDisplay extends StatefulWidget {
  final int id;

  const MonsterDisplay({Key? key, required this.id}) : super(key: key);

  @override
  _MonsterDisplayState createState() => _MonsterDisplayState();
}

class _MonsterDisplayState extends State<MonsterDisplay> {
  late Future<Monster> futureMonster;

  @override
  void initState() {
    super.initState();
    futureMonster = fetchMonster();
  }

  Future<Monster> fetchMonster() async {
    final response = await http.get(Uri.parse('https://botw-compendium.herokuapp.com/api/v3/compendium/category/monsters'));

    if (response.statusCode == 200) {
      final List<dynamic> jsonDecoded = jsonDecode(response.body)["data"] as List<dynamic>;
      final monster = jsonDecoded
          .map((dynamic item) => Monster.fromJson(item as Map<String, dynamic>))
          .firstWhere((monster) => monster.id == widget.id);

      return monster;
    } else {
      throw Exception('Failed to load monster');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Monster Details'),
      ),
      body: FutureBuilder<Monster>(
        future: futureMonster,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          } else if (!snapshot.hasData) {
            return Center(child: Text("No data available"));
          } else {
            final monster = snapshot.data!;

            return SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  //info
                  Image.network(
                    monster.image,
                    fit: BoxFit.cover,
                    height: 200,
                    width: double.infinity,
                  ),
                  SizedBox(height: 16),

                  Text(
                    monster.name,
                    style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 8),

                  Text(
                    monster.description,
                    style: TextStyle(fontSize: 25),
                  ),
                  SizedBox(height: 8),

                  if (monster.commonLocations.isNotEmpty)
                    Text(
                      'Common Locations:',
                      style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                    ),
                  ...monster.commonLocations.map(
                    (location) => Text(
                      location,
                      style: TextStyle(fontSize: 20),
                    ),
                  ),
                  SizedBox(height: 8),

                  if (monster.drops != null && monster.drops!.isNotEmpty)
                    Text(
                      'Drops:',
                      style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                    ),
                  ...?monster.drops?.map(
                    (drop) => Text(
                      drop,
                      style: TextStyle(fontSize: 20),
                    ),
                  ),
                  SizedBox(height: 8),

                  Text(
                    'DLC: ${monster.dlc ? 'Yes' : 'No'}',
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
