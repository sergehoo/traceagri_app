import 'package:flutter/material.dart';

import '../services/api_service.dart';

class ProducteursScreen extends StatefulWidget {
  @override
  _ProducteursScreenState createState() => _ProducteursScreenState();
}

class _ProducteursScreenState extends State<ProducteursScreen> {
  final ApiService apiService = ApiService();
  late Future<List<dynamic>> _producteurs;

  @override
  void initState() {
    super.initState();
    _producteurs = apiService.fetchProducteurs();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Détails des Producteurs'),
      ),
      body: FutureBuilder<List<dynamic>>(
        future: _producteurs,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Erreur : ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('Aucun producteur trouvé.'));
          } else {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                final producteur = snapshot.data![index];
                return ListTile(
                  title: Text(producteur['nom'] ?? 'Nom inconnu'),
                  subtitle: Text(producteur['telephone'] ?? 'Téléphone inconnu'),
                  trailing: Text(producteur['sexe'] ?? 'N/A'),
                );
              },
            );
          }
        },
      ),
    );
  }
}