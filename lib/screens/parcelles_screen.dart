import 'package:flutter/material.dart';
import 'package:traceagri_app/screens/parcelle_form_screen.dart';
import '../models/parcelle.dart';
import '../services/api_service.dart';


class ParcellesScreen extends StatefulWidget {
  @override
  _ParcellesScreenState createState() => _ParcellesScreenState();
}

class _ParcellesScreenState extends State<ParcellesScreen> {
  final ApiService apiService = ApiService(); // Instance d'ApiService
  late Future<List<Parcelle>> _parcelles;

  @override
  void initState() {
    super.initState();
    _parcelles = _fetchParcelles();
  }

  Future<List<Parcelle>> _fetchParcelles() async {
    final response = await apiService.fetchParcelles();
    return response.map<Parcelle>((data) => Parcelle.fromJson(data)).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Détails des Parcelles')),
      body: FutureBuilder<List<Parcelle>>(
        future: _parcelles,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Erreur : ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('Aucune parcelle trouvée'));
          } else {
            final parcelles = snapshot.data!;
            return MediaQuery.of(context).size.width > 600
                ? _buildDataTable(parcelles) // Tableau pour les grands écrans
                : _buildList(parcelles); // Liste pour les petits écrans
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ParcelleFormScreen(), // Remplacez par l'écran du formulaire
            ),
          );
        },
        child: Icon(Icons.add),
        tooltip: 'Ajouter une parcelle',
      ),
    );
  }

  // Construire le tableau pour les grands écrans
  Widget _buildDataTable(List<Parcelle> parcelles) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: DataTable(
        columns: [
          DataColumn(label: Text('Image')),
          DataColumn(label: Text('Nom')),
          DataColumn(label: Text('Localité')),
          DataColumn(label: Text('Dimension (ha)')),
          DataColumn(label: Text('Producteur')),
        ],
        rows: parcelles.map((parcelle) {
          return DataRow(
            cells: [
              DataCell(
                Image.network(
                  parcelle.image.isNotEmpty
                      ? parcelle.image
                      : 'assets/images/default_land.jpg',
                  width: 100,
                  height: 100,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Image.asset(
                      'assets/images/default_land.jpg',
                      width: 100,
                      height: 100,
                      fit: BoxFit.cover,
                    );
                  },
                ),
              ),
              DataCell(Text(parcelle.nom)),
              DataCell(Text(parcelle.localiteName)), // Nom de la localité
              DataCell(Text(parcelle.dimensionHa)),
              DataCell(Text(parcelle.producteurName)), // Nom du producteur
            ],
          );
        }).toList(),
      ),
    );
  }

  // Construire la liste pour les petits écrans
  Widget _buildList(List<Parcelle> parcelles) {
    return ListView.builder(
      itemCount: parcelles.length,
      itemBuilder: (context, index) {
        final parcelle = parcelles[index];
        return Card(
          margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
          child: ListTile(
            leading: Image.network(
              parcelle.image.isNotEmpty
                  ? parcelle.image
                  : 'assets/images/default_land.jpg',
              width: 100,
              height: 100,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Image.asset(
                  'assets/images/default_land.jpg',
                  width: 100,
                  height: 100,
                  fit: BoxFit.cover,
                );
              },
            ),
            title: Text(parcelle.nom),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Localité: ${parcelle.localiteName}'),
                Text('Dimension: ${parcelle.dimensionHa} ha'),
                Text('Producteur: ${parcelle.producteurName}'),
              ],
            ),
          ),
        );
      },
    );
  }
}