import 'dart:convert';
import 'package:flutter/material.dart';
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
    futureMonster = fetchMonster();
  }

  Future<List<Monster>> fetchMonster() async {
    final response = await http.get(Uri.parse('https://botw-compendium.herokuapp.com/api/v3/compendium/category/monsters'));

    if (response.statusCode == 200) {
      final List<dynamic> jsonDecoded = jsonDecode(response.body)["data"] as List<dynamic>;
      return jsonDecoded.map((dynamic item) => Monster.fromJson(item as Map<String, dynamic>)).toList();
    } else {
      throw Exception('Failed to load monsters');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Monster Page',
        style: TextStyle(
            fontFamily: 'zelda', // Usa la fuente personalizada
            fontSize: 20, // Ajusta el tamaño de la fuente según lo necesites
          ),),
        backgroundColor: Color.fromARGB(255, 205, 247, 253), // Cambia el color del AppBar
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color.fromARGB(255, 146, 197, 130), // Color ARGB
              Color.fromARGB(255, 80, 121, 76)    // Color ARGB
            ], // Degradado para el fondo
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Center(
          child: FutureBuilder<List<Monster>>(
            future: futureMonster,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return CircularProgressIndicator();
              } else if (snapshot.hasError) {
                return Text("Error: ${snapshot.error}");
              } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return Text("No data available");
              } else {
                return ListView.builder(
                  itemCount: snapshot.data!.length,
                  itemBuilder: (context, index) {
                    final monster = snapshot.data![index];
                    return Card(
                      color: Color.fromARGB(255, 253, 255, 224), // Color del fondo del Card
                      child: ListTile(
                        leading: Image.network(monster.image, width: 50, height: 50, fit: BoxFit.cover),
                        title: Text(monster.name, style: TextStyle(color: Color.fromARGB(255, 118, 118, 118), fontFamily: 'zelda')), // Color del texto
                        subtitle: Text(
                          "${monster.category}",
                          style: TextStyle(color: Color.fromARGB(255, 118, 118, 118), fontFamily: 'zelda'), // Color del subtítulo
                        ),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => MonsterDisplay(id: monster.id),
                            ),
                          );
                        },
                      ),
                    );
                  },
                );
              }
            },
          ),
        ),
      ),
    );
  }
}
