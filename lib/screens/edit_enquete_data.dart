import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import '../services/database_service.dart';



class EditLocalDataScreen extends StatefulWidget {
  final Map<String, dynamic> data;

  EditLocalDataScreen({required this.data});

  @override
  _EditLocalDataScreenState createState() => _EditLocalDataScreenState();
}

class _EditLocalDataScreenState extends State<EditLocalDataScreen> {
  final _formKey = GlobalKey<FormBuilderState>();
  final DatabaseService dbService = DatabaseService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Modifier les données locales'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: FormBuilder(
          key: _formKey,
          initialValue: {
            'nom': widget.data['nom'] ?? '',
            'prenom': widget.data['prenom'] ?? '',
            'sexe': widget.data['sexe'] ?? '',
            'telephone': widget.data['telephone'] ?? '',
            'date_naissance': widget.data['date_naissance'] != null
                ? DateTime.tryParse(widget.data['date_naissance'])
                : null,
            'lieu_naissance': widget.data['lieu_naissance'] ?? '',
            'taille_du_foyer': widget.data['taille_du_foyer']?.toString() ?? '',
            'nombre_dependants': widget.data['nombre_dependants']?.toString() ?? '',
            'cultures_precedentes': widget.data['cultures_precedentes'] ?? '',
            'annee_cultures_precedentes': widget.data['annee_cultures_precedentes']?.toString() ?? '',
            'evenements_climatiques': widget.data['evenements_climatiques'] ?? '',
            'commentaires': widget.data['commentaires'] ?? '',
            'utilise_fertilisants': widget.data['utilise_fertilisants'] == 1,
            'type_fertilisants': widget.data['type_fertilisants'] ?? '',
            'nom_cooperative': widget.data['nom_cooperative'] ?? '',
          },
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
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
              ),
              FormBuilderTextField(
                name: 'lieu_naissance',
                decoration: InputDecoration(labelText: 'Lieu de Naissance'),
              ),
              FormBuilderTextField(
                name: 'taille_du_foyer',
                decoration: InputDecoration(labelText: 'Taille du Foyer'),
                keyboardType: TextInputType.number,
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
              FormBuilderSwitch(
                name: 'utilise_fertilisants',
                title: Text("Utilisez-vous des fertilisants ?"),
              ),
              FormBuilderTextField(
                name: 'type_fertilisants',
                decoration: InputDecoration(labelText: 'Quels fertilisants ?'),
              ),
              FormBuilderTextField(
                name: 'nom_cooperative',
                decoration: InputDecoration(labelText: 'Nom de la Coopérative'),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState?.saveAndValidate() ?? false) {
                    final Map<String, dynamic> updatedData =
                    Map<String, dynamic>.from(_formKey.currentState!.value);

                    // Conversion explicite des champs pour SQLite
                    updatedData['date_naissance'] = updatedData['date_naissance'] != null
                        ? (updatedData['date_naissance'] as DateTime).toIso8601String().split('T')[0]
                        : null;

                    updatedData['utilise_fertilisants'] =
                    (updatedData['utilise_fertilisants'] as bool) ? 1 : 0;

                    print('Données mises à jour : $updatedData');

                    try {
                      await dbService.updateMobileData(widget.data['id'], updatedData);

                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Données modifiées avec succès.')),
                      );

                      Navigator.pop(context, true);
                    } catch (e) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Erreur : $e')),
                      );
                    }
                  } else {
                    print('Validation échouée.');
                  }
                },
                child: Text('Modifier'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}