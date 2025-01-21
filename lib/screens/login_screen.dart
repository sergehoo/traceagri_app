import 'package:flutter/material.dart';
import '../services/api_service.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final ApiService apiService = ApiService(); // Instance d'ApiService
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isLoading = false;
  String? _errorMessage;

  Future<void> _login() async {
    // Valider le formulaire
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
        _errorMessage = null;
      });

      final username = _usernameController.text;
      final password = _passwordController.text;

      try {
        // Authentification via ApiService
        final success = await apiService.authenticateUser(username, password);

        setState(() {
          _isLoading = false;
        });

        if (success) {
          // Données fictives ou à récupérer dynamiquement
          final parcelles = 50; // Remplacez par une API ou des données réelles
          final producteurs = 20; // Remplacez par une API ou des données réelles
          final donneesSynchronisees = 30; // Remplacez par une API ou des données réelles
          final donneesNonSynchronisees = 5; // Remplacez par une API ou des données réelles
          final donneesEnAttente = 10; // Remplacez par une API ou des données réelles

          // Navigation vers HomeScreen avec les arguments nécessaires
          Navigator.pushReplacementNamed(
            context,
            '/home',
            arguments: {
              'username': username,
              'parcelles': parcelles,
              'producteurs': producteurs,
              'donneesSynchronisees': donneesSynchronisees,
              'donneesNonSynchronisees': donneesNonSynchronisees,
              'donneesEnAttente': donneesEnAttente,
            },
          );
        }
      } catch (e) {
        setState(() {
          _isLoading = false;
          _errorMessage = e.toString();
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Image de fond
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/login1.jpg'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          // Contenu principal
          Center(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Logo
                    Image.asset(
                      'assets/images/logowhite.png',
                      height: 100,
                    ),
                    SizedBox(height: 30),
                    // Formulaire de connexion
                    Card(
                      color: Colors.white.withOpacity(0.8),
                      elevation: 5,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Form(
                          key: _formKey,
                          child: Column(
                            children: [
                              Text(
                                'Connexion',
                                style: TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(height: 20),
                              if (_errorMessage != null)
                                Text(
                                  _errorMessage!,
                                  style: TextStyle(
                                    color: Colors.red,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              SizedBox(height: 10),
                              TextFormField(
                                controller: _usernameController,
                                decoration: InputDecoration(
                                  labelText: 'Nom d\'utilisateur',
                                  border: OutlineInputBorder(),
                                ),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Veuillez entrer un nom d\'utilisateur.';
                                  }
                                  return null;
                                },
                              ),
                              SizedBox(height: 20),
                              TextFormField(
                                controller: _passwordController,
                                decoration: InputDecoration(
                                  labelText: 'Mot de passe',
                                  border: OutlineInputBorder(),
                                ),
                                obscureText: true,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Veuillez entrer un mot de passe.';
                                  }
                                  return null;
                                },
                              ),
                              SizedBox(height: 20),
                              _isLoading
                                  ? CircularProgressIndicator()
                                  : ElevatedButton(
                                onPressed: _login,
                                child: Text('Se connecter'),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}