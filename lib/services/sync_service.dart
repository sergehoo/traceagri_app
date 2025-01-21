import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'api_service.dart';
import 'database_service.dart';


// class SyncService {
//   final ApiService apiService;
//   final DatabaseService dbService;
//
//   SyncService({required this.apiService, required this.dbService});
//
//   Future<void> syncData() async {
//     try {
//       // Récupération des producteurs non synchronisés
//       final unsyncedProducteurs = await dbService.getUnsyncedProducteurs();
//       print('Nombre de producteurs non synchronisés : ${unsyncedProducteurs.length}');
//
//       for (var producteur in unsyncedProducteurs) {
//         try {
//           // Envoi du producteur au backend
//           await apiService.addProducteur(producteur);
//           // Marquer comme synchronisé dans la base locale
//           await dbService.markProducteurAsSynced(producteur['id']);
//           print('Producteur synchronisé avec succès : ${producteur['id']}');
//         } catch (e) {
//           print('Erreur de synchronisation du producteur (${producteur['id']}) : $e');
//         }
//       }
//
//       // Récupération des parcelles non synchronisées
//       final unsyncedParcelles = await dbService.getUnsyncedParcelles();
//       print('Nombre de parcelles non synchronisées : ${unsyncedParcelles.length}');
//
//       for (var parcelle in unsyncedParcelles) {
//         try {
//           // Envoi de la parcelle au backend
//           await apiService.addParcelle(parcelle);
//           // Marquer comme synchronisée dans la base locale
//           await dbService.markParcelleAsSynced(parcelle['id']);
//           print('Parcelle synchronisée avec succès : ${parcelle['id']}');
//         } catch (e) {
//           print('Erreur de synchronisation de la parcelle (${parcelle['id']}) : $e');
//         }
//       }
//
//       print('Synchronisation terminée.');
//     } catch (e) {
//       print('Erreur générale de synchronisation : $e');
//       throw Exception('Échec de la synchronisation des données.');
//     }
//   }
// }

class SyncService {
  final String syncUrl = 'https://traceagri.com/fr/api/mobiledata/';
  final String refreshUrl = 'https://traceagri.com/fr/auth/token/refresh/';

  Future<void> syncMobileData(BuildContext context, Map<String, dynamic> mobileData) async {
    final prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('auth_token');

    if (token == null) {
      _redirectToLogin(context);
      return;
    }

    final response = await http.post(
      Uri.parse(syncUrl),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: json.encode(mobileData),
    );

    if (response.statusCode == 403) {
      // Token expiré, essayons de le rafraîchir
      print('Token expiré, tentative de rafraîchissement...');
      final refreshToken = prefs.getString('refresh_token');
      if (refreshToken != null) {
        final newToken = await _refreshToken(refreshToken);
        if (newToken != null) {
          prefs.setString('auth_token', newToken);
          // Réessayons avec le nouveau token
          await syncMobileData(context, mobileData);
        } else {
          _redirectToLogin(context);
        }
      } else {
        _redirectToLogin(context);
      }
    } else if (response.statusCode == 201) {
      print('Données synchronisées avec succès');
    } else {
      print('Erreur du serveur : ${response.statusCode} - ${response.body}');
    }
  }

  Future<String?> _refreshToken(String refreshToken) async {
    try {
      final response = await http.post(
        Uri.parse(refreshUrl),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'refresh': refreshToken}),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return data['access'];
      } else {
        print('Erreur lors du rafraîchissement du token : ${response.body}');
        return null;
      }
    } catch (e) {
      print('Erreur réseau : $e');
      return null;
    }
  }

  void _redirectToLogin(BuildContext context) {
    Navigator.pushReplacementNamed(context, '/login');
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Veuillez vous reconnecter.')),
    );
  }
}