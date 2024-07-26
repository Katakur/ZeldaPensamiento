import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'package:zelda_pensamiento/model/monster.dart';

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
      throw Exception('Failed to load Mounstruos');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      appBar: AppBar(
        title: Text('Monster Page'),
      ),

      body: Center(
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
                  return ListTile(
                    leading: Image.network(monster.image, width: 50, height: 50, fit: BoxFit.cover),
                    title: Text(monster.name),
                    subtitle: Text("${monster.category}"),
                  );
                },
              );
            }
          },
        ),
      ),
    );
  }
}
