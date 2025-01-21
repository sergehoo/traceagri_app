import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/database_service.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'edit_enquete_data.dart';



class NonSynchroniseesScreen extends StatefulWidget {
  @override
  _NonSynchroniseesScreenState createState() => _NonSynchroniseesScreenState();
}

class _NonSynchroniseesScreenState extends State<NonSynchroniseesScreen> {
  final DatabaseService dbService = DatabaseService();
  late Future<List<Map<String, dynamic>>> _unsyncedMobileData;

  @override
  void initState() {
    super.initState();
    _loadUnsyncedMobileData();
  }

  void _loadUnsyncedMobileData() {
    setState(() {
      _unsyncedMobileData = dbService.getUnsyncedMobileData();
    });
  }

  Future<String?> refreshToken(String refreshToken) async {
    final response = await http.post(
      Uri.parse('https://traceagri.com/fr/auth/tablette/token/login/'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({'refresh': refreshToken}),
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return data['access']; // Retourner le nouveau token d'accès
    } else {
      print('Erreur lors du rafraîchissement du token : ${response.body}');
      return null;
    }
  }

  Future<void> _syncMobileData(Map<String, dynamic> data) async {
    try {
      // Charger le token à partir de SharedPreferences
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('auth_token');

      if (token == null) {
        throw Exception('Token d\'authentification non trouvé.');
      }

      print('Données envoyées pour la synchronisation : ${json.encode(data)}');

      // Effectuer la requête POST
      final response = await http.post(
        Uri.parse('https://traceagri.com/fr/api/mobiledata/'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Token $token',
        },
        body: json.encode(data),
      );

      if (response.statusCode == 201) {
        // Marquer comme synchronisé dans SQLite
        await dbService.markMobileDataAsSynced(data['id']);

        // Montrer un message de succès
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('${data['nom']} synchronisé avec succès')),
        );

        // Recharger les données non synchronisées
        _loadUnsyncedMobileData();
      } else {
        // Afficher l'erreur retournée par le serveur
        print('Erreur du serveur : ${response.statusCode} - ${response.body}');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erreur lors de la synchronisation de ${data['nom']} : ${response.body}')),
        );
      }
    } catch (e) {
      // Gérer les erreurs réseau ou autres exceptions
      print('Exception lors de la synchronisation : $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erreur : $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Données non synchronisées'),
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _unsyncedMobileData,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Erreur : ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('Aucune donnée non synchronisée.'));
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
                      ],
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Bouton d'édition
                        IconButton(
                          icon: Icon(Icons.edit, color: Colors.orange),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => EditLocalDataScreen(data: item),
                              ),
                            ).then((_) {
                              // Recharger les données après modification
                              setState(() {
                                _unsyncedMobileData = dbService.getUnsyncedMobileData();
                              });
                            });
                          },
                        ),
                        // Bouton de synchronisation
                        IconButton(
                          icon: Icon(Icons.sync, color: Colors.blue),
                          onPressed: () => _syncMobileData(item),
                        ),
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