import 'package:flutter/material.dart';

import '../services/database_service.dart';

class SynchroniseesScreen extends StatefulWidget {
  @override
  _SynchroniseesScreenState createState() => _SynchroniseesScreenState();
}

class _SynchroniseesScreenState extends State<SynchroniseesScreen> {
  final DatabaseService dbService = DatabaseService();
  late Future<List<Map<String, dynamic>>> _syncedMobileData;

  @override
  void initState() {
    super.initState();
    _loadSyncedMobileData();
  }

  void _loadSyncedMobileData() {
    setState(() {
      _syncedMobileData = dbService.getSyncedMobileData();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Données Synchronisées'),
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _syncedMobileData,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Erreur : ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('Aucune donnée synchronisée.'));
          } else {
            final data = snapshot.data!;
            return ListView.builder(
              itemCount: data.length,
              itemBuilder: (context, index) {
                final item = data[index];
                return Card(
                  margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                  child: ListTile(
                    title: Text(item['nom'] ?? 'Nom inconnu'),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Prénom : ${item['prenom'] ?? 'Prénom inconnu'}'),
                        Text('Téléphone : ${item['telephone'] ?? 'Non renseigné'}'),
                        Text('Date de naissance : ${item['date_naissance'] ?? 'Non renseignée'}'),
                      ],
                    ),
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}