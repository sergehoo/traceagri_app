import 'package:flutter/material.dart';
import '../services/database_service.dart';

class HomeScreen extends StatefulWidget {
  final String username;

  HomeScreen({required this.username, required donneesSynchronisees});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final DatabaseService dbService = DatabaseService();

  Future<Map<String, int>> _fetchCounts() async {
    final unsyncedCount = await dbService.countUnsyncedMobileData();
    final syncedCount = await dbService.countSyncedMobileData();
    final totalCount = unsyncedCount + syncedCount;

    return {
      'total': totalCount,
      'synchronized': syncedCount,
      'unsynchronized': unsyncedCount,
    };
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Tableau de Bord'),
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () {
              Navigator.pushReplacementNamed(context, '/login');
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: FutureBuilder<Map<String, int>>(
          future: _fetchCounts(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Erreur : ${snapshot.error}'));
            } else if (!snapshot.hasData) {
              return Center(child: Text('Aucune donnée disponible.'));
            } else {
              final counts = snapshot.data!;
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Bonjour, ${widget.username}',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 20),
                  Expanded(
                    child: GridView.count(
                      crossAxisCount: 2,
                      crossAxisSpacing: 16,
                      mainAxisSpacing: 16,
                      children: [
                        _buildDashboardCard(
                          context: context,
                          title: 'Données totales enregistrées',
                          value: counts['total'].toString(),
                          icon: Icons.data_usage,
                          color: Colors.purple,
                          routeName: '/allDataReccord',
                        ),
                        _buildDashboardCard(
                          context: context,
                          title: 'Données synchronisées',
                          value: counts['synchronized'].toString(),
                          icon: Icons.sync,
                          color: Colors.teal,
                          routeName: '/synchronisees',
                        ),
                        _buildDashboardCard(
                          context: context,
                          title: 'Données non synchronisées',
                          value: counts['unsynchronized'].toString(),
                          icon: Icons.sync_problem,
                          color: Colors.red,
                          routeName: '/nonSynchronisees',
                        ),
                        _buildDashboardCard(
                          context: context,
                          title: 'Ajouter MobileData',
                          value: '+',
                          icon: Icons.add_circle_outline,
                          color: Colors.orange,
                          routeName: '/mobileDataForm',
                        ),
                      ],
                    ),
                  ),
                ],
              );
            }
          },
        ),
      ),
    );
  }

  Widget _buildDashboardCard({
    required BuildContext context,
    required String title,
    required String value,
    required IconData icon,
    required Color color,
    required String routeName,
  }) {
    return InkWell(
      onTap: () {
        Navigator.pushNamed(context, routeName);
      },
      child: Card(
        elevation: 5,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 40, color: color),
              SizedBox(height: 5),
              Text(
                title,
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 5),
              Text(
                value,
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
      ),
    );
  }
}