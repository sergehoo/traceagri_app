import 'package:flutter/material.dart';
import '../models/formulaires.dart';
import '../services/api_service.dart';
import '../services/database_service.dart';

// class FormulairesScreen extends StatefulWidget {
//   @override
//   _FormulairesScreenState createState() => _FormulairesScreenState();
// }
//
// class _FormulairesScreenState extends State<FormulairesScreen> {
//   final ApiService apiService = ApiService();
//   final DatabaseService dbService = DatabaseService();
//   List<Formulaire> formulaires = [];
//   bool isLoading = true;
//
//   Future<void> loadFormulaires() async {
//     try {
//       // Tente de récupérer les formulaires depuis l'API
//       await apiService.fetchAndSaveFormulaires();
//     } catch (e) {
//       print('Erreur : $e');
//     }
//
//     // Charge les formulaires depuis la base locale
//     final localFormulaires = await dbService.getFormulaires();
//     setState(() {
//       formulaires = localFormulaires;
//       isLoading = false;
//     });
//   }
//
//   @override
//   void initState() {
//     super.initState();
//     loadFormulaires();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text('Formulaires')),
//       body: isLoading
//           ? Center(child: CircularProgressIndicator())
//           : ListView.builder(
//         itemCount: formulaires.length,
//         itemBuilder: (context, index) {
//           final formulaire = formulaires[index];
//           return ListTile(
//             title: Text(formulaire.name),
//             subtitle: Text(formulaire.description),
//           );
//         },
//       ),
//     );
//   }
// }