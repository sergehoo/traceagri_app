import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:intl/intl.dart';

import '../services/database_service.dart';
import 'non_synchronisees_screen.dart';

class ParcelleFormScreen extends StatefulWidget {
  @override
  _ParcelleFormScreenState createState() => _ParcelleFormScreenState();
}

class _ParcelleFormScreenState extends State<ParcelleFormScreen> {
  final _formKey = GlobalKey<FormBuilderState>();
  final DatabaseService dbService = DatabaseService();
  bool belongsToCooperative = false;
  bool practicesPerenne = false;
  bool usesFertilizer = false;
  bool practicesSeasonal = false;
  bool plantedOtherCrops = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Création de Parcelle'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: FormBuilder(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              FormBuilderTextField(
                name: 'horodateur',
                decoration: InputDecoration(labelText: 'Horodateur'),
                readOnly: true,
                initialValue: DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.now()),
              ),
              FormBuilderTextField(
                name: 'nom_producteur',
                decoration: InputDecoration(labelText: 'Nom et Prénoms du Producteur'),
              ),
              FormBuilderTextField(
                name: 'numero_telephone',
                decoration: InputDecoration(labelText: 'Numéro de Téléphone'),
                keyboardType: TextInputType.phone,
              ),
              FormBuilderDropdown<String>(
                name: 'sexe',
                decoration: InputDecoration(labelText: 'Sexe'),
                items: ['Masculin', 'Féminin']
                    .map((sexe) => DropdownMenuItem(value: sexe, child: Text(sexe)))
                    .toList(),
              ),
              FormBuilderSwitch(
                name: 'cooperative',
                title: Text('Appartenez-vous à une coopérative?'),
                onChanged: (value) {
                  setState(() {
                    belongsToCooperative = value ?? false;
                  });
                },
              ),
              if (belongsToCooperative)
                FormBuilderTextField(
                  name: 'nom_cooperative',
                  decoration: InputDecoration(labelText: 'Si oui, laquelle?'),
                ),
              FormBuilderSwitch(
                name: 'culture_perenne',
                title: Text('Pratiquez-vous une culture pérenne?'),
                onChanged: (value) {
                  setState(() {
                    practicesPerenne = value ?? false;
                  });
                },
              ),
              if (practicesPerenne) ...[
                FormBuilderTextField(
                  name: 'culture_perenne_nom',
                  decoration: InputDecoration(labelText: 'Laquelle(s)'),
                ),
                FormBuilderTextField(
                  name: 'annee_mise_en_place',
                  decoration: InputDecoration(labelText: "Année de mise en place de la culture"),
                  keyboardType: TextInputType.number,
                ),
                FormBuilderDateTimePicker(
                  name: 'date_derniere_recolte',
                  decoration: InputDecoration(labelText: "Date de la dernière récolte"),
                  inputType: InputType.date,
                ),
                FormBuilderTextField(
                  name: 'dernier_rendement',
                  decoration: InputDecoration(
                    labelText: 'Dernier rendement obtenu (Kg/Ha/culture)',
                  ),
                  keyboardType: TextInputType.number,
                ),
                FormBuilderTextField(
                  name: 'pratiques_culturelles',
                  decoration: InputDecoration(
                    labelText: "Pratiques culturales pour culture pérenne",
                  ),
                ),
              ],
              FormBuilderSwitch(
                name: 'utilisation_fertilisants',
                title: Text("Utilisez-vous des fertilisants?"),
                onChanged: (value) {
                  setState(() {
                    usesFertilizer = value ?? false;
                  });
                },
              ),
              if (usesFertilizer)
                FormBuilderTextField(
                  name: 'fertilisants',
                  decoration: InputDecoration(labelText: 'Si oui, lesquels?'),
                ),
              FormBuilderSwitch(
                name: 'culture_saisonniere',
                title: Text("Pratiquez-vous une culture vivrière/saisonnière/annuelle?"),
                onChanged: (value) {
                  setState(() {
                    practicesSeasonal = value ?? false;
                  });
                },
              ),
              if (practicesSeasonal)
                FormBuilderTextField(
                  name: 'culture_saisonniere_nom',
                  decoration: InputDecoration(labelText: "Si oui, laquelle(s)"),
                ),
              FormBuilderSwitch(
                name: 'autres_cultures',
                title: Text(
                    "Durant les quatre dernières années, avez-vous planté une autre culture sur la même parcelle?"),
                onChanged: (value) {
                  setState(() {
                    plantedOtherCrops = value ?? false;
                  });
                },
              ),
              if (plantedOtherCrops)
                FormBuilderTextField(
                  name: 'autres_cultures_annees',
                  decoration: InputDecoration(
                    labelText: 'Si oui, laquelle(s) et approximativement en quelle année?',
                  ),
                ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState?.saveAndValidate() ?? false) {
                    final formData = _formKey.currentState!.value;

                    // Insérez les données dans SQLite
                    await dbService.insertParcelle({
                      'nom': formData['nom_producteur'] ?? '',
                      'producteur': formData['nom_producteur'] ?? '',
                      'code': formData['code'] ?? '',
                      'localite': formData['localite'] ?? '',
                      'dimension_ha': formData['dimension_ha'] ?? '',
                      'status': formData['status'] ?? '',
                      'culture': formData['culture'] ?? '',
                      'polygone_kmz': formData['polygone_kmz'] ?? '',
                      'affectations': formData['affectations'] ?? '',
                      'is_synced': 0,
                    });

                    // Vérifiez toutes les parcelles
                    // await dbService.printAllParcelles();

                    // Montrez un message de succès
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Parcelle enregistrée localement')),
                    );

                    // Retour à l'écran précédent
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => NonSynchroniseesScreen()),
                    );
                  } else {
                    print('Validation échouée');
                  }
                },
                child: Text('Enregistrer'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}