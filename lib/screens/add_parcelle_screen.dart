import 'package:flutter/material.dart';
import '../services/api_service.dart';

class AddParcelleScreen extends StatelessWidget {
  final _formKey = GlobalKey<FormState>();
  final ApiService apiService = ApiService();

  final TextEditingController _nomController = TextEditingController();
  final TextEditingController _dimensionController = TextEditingController();
  final TextEditingController _producteurIdController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Ajouter une parcelle')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _nomController,
                decoration: InputDecoration(labelText: 'Nom de la parcelle'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Veuillez entrer un nom';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _dimensionController,
                decoration: InputDecoration(labelText: 'Dimension (ha)'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Veuillez entrer une dimension';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _producteurIdController,
                decoration: InputDecoration(labelText: 'ID du producteur'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Veuillez entrer l\'ID du producteur';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    final parcelle = {
                      'nom': _nomController.text,
                      'dimension_ha': double.parse(_dimensionController.text),
                      'producteur': int.parse(_producteurIdController.text),
                    };
                    try {
                      await apiService.addParcelle(parcelle);
                      Navigator.pop(context);
                    } catch (e) {
                      print(e);
                    }
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