import 'package:flutter/material.dart';

class EnAttenteScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Données en Attente'),
      ),
      body: Center(
        child: Text(
          'Liste des données en attente de synchronisation',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}