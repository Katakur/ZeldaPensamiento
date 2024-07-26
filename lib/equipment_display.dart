import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:zelda_pensamiento/model/equipment.dart';

class EquipmentDisplay extends StatefulWidget {
  final int id;

  const EquipmentDisplay({Key? key, required this.id}) : super(key: key);

  @override
  _EquipmentDisplayState createState() => _EquipmentDisplayState();
}

class _EquipmentDisplayState extends State<EquipmentDisplay> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Equipment'),
      ),
      body: Center(
        child: Text('Equipment ID: ${widget.id}'), 
      ),
    );
  }
}
