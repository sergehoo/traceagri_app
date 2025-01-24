import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:intl/intl.dart';
import '../services/database_service.dart';
import 'non_synchronisees_screen.dart';

class MobileDataFormScreen extends StatefulWidget {
  @override
  _MobileDataFormScreenState createState() => _MobileDataFormScreenState();
}

class _MobileDataFormScreenState extends State<MobileDataFormScreen> {
  final _formKey = GlobalKey<FormBuilderState>();
  final DatabaseService dbService = DatabaseService();

  bool usesFertilizer = false;
  bool belongsToCooperative = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Formulaire d\'enquête Parcelle'),
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
                name: 'nom',
                decoration: InputDecoration(labelText: 'Nom'),
                validator: FormBuilderValidators.required(errorText: 'Nom requis.'),
              ),
              FormBuilderTextField(
                name: 'prenom',
                decoration: InputDecoration(labelText: 'Prénom'),
                validator: FormBuilderValidators.required(errorText: 'Prénom requis.'),
              ),
              FormBuilderDropdown<String>(
                name: 'sexe',
                decoration: InputDecoration(labelText: 'Sexe'),
                items: [
                  DropdownMenuItem(value: 'M', child: Text('Masculin')),
                  DropdownMenuItem(value: 'F', child: Text('Féminin')),
                ],
                validator: FormBuilderValidators.required(errorText: 'Sexe requis.'),
              ),
              FormBuilderTextField(
                name: 'telephone',
                decoration: InputDecoration(labelText: 'Téléphone'),
                keyboardType: TextInputType.phone,
                validator: FormBuilderValidators.compose([
                  FormBuilderValidators.required(errorText: 'Téléphone requis.'),
                  FormBuilderValidators.numeric(errorText: 'Entrez un numéro valide.'),
                ]),
              ),
              FormBuilderDateTimePicker(
                name: 'date_naissance',
                decoration: InputDecoration(labelText: 'Date de Naissance'),
                inputType: InputType.date,
                validator: FormBuilderValidators.required(errorText: 'Date de naissance requise.'),
              ),
              FormBuilderTextField(
                name: 'lieu_naissance',
                decoration: InputDecoration(labelText: 'Lieu de Naissance'),
              ),
              FormBuilderTextField(
                name: 'photo',
                decoration: InputDecoration(labelText: 'Photo (URL)'),
              ),
              FormBuilderTextField(
                name: 'fonction',
                decoration: InputDecoration(labelText: 'Fonction'),
              ),
              FormBuilderDropdown<String>(
                name: 'localite',
                decoration: InputDecoration(labelText: 'Localité'),
                items: [
                  DropdownMenuItem(value: 'ville1', child: Text('Ville 1')),
                  DropdownMenuItem(value: 'ville2', child: Text('Ville 2')),
                ],
              ),
              FormBuilderTextField(
                name: 'taille_du_foyer',
                decoration: InputDecoration(labelText: 'Taille du Foyer'),
                keyboardType: TextInputType.number,
                validator: FormBuilderValidators.required(errorText: 'Taille du foyer requise.'),
              ),
              FormBuilderTextField(
                name: 'nombre_dependants',
                decoration: InputDecoration(labelText: 'Nombre de Dépendants'),
                keyboardType: TextInputType.number,
              ),
              FormBuilderTextField(
                name: 'cultures_precedentes',
                decoration: InputDecoration(labelText: 'Cultures Précédentes'),
              ),
              FormBuilderTextField(
                name: 'annee_cultures_precedentes',
                decoration: InputDecoration(labelText: 'Année des Cultures Précédentes'),
                keyboardType: TextInputType.number,
              ),
              FormBuilderDropdown<String>(
                name: 'evenements_climatiques',
                decoration: InputDecoration(labelText: 'Événements Climatiques'),
                items: [
                  DropdownMenuItem(value: 'drought', child: Text('Sécheresse')),
                  DropdownMenuItem(value: 'floods', child: Text('Inondations')),
                  DropdownMenuItem(value: 'crop_lodging', child: Text('Chute des cultures')),
                  DropdownMenuItem(value: 'heat_stress', child: Text('Stress thermique')),
                  DropdownMenuItem(value: 'pests_diseases', child: Text('Ravageurs et maladies')),
                  DropdownMenuItem(value: 'none', child: Text('Aucun')),
                  DropdownMenuItem(value: 'other', child: Text('Autres')),
                ],
              ),
              FormBuilderTextField(
                name: 'commentaires',
                decoration: InputDecoration(labelText: 'Commentaires'),
                maxLines: 3,
              ),
              FormBuilderTextField(
                name: 'nom_parcelle',
                decoration: InputDecoration(labelText: 'Nom de la Parcelle'),
              ),
              FormBuilderTextField(
                name: 'dimension_ha',
                decoration: InputDecoration(labelText: 'Dimension de la Parcelle (ha)'),
                keyboardType: TextInputType.number,
              ),
              FormBuilderTextField(
                name: 'longitude',
                decoration: InputDecoration(labelText: 'Longitude'),
                keyboardType: TextInputType.number,
              ),
              FormBuilderTextField(
                name: 'latitude',
                decoration: InputDecoration(labelText: 'Latitude'),
                keyboardType: TextInputType.number,
              ),
              FormBuilderDropdown<String>(
                name: 'category',
                decoration: InputDecoration(labelText: 'Catégorie'),
                items: [
                  DropdownMenuItem(value: 'vivriere', child: Text('Culture Vivrière')),
                  DropdownMenuItem(value: 'industrial', child: Text('Culture Industrielle')),
                  DropdownMenuItem(value: 'rente', child: Text('Culture de Rente')),
                  DropdownMenuItem(value: 'maraichere', child: Text('Culture Maraîchère')),
                  DropdownMenuItem(value: 'fruitiere', child: Text('Culture Fruitière')),
                  DropdownMenuItem(value: 'specialisee', child: Text('Culture Spécialisée')),
                  DropdownMenuItem(value: 'florale', child: Text('Culture Florale et Ornementale')),
                  DropdownMenuItem(value: 'emergente', child: Text('Culture Émergente')),
                ],
              ),
              FormBuilderDropdown<String>(
                name: 'type_culture',
                decoration: InputDecoration(labelText: 'Type de Culture'),
                items: [
                  DropdownMenuItem(value: 'perennial', child: Text('Culture Pérenne')),
                  DropdownMenuItem(value: 'seasonal', child: Text('Culture Saisonnière')),
                ],
              ),
              FormBuilderDropdown<String>(
                name: 'nom_culture',
                decoration: InputDecoration(labelText: 'Nom de la Culture'),
                items: [
                  DropdownMenuItem(value: 'cacao', child: Text('Cacao')),
                  DropdownMenuItem(value: 'manioc', child: Text('Manioc')),
                  DropdownMenuItem(value: 'riz', child: Text('Riz')),
                  DropdownMenuItem(value: 'oignon', child: Text('Oignon')),
                  DropdownMenuItem(value: 'gingembre', child: Text('Gingembre')),
                ],
              ),
              FormBuilderTextField(
                name: 'description',
                decoration: InputDecoration(labelText: 'Description'),
              ),
              FormBuilderDropdown<String>(
                name: 'pratiques_culturales',
                decoration: InputDecoration(labelText: 'Pratiques Culturales'),
                items: [
                  DropdownMenuItem(value: 'agroforestry', child: Text('Agroforesterie')),
                  DropdownMenuItem(value: 'composting', child: Text('Compostage')),
                  DropdownMenuItem(value: 'crop_rotation', child: Text('Rotation des cultures')),
                  DropdownMenuItem(value: 'precision_farming', child: Text('Agriculture de précision')),
                  DropdownMenuItem(value: 'irrigation_management', child: Text('Gestion de l’irrigation')),
                ],
              ),
              FormBuilderSwitch(
                name: 'utilise_fertilisants',
                title: Text("Utilisez-vous des fertilisants ?"),
                onChanged: (value) {
                  setState(() {
                    usesFertilizer = value ?? false;
                  });
                },
              ),
              if (usesFertilizer)
                FormBuilderTextField(
                  name: 'type_fertilisants',
                  decoration: InputDecoration(labelText: 'Quels fertilisants ?'),
                ),
              FormBuilderSwitch(
                name: 'analyse_sol',
                title: Text('Avez-vous réalisé une analyse du sol ?'),
              ),
              FormBuilderTextField(
                name: 'autre_culture',
                decoration: InputDecoration(labelText: 'Autre Culture'),
              ),
              FormBuilderTextField(
                  name: 'autre_culture_nom',
                  decoration: InputDecoration(labelText: 'Nom de l\'Autre Culture'),
                  ),
                  FormBuilderTextField(
                    name: 'autre_culture_volume_ha',
                    decoration: InputDecoration(labelText: 'Volume de l\'Autre Culture (ha)'),
                    keyboardType: TextInputType.number,
                  ),
                  FormBuilderSwitch(
                    name: 'cooperative',
                    title: Text('Appartenez-vous à une coopérative ?'),
                    onChanged: (value) {
                      setState(() {
                        belongsToCooperative = value ?? false;
                      });
                    },
                  ),
                  if (belongsToCooperative)
              FormBuilderTextField(
                name: 'nom_cooperative',
                decoration: InputDecoration(labelText: 'Nom de la coopérative'),
              ),
              FormBuilderTextField(
                name: 'ville',
                decoration: InputDecoration(labelText: 'Ville'),
              ),
              FormBuilderDropdown<String>(
                name: 'specialites',
                decoration: InputDecoration(labelText: 'Spécialités'),
                items: [
                  DropdownMenuItem(value: 'cacao', child: Text('Cacao')),
                  DropdownMenuItem(value: 'manioc', child: Text('Manioc')),
                  DropdownMenuItem(value: 'riz', child: Text('Riz')),
                ],
              ),
              FormBuilderSwitch(
                name: 'is_president',
                title: Text('Êtes-vous président de la coopérative ?'),
              ),
              FormBuilderTextField(
                name: 'projet',
                decoration: InputDecoration(labelText: 'Projet'),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState?.saveAndValidate() ?? false) {
                    final formData = _formKey.currentState!.value;

                    final payload = {
                      "id": null,
                      'nom': formData['nom'],
                      'prenom': formData['prenom'],
                      'sexe': formData['sexe'],
                      'telephone': formData['telephone'],
                      'date_naissance': formData['date_naissance'] != null
                          ? DateFormat('yyyy-MM-dd').format(formData['date_naissance'])
                          : null,
                      'lieu_naissance': formData['lieu_naissance'],
                      'photo': formData['photo'],
                      'fonction': formData['fonction'],
                      'localite': formData['localite'],
                      'taille_du_foyer': formData['taille_du_foyer'],
                      'nombre_dependants': formData['nombre_dependants'],
                      'cultures_precedentes': formData['cultures_precedentes'],
                      'annee_cultures_precedentes': formData['annee_cultures_precedentes'],
                      'evenements_climatiques': formData['evenements_climatiques'],
                      'commentaires': formData['commentaires'],
                      'nom_parcelle': formData['nom_parcelle'],
                      'dimension_ha': formData['dimension_ha'],
                      'longitude': formData['longitude'],
                      'latitude': formData['latitude'],
                      'category': formData['category'],
                      'type_culture': formData['type_culture'],
                      'nom_culture': formData['nom_culture'],
                      'description': formData['description'],
                      'pratiques_culturales': formData['pratiques_culturales'],
                      'utilise_fertilisants': formData['utilise_fertilisants'] == true ? 1 : 0,
                      'type_fertilisants': formData['type_fertilisants'],
                      'analyse_sol': formData['analyse_sol'] == true ? 1 : 0,
                      'autre_culture': formData['autre_culture'],
                      'autre_culture_nom': formData['autre_culture_nom'],
                      'autre_culture_volume_ha': formData['autre_culture_volume_ha'],
                      'nom_cooperative': formData['nom_cooperative'],
                      'ville': formData['ville'],
                      'specialites': formData['specialites'],
                      'is_president': formData['is_president'] == true ? 1 : 0,
                      'projet': formData['projet'],
                      'horodateur': formData['horodateur'],
                      'is_synced': 0,
                    };

                    await dbService.insertMobileData(payload);

                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Données enregistrées localement.')),
                    );

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
