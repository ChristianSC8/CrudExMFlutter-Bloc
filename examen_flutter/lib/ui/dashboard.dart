import 'package:examen_flutter/ui/screens/PackageScreen.dart';
import 'package:examen_flutter/ui/screens/UserScreen.dart';
import 'package:examen_flutter/ui/screens/StartScreen.dart';
import 'package:flutter/material.dart';

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    StartScreen(),
    PackageScreen(),
    UserScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: Text(
          'UPeU',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(
              Icons.search,
              color: Colors.white,
            ),
            onPressed: () {

            },
          ),
          IconButton(
            icon: Icon(
              Icons.settings,
              color: Colors.white,
            ),
            onPressed: () {
              // Agrega aquí la funcionalidad de ajustes
            },
          ),
        ],
        centerTitle: true,
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: _pages[_selectedIndex],

      drawer: Drawer(
        child: Container(
          color: Colors.blue,
          child: ListView(
            children: <Widget>[
              UserAccountsDrawerHeader(
                accountName: Text('Nombre del Usuario'),
                accountEmail: Text('correo@example.com'),
                currentAccountPicture: CircleAvatar(
                  child: Icon(
                    Icons.person,
                    color: Colors.white,
                    size: 48.0,
                  ),
                  backgroundColor: Colors.blue,
                ),
                decoration: BoxDecoration(
                  color: Colors.blue,
                ),
              ),
              ListTile(
                leading: Icon(Icons.dashboard,
                    color: Colors.white),
                title: Text('dashboard',
                    style: TextStyle(
                    fontSize: 15,
                    color: Colors.white,
                )),
                onTap: () {
                  setState(() {
                    _selectedIndex = 0;
                    Navigator.pop(context);
                  });
                },
              ),
              ListTile(
                leading: Icon(Icons.agriculture_rounded,
                  color: Colors.white),
                title: Text('Paquetes',
                    style: TextStyle(
                    fontSize: 15,
                    color: Colors.white,
                )),
                onTap: () {
                  setState(() {
                    _selectedIndex = 1;
                    Navigator.pop(context);
                  });
                },
              ),
              ListTile(
                leading: Icon(Icons.supervised_user_circle,
                    color: Colors.white),
                title: Text('Usuarios',
                    style: TextStyle(
                    fontSize: 15,
                    color: Colors.white,
                )),
                onTap: () {
                  setState(() {
                    _selectedIndex = 2;
                    Navigator.pop(context);
                  });
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

