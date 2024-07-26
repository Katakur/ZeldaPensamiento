import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'package:zelda_pensamiento/treasure_page.dart';
import 'package:zelda_pensamiento/monster_page.dart';
import 'package:zelda_pensamiento/equipment_page.dart';


class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home Page'),
      ),

      drawer: Drawer(
          child: ListView(
            padding: EdgeInsets.zero,
            children: <Widget>[
              const DrawerHeader(
                decoration: BoxDecoration(
                  color: Color.fromARGB(1, 1, 1, 1),
                ),
                child: Text('Menú'),
              ),

              ListTile(
                title: const Text('Treasure'),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => TreasurePage())
                  );
                },
              ),

              ListTile(
                title: const Text('Monsters'),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => MonsterPage())
                  );
                },
              ),

              ListTile(
                title: const Text('Equipment'),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => EquipmentPage())
                  );
                },
              ),

            
            ],
          ),
        ),

    );
  }
}
