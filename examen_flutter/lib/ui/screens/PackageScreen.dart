import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class PackageScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Packages'),
      ),
      body: ListView(
        padding: EdgeInsets.all(16),
        children: <Widget>[
          PackageCard(
            packageName: 'Paquete 1',
            packageStatus: '100 S/.',
          ),
          PackageCard(
            packageName: 'Paquete 2',
            packageStatus: '500 S/.',
          ),
          PackageCard(
            packageName: 'Paquete 3',
            packageStatus: '250 S/.',
          ),
        ],
      ),
    );
  }
}

class PackageCard extends StatelessWidget {
  final String packageName;
  final String packageStatus;

  PackageCard({
    required this.packageName,
    required this.packageStatus,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      child: ListTile(
        leading: Icon(Icons.card_travel),
        title: Text(packageName),
        subtitle: Text(packageStatus),
        trailing: Icon(Icons.arrow_forward),
        onTap: () {
          // Agrega aquí la funcionalidad para ver detalles del paquete
        },
      ),
    );
  }
}