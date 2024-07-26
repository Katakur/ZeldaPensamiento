import 'dart:convert';
import 'dart:io';

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Treasure'),
      ),
      body: Center(
        child: Text('Treasure ID: ${widget.id}'), 
      ),
    );
  }
}
