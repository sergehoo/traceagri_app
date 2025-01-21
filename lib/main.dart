import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:traceagri_app/screens/enquete_form_screen.dart';
import 'services/api_service.dart';
import 'services/database_service.dart';
import 'screens/home_screen.dart';
import 'screens/login_screen.dart';
import 'screens/parcelles_screen.dart';
import 'screens/producteurs_screen.dart';
import 'screens/synchronisees_screen.dart';
import 'screens/non_synchronisees_screen.dart';
import 'screens/en_attente_screen.dart';
// import 'screens/mobile_data_form_screen.dart';
import 'screens/liste_total_reccord.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialisation de la base de données
  await DatabaseService().database;

  // Vérification de l'état de connexion
  final ApiService apiService = ApiService();
  final bool isLoggedIn = await apiService.isUserLoggedIn();

  runApp(MyApp(initialRoute: isLoggedIn ? '/home' : '/login'));
}

class MyApp extends StatelessWidget {
  final String initialRoute;

  MyApp({required this.initialRoute});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'TraceAgri App',
      theme: ThemeData(primarySwatch: Colors.green),
      initialRoute: initialRoute,
      onGenerateRoute: (settings) {
        if (settings.name == '/home') {
          final args = settings.arguments as Map<String, dynamic>?; // Nullable check
          return MaterialPageRoute(
            builder: (context) => HomeScreen(
              username: args?['username'] ?? 'Utilisateur', // Default value
              donneesSynchronisees: args?['donneesSynchronisees'] ?? 0, // Default to 0
            ),
          );
        }
        if (settings.name == '/parcelles') {
          return MaterialPageRoute(builder: (context) => ParcellesScreen());
        }
        if (settings.name == '/producteurs') {
          return MaterialPageRoute(builder: (context) => ProducteursScreen());
        }
        if (settings.name == '/synchronisees') {
          return MaterialPageRoute(builder: (context) => SynchroniseesScreen());
        }
        if (settings.name == '/nonSynchronisees') {
          return MaterialPageRoute(builder: (context) => NonSynchroniseesScreen());
        }
        if (settings.name == '/enAttente') {
          return MaterialPageRoute(builder: (context) => EnAttenteScreen());
        }
        if (settings.name == '/mobileDataForm') {
          return MaterialPageRoute(builder: (context) => MobileDataFormScreen());
        }
        if (settings.name == '/allDataReccord') {
          return MaterialPageRoute(builder: (context) => ListeDonneesSaisiesScreen());
        }
        return MaterialPageRoute(builder: (context) => LoginScreen());
      },
    );
  }
}