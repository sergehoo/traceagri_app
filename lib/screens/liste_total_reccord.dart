import 'package:flutter/material.dart';
import '../services/database_service.dart';

class ListeDonneesSaisiesScreen extends StatefulWidget {
  @override
  _ListeDonneesSaisiesScreenState createState() => _ListeDonneesSaisiesScreenState();
}

class _ListeDonneesSaisiesScreenState extends State<ListeDonneesSaisiesScreen> {
  final DatabaseService dbService = DatabaseService();
  late Future<List<Map<String, dynamic>>> _allData;

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  void _fetchData() {
    setState(() {
      _allData = dbService.getAllMobileData(); // Récupère toutes les données
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Liste des données saisies'),
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _allData,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Erreur : ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('Aucune donnée saisie.'));
          } else {
            final data = snapshot.data!;
            return ListView.builder(
              itemCount: data.length,
              itemBuilder: (context, index) {
                final item = data[index];
                return Card(
                  margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                  child: ListTile(
                    title: Text('${item['nom']} ${item['prenom']}'),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Téléphone : ${item['telephone'] ?? 'N/A'}'),
                        Text('Statut : ${item['is_synced'] == 1 ? 'Synchronisée' : 'Non synchronisée'}'),
                      ],
                    ),
                    trailing: Icon(
                      item['is_synced'] == 1 ? Icons.check_circle : Icons.sync_problem,
                      color: item['is_synced'] == 1 ? Colors.green : Colors.red,
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