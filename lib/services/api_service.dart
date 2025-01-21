import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../models/enquete.dart';

class ApiService {
  final String baseApiUrl = "https://traceagri.com/fr/api/";
  final String prodApiUrl = "https://traceagri.com/fr/api/producteursmobile/";
  final String parcApiUrl = "https://traceagri.com/fr/api/parcellesmobile/";
  final String authApiUrl = "https://traceagri.com/fr/auth/tablette/token/login/";

  // Authentification utilisateur
  Future<bool> authenticateUser(String username, String password) async {
    final url = Uri.parse(authApiUrl);
    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'username': username, 'password': password}),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final responseData = json.decode(response.body);
        final authToken = responseData['auth_token'];
        if (authToken != null) {
          await saveToken(authToken);
          return true;
        } else {
          throw Exception('Token manquant dans la réponse.');
        }
      } else {
        throw Exception('Erreur d\'authentification : ${response.body}');
      }
    } catch (e) {
      throw Exception('Erreur réseau ou serveur : $e');
    }
  }

  // Sauvegarder le token
  Future<void> saveToken(String token) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('auth_token', token);
    } catch (e) {
      throw Exception('Erreur lors de la sauvegarde du token : $e');
    }
  }

  // Récupérer le token
  Future<String?> getToken() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getString('auth_token');
    } catch (e) {
      throw Exception('Erreur lors de la récupération du token : $e');
    }
  }


  Future<bool> createMobileData(MobileData data) async {
    final token = await getToken();
    if (token == null) {
      throw Exception("Token manquant. Veuillez vous authentifier.");
    }

    final url = Uri.parse('$baseApiUrl/mobiledata/');
    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Token $token',
      },
      body: jsonEncode(data.toJson()),
    );

    if (response.statusCode == 201) {
      return true;
    } else {
      print('Erreur API: ${response.body}');
      return false;
    }
  }
  /// Vérifie si l'utilisateur est connecté
  Future<bool> isUserLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool('is_logged_in') ?? false; // Valeur par défaut false
  }

  // Ajouter un producteur
  Future<void> addProducteur(Map<String, dynamic> producteur) async {
    final url = Uri.parse(prodApiUrl);
    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: json.encode(producteur),
      );

      if (response.statusCode != 201) {
        throw Exception('Échec de l\'ajout du producteur : ${response.body}');
      }
    } catch (e) {
      throw Exception('Erreur lors de l\'ajout du producteur : $e');
    }
  }

  // Ajouter une parcelle
  Future<void> addParcelle(Map<String, dynamic> parcelle) async {
    final url = Uri.parse(parcApiUrl);
    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: json.encode(parcelle),
      );

      if (response.statusCode != 201) {
        throw Exception('Échec de l\'ajout de la parcelle : ${response.body}');
      }
    } catch (e) {
      throw Exception('Erreur lors de l\'ajout de la parcelle : $e');
    }
  }

  // Récupérer les producteurs
  Future<List<dynamic>> fetchProducteurs() async {
    final token = await getToken();
    if (token == null) {
      throw Exception('Token introuvable. Veuillez vous connecter.');
    }

    final response = await http.get(
      Uri.parse(prodApiUrl),
      headers: {'Authorization': 'Token $token'},
    );

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Échec du chargement des producteurs : ${response.statusCode}');
    }
  }

  // Récupérer les parcelles
  Future<List<dynamic>> fetchParcelles() async {
    final token = await getToken();
    if (token == null) {
      throw Exception('Token introuvable. Veuillez vous connecter.');
    }

    final response = await http.get(
      Uri.parse(parcApiUrl),
      headers: {'Authorization': 'Token $token'},
    );

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Échec du chargement des parcelles : ${response.statusCode}');
    }
  }

  // Récupérer les projets
  Future<List<dynamic>> fetchProjects() async {
    final response = await http.get(Uri.parse('${baseApiUrl}projects/'));
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Échec du chargement des projets.');
    }
  }

  // Récupérer les coopératives
  Future<List<dynamic>> fetchCooperatives() async {
    final response = await http.get(Uri.parse('${baseApiUrl}cooperatives/'));
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Échec du chargement des coopératives.');
    }
  }

  // Récupérer les membres des coopératives
  Future<List<dynamic>> fetchCooperativeMembers() async {
    final response = await http.get(Uri.parse('${baseApiUrl}cooperative-members/'));
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Échec du chargement des membres de coopératives.');
    }
  }
}





// class ApiService {
//   // URLs de l'API
//   final String baseApiUrl = "https://traceagri.com/fr/api/";
//   final String prodApiUrl = "https://traceagri.com/fr/api/producteursmobile/";
//   final String parcApiUrl = "https://traceagri.com/fr/api/parcellesmobile/";
//   final String authApiUrl = "https://traceagri.com/fr/auth/tablette/token/login/";
//
//   /// Authentification de l'utilisateur
//   Future<bool> authenticateUser(String username, String password) async {
//     final url = Uri.parse(authApiUrl);
//     try {
//       final response = await http.post(
//         url,
//         headers: {'Content-Type': 'application/json'},
//         body: json.encode({'username': username, 'password': password}),
//       );
//
//       if (response.statusCode == 200 || response.statusCode == 201) {
//         final responseData = json.decode(response.body);
//
//         if (responseData.containsKey('auth_token')) {
//           final authToken = responseData['auth_token'];
//           await saveToken(authToken); // Sauvegarde le token
//           await setLoginState(true); // Marque l'utilisateur comme connecté
//           return true;
//         } else {
//           throw Exception('auth_token manquant dans la réponse.');
//         }
//       } else {
//         throw Exception('Erreur d\'authentification : ${response.body}');
//       }
//     } catch (e) {
//       throw Exception('Erreur réseau ou serveur : $e');
//     }
//   }
//
//   /// Sauvegarde du token d'accès
//   Future<void> saveToken(String token) async {
//     final prefs = await SharedPreferences.getInstance();
//     await prefs.setString('auth_token', token);
//     await setLoginState(true); // Définit l'état de connexion comme actif
//   }
//
//   /// Définit l'état de connexion
//   Future<void> setLoginState(bool isLoggedIn) async {
//     final prefs = await SharedPreferences.getInstance();
//     await prefs.setBool('is_logged_in', isLoggedIn);
//   }
//
//   /// Vérifie si l'utilisateur est connecté
//   Future<bool> isUserLoggedIn() async {
//     final prefs = await SharedPreferences.getInstance();
//     return prefs.getBool('is_logged_in') ?? false; // Valeur par défaut false
//   }
//
//   /// Récupère le token d'accès
//   Future<String> getToken() async {
//     final prefs = await SharedPreferences.getInstance();
//     final token = prefs.getString('auth_token');
//     if (token == null || token.isEmpty) {
//       throw Exception('Token non trouvé dans les préférences.');
//     }
//     return token;
//   }
//
//   /// Déconnexion de l'utilisateur
//   Future<void> logout() async {
//     final prefs = await SharedPreferences.getInstance();
//     await prefs.remove('auth_token');
//     await prefs.setBool('is_logged_in', false); // Supprime l'état de connexion
//   }
//
//   /// Création des données MobileData
//   Future<bool> createMobileData(MobileData data) async {
//     final token = await getToken();
//     if (token == null) {
//       throw Exception("Token manquant. Veuillez vous authentifier.");
//     }
//
//     final url = Uri.parse('$baseApiUrl/mobiledata/');
//     final response = await http.post(
//       url,
//       headers: {
//         'Content-Type': 'application/json',
//         'Authorization': 'Token $token',
//       },
//       body: jsonEncode(data.toJson()),
//     );
//
//     if (response.statusCode == 201) {
//       return true;
//     } else {
//       print('Erreur API: ${response.body}');
//       return false;
//     }
//   }
//
//   /// Ajout d'un producteur
//   Future<void> addProducteur(Map<String, dynamic> producteur) async {
//     final token = await getToken();
//     if (token == null) {
//       throw Exception("Token manquant. Veuillez vous authentifier.");
//     }
//
//     final url = Uri.parse(prodApiUrl);
//     final response = await http.post(
//       url,
//       headers: {
//         'Content-Type': 'application/json',
//         'Authorization': 'Token $token',
//       },
//       body: json.encode(producteur),
//     );
//
//     if (response.statusCode != 201) {
//       throw Exception('Erreur lors de l\'ajout du producteur : ${response.body}');
//     }
//   }
//
//   /// Ajout d'une parcelle
//   Future<void> addParcelle(Map<String, dynamic> parcelle) async {
//     final token = await getToken();
//     if (token == null) {
//       throw Exception("Token manquant. Veuillez vous authentifier.");
//     }
//
//     final url = Uri.parse(parcApiUrl);
//     final response = await http.post(
//       url,
//       headers: {
//         'Content-Type': 'application/json',
//         'Authorization': 'Token $token',
//       },
//       body: json.encode(parcelle),
//     );
//
//     if (response.statusCode != 201) {
//       throw Exception('Erreur lors de l\'ajout de la parcelle : ${response.body}');
//     }
//   }
//
//   /// Récupération des producteurs
//   Future<List<dynamic>> fetchProducteurs() async {
//     final token = await getToken();
//     if (token == null) {
//       throw Exception('Token introuvable. Veuillez vous connecter.');
//     }
//
//     final response = await http.get(
//       Uri.parse(prodApiUrl),
//       headers: {'Authorization': 'Token $token'},
//     );
//
//     if (response.statusCode == 200) {
//       return json.decode(response.body);
//     } else {
//       throw Exception('Erreur lors de la récupération des producteurs : ${response.statusCode}');
//     }
//   }
//
//   /// Récupération des parcelles
//   Future<List<dynamic>> fetchParcelles() async {
//     final token = await getToken();
//     if (token == null) {
//       throw Exception('Token introuvable. Veuillez vous connecter.');
//     }
//
//     final response = await http.get(
//       Uri.parse(parcApiUrl),
//       headers: {'Authorization': 'Token $token'},
//     );
//
//     if (response.statusCode == 200) {
//       return json.decode(response.body);
//     } else {
//       throw Exception('Erreur lors de la récupération des parcelles : ${response.statusCode}');
//     }
//   }
//
//   /// Récupération des projets
//   Future<List<dynamic>> fetchProjects() async {
//     final response = await http.get(Uri.parse('${baseApiUrl}projects/'));
//
//     if (response.statusCode == 200) {
//       return json.decode(response.body);
//     } else {
//       throw Exception('Erreur lors de la récupération des projets.');
//     }
//   }
//
//   /// Récupération des coopératives
//   Future<List<dynamic>> fetchCooperatives() async {
//     final response = await http.get(Uri.parse('${baseApiUrl}cooperatives/'));
//
//     if (response.statusCode == 200) {
//       return json.decode(response.body);
//     } else {
//       throw Exception('Erreur lors de la récupération des coopératives.');
//     }
//   }
//
//   /// Récupération des membres des coopératives
//   Future<List<dynamic>> fetchCooperativeMembers() async {
//     final response = await http.get(Uri.parse('${baseApiUrl}cooperative-members/'));
//
//     if (response.statusCode == 200) {
//       return json.decode(response.body);
//     } else {
//       throw Exception('Erreur lors de la récupération des membres des coopératives.');
//     }
//   }
// }


