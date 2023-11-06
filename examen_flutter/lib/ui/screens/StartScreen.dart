

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class StartScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Dashboard'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Icon(
              Icons.dashboard,
              size: 100,
              color: Colors.blue,
            ),
            Text(
              'Bienvenido!',
              style: TextStyle(fontSize: 24),
            ),
          ],
        ),
      ),
    );
  }
}