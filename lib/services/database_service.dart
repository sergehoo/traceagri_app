import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseService {
  static final DatabaseService _instance = DatabaseService._internal();
  static Database? _database;

  DatabaseService._internal();

  factory DatabaseService() => _instance;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final path = join(await getDatabasesPath(), 'traceagri.db');
    return openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        // Création des tables pour producteurs et parcelles
        await db.execute('''
          CREATE TABLE mobile_data (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            nom TEXT,
            prenom TEXT,
            sexe TEXT,
            telephone TEXT,
            date_naissance TEXT,
            lieu_naissance TEXT,
            photo TEXT,
            fonction TEXT,
            localite TEXT,
            taille_du_foyer INTEGER,
            nombre_dependants INTEGER,
            cultures_precedentes TEXT,
            annee_cultures_precedentes TEXT,
            evenements_climatiques TEXT,
            commentaires TEXT,
            nom_parcelle TEXT,
            dimension_ha REAL,
            longitude REAL,
            latitude REAL,
            category TEXT,
            type_culture TEXT,
            nom_culture TEXT,
            description TEXT,
            pratiques_culturales TEXT,
            utilise_fertilisants INTEGER DEFAULT 0,
            type_fertilisants TEXT,
            analyse_sol INTEGER DEFAULT 0,
            autre_culture TEXT,
            autre_culture_nom TEXT,
            autre_culture_volume_ha INTEGER,
            nom_cooperative TEXT,
            ville TEXT,
            specialites TEXT,
            is_president INTEGER DEFAULT 0,
            projet TEXT,
            horodateur TEXT,
            created_at TEXT,
            updated_at TEXT,
            validate INTEGER DEFAULT 0,
            validate_by TEXT,
            created_by TEXT,
            updated_by TEXT,
            is_synced INTEGER DEFAULT 0
          )
        ''');
        await db.execute('''
          CREATE TABLE producteurs (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            nom TEXT,
            prenom TEXT,
            sexe TEXT,
            telephone TEXT,
            date_naissance TEXT,
            lieu_naissance TEXT,
            taille_du_foyer INTEGER,
            nombre_dependants INTEGER,
            cultures_precedentes TEXT,
            annee_cultures_precedentes TEXT,
            commentaires TEXT,
            is_synced INTEGER DEFAULT 0
          )
        ''');

        await db.execute('''
          CREATE TABLE parcelles (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            nom_parcelle TEXT,
            dimension_ha REAL,
            longitude REAL,
            latitude REAL,
            category TEXT,
            type_culture TEXT,
            nom_culture TEXT,
            description TEXT,
            pratiques_culturales TEXT,
            utilise_fertilisants INTEGER DEFAULT 0,
            type_fertilisants TEXT,
            analyse_sol INTEGER DEFAULT 0,
            is_synced INTEGER DEFAULT 0
          )
        ''');
      },
        onUpgrade: (db, oldVersion, newVersion) async {
          if (oldVersion < newVersion) {
            // Migrations nécessaires (exemple ci-dessous)
            await db.execute('''
          CREATE TABLE IF NOT EXISTS mobile_data (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            nom TEXT,
            prenom TEXT,
            sexe TEXT,
            telephone TEXT,
            date_naissance TEXT,
            lieu_naissance TEXT,
            commentaires TEXT,
            horodateur TEXT,
            is_synced INTEGER DEFAULT 0
          )
        ''');
          }
        },
    );
  }

  Future<bool> doesTableExist(String tableName) async {
    final db = await database;
    final result = await db.rawQuery(
      "SELECT name FROM sqlite_master WHERE type='table' AND name=?",
      [tableName],
    );
    return result.isNotEmpty;
  }
  // Récupérer les parcelles non synchronisées
  Future<List<Map<String, dynamic>>> getUnsyncedParcelles() async {
    final db = await database;
    return db.query('parcelles', where: 'is_synced = ?', whereArgs: [0]);
  }

  Future<void> updateMobileData(int id, Map<String, dynamic> updatedData) async {
    final db = await database;

    print('ID : $id');
    print('Mise à jour des données : $updatedData');

    try {
      final result = await db.update(
        'mobile_data',
        updatedData,
        where: 'id = ?',
        whereArgs: [id],
      );

      if (result == 0) {
        throw Exception('Aucune ligne affectée. Vérifiez l\'ID.');
      } else {
        print('Mise à jour réussie pour ID : $id');
      }
    } catch (e) {
      print('Erreur lors de la mise à jour : $e');
      throw Exception('Erreur lors de la mise à jour des données.');
    }
  }
  // Récupérer le nombre de parcelles non synchronisées
  Future<int> countUnsyncedParcelles() async {
    final db = await database;
    final result = await db.rawQuery(
      'SELECT COUNT(*) AS count FROM parcelles WHERE is_synced = 0',
    );
    return Sqflite.firstIntValue(result) ?? 0;
  }

  // Insérer des données dans la table mobile_data
  Future<void> insertMobileData(Map<String, dynamic> data) async {
    final db = await database;
    await db.insert('mobile_data', data);
  }

  // Récupérer les données non synchronisées
  Future<List<Map<String, dynamic>>> getUnsyncedMobileData() async {
    final db = await database;
    return db.query('mobile_data', where: 'is_synced = ?', whereArgs: [0]);
  }

  // Marquer les données comme synchronisées
  Future<void> markMobileDataAsSynced(int id) async {
    final db = await database;
    await db.update(
      'mobile_data',
      {'is_synced': 1},
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // Marquer une parcelle comme synchronisée
  Future<void> markParcelleAsSynced(int id) async {
    final db = await database;
    await db.update(
      'parcelles',
      {'is_synced': 1},
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<List<Map<String, dynamic>>> getAllMobileData() async {
    final db = await database;
    return db.query('mobile_data');
  }

  Future<int> countUnsyncedMobileData() async {
    final db = await database;
    final result = await db.rawQuery(
      'SELECT COUNT(*) AS count FROM mobile_data WHERE is_synced = 0',
    );
    return Sqflite.firstIntValue(result) ?? 0;
  }

  Future<int> countSyncedMobileData() async {
    final db = await database;
    final result = await db.rawQuery(
      'SELECT COUNT(*) AS count FROM mobile_data WHERE is_synced = 1',
    );
    return Sqflite.firstIntValue(result) ?? 0;
  }

  Future<int> countTotalMobileData() async {
    final db = await database;
    final result = await db.rawQuery(
      'SELECT COUNT(*) AS count FROM mobile_data',
    );
    return Sqflite.firstIntValue(result) ?? 0;
  }

  // Ajouter une parcelle dans la base locale
  Future<void> insertParcelle(Map<String, dynamic> parcelle) async {
    final db = await database;
    await db.insert('parcelles', parcelle);
  }

  // Ajouter un producteur dans la base locale
  Future<void> insertProducteur(Map<String, dynamic> producteur) async {
    final db = await database;
    await db.insert('producteurs', producteur);
  }

  Future<List<Map<String, dynamic>>> getSyncedMobileData() async {
    final db = await database;
    return db.query('mobile_data', where: 'is_synced = ?', whereArgs: [1]);
  }

  // Récupérer les producteurs non synchronisés
  Future<List<Map<String, dynamic>>> getUnsyncedProducteurs() async {
    final db = await database;
    return db.query('producteurs', where: 'is_synced = ?', whereArgs: [0]);
  }

  // Marquer un producteur comme synchronisé
  Future<void> markProducteurAsSynced(int id) async {
    final db = await database;
    await db.update(
      'producteurs',
      {'is_synced': 1},
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}


// Future<void> resetDatabase() async {
//   final path = join(await getDatabasesPath(), 'traceagri.db');
//   await deleteDatabase(path); // Supprime la base de données existante
// }

