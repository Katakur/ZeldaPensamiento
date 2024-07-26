import 'package:flutter/material.dart';
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
        title: Text(
          'Home Page',
          style: TextStyle(
            fontFamily: 'zelda', // Usa la fuente personalizada
            fontSize: 20, // Ajusta el tamaño de la fuente según lo necesites
          ),
        ),
        backgroundColor: Color.fromARGB(255, 205, 247, 253), // Cambia el color del AppBar
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Color.fromARGB(255, 146, 197, 130), 
                    Color.fromARGB(255, 80, 121, 76)
                  ], // Degradado para el DrawerHeader
                ),
              ),
              child: Text(
                'Menu',
                style: TextStyle(
                  color: Color.fromARGB(255, 253, 255, 224),
                  fontSize: 24,
                  fontFamily: 'zelda',
                ),
              ),
            ),
            ListTile(
              leading: Icon(Icons.star, color: Color.fromARGB(255, 118, 118, 118)),
              title: const Text('Treasure', style: TextStyle(fontFamily: 'zelda')), 
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => TreasurePage())
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.adb, color: Color.fromARGB(255, 118, 118, 118)),
              title: const Text('Monsters', style: TextStyle(fontFamily: 'zelda')),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => MonsterPage())
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.shield, color: Color.fromARGB(255, 118, 118, 118)),
              title: const Text('Equipment', style: TextStyle(fontFamily: 'zelda')), 
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
      body: Column(
        children: [
          // Espacio para la descripción del juego
          Container(
            color: Color.fromARGB(255, 80, 121, 76), // Asegúrate de que el fondo sea visible
            padding: EdgeInsets.all(16.0),
            child: Text(
              'Aquí puedes poner una descripción del juego. Explica la historia, el objetivo, y cualquier detalle relevante que quieras compartir con el usuario.',
              style: TextStyle(
                fontSize: 16,
                color: Colors.white,
                fontFamily: 'zelda', 
              ),
            ),
          ),
          // Espacio para la lista de acceso rápido a favoritos
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Color.fromARGB(255, 146, 197, 130),
                    Color.fromARGB(255, 80, 121, 76)
                  ], // Degradado para el fondo de la lista
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: ListView(
                padding: EdgeInsets.all(8.0),
                children: [
                  ListTile(
                    leading: Icon(Icons.star, color: Color.fromARGB(255, 253, 255, 224)),
                    title: Text('Favorite Item 1', style: TextStyle(fontFamily: 'zelda')),
                    onTap: () {
                      // Acción para el primer ítem favorito
                    },
                  ),
                  ListTile(
                    leading: Icon(Icons.star, color: Color.fromARGB(255, 253, 255, 224)),
                    title: Text('Favorite Item 2', style: TextStyle(fontFamily: 'zelda')),
                    onTap: () {
                      // Acción para el segundo ítem favorito
                    },
                  ),
                  // Agrega más ListTile según sea necesario
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
