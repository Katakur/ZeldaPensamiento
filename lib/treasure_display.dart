import 'dart:convert';
import 'dart:io';

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
