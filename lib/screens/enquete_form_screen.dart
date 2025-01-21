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
        title: Text('Formulaire d\enquête Parcelle'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: FormBuilder(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Horodateur (automatique)
              FormBuilderTextField(
                name: 'horodateur',
                decoration: InputDecoration(labelText: 'Horodateur'),
                readOnly: true,
                initialValue: DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.now()),
              ),

              // Informations personnelles
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

              // Informations du foyer
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

              // Historique des cultures
              FormBuilderTextField(
                name: 'cultures_precedentes',
                decoration: InputDecoration(labelText: 'Cultures Précédentes'),
              ),
              FormBuilderTextField(
                name: 'annee_cultures_precedentes',
                decoration: InputDecoration(labelText: 'Année des Cultures Précédentes'),
                keyboardType: TextInputType.number,
              ),

              // Événements climatiques
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

              // Commentaires
              FormBuilderTextField(
                name: 'commentaires',
                decoration: InputDecoration(labelText: 'Commentaires'),
                maxLines: 3,
              ),

              // Utilisation des fertilisants
              FormBuilderSwitch(
                name: 'utilisation_fertilisants',
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

              // Appartenance à une coopérative
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

              // Bouton d'enregistrement
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState?.saveAndValidate() ?? false) {
                    final formData = _formKey.currentState!.value;

                    // Transformation des données
                    final payload = {
                      'nom': formData['nom'],
                      'prenom': formData['prenom'],
                      'sexe': formData['sexe'],
                      'telephone': formData['telephone'],
                      'date_naissance': formData['date_naissance'] != null
                          ? DateFormat('yyyy-MM-dd').format(formData['date_naissance'])
                          : null, // Formater la date au format attendu
                      'lieu_naissance': formData['lieu_naissance'],
                      'taille_du_foyer': formData['taille_du_foyer'],
                      'nombre_dependants': formData['nombre_dependants'],
                      'cultures_precedentes': formData['cultures_precedentes'],
                      'annee_cultures_precedentes': formData['annee_cultures_precedentes'],
                      'evenements_climatiques': formData['evenements_climatiques'],
                      'commentaires': formData['commentaires'],
                      'type_fertilisants': formData['type_fertilisants'],
                      'nom_cooperative': formData['nom_cooperative'],
                      'horodateur': formData['horodateur'],
                      'is_synced': 0, // Non synchronisé
                    };

                    // Enregistrement local
                    await dbService.insertMobileData(payload);

                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Données enregistrées localement.')),
                    );

                    // Redirection vers l'écran des données non synchronisées
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