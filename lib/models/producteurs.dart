class Producteur {
  final int id;
  final String nom;
  final String prenom;
  final String sexe;
  final String telephone;
  final bool isSynced;

  Producteur({
    required this.id,
    required this.nom,
    required this.prenom,
    required this.sexe,
    required this.telephone,
    this.isSynced = false,
  });

  // Convertir en Map pour SQLite
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nom': nom,
      'prenom': prenom,
      'sexe': sexe,
      'telephone': telephone,
      'isSynced': isSynced ? 1 : 0,
    };
  }

  // Convertir depuis Map pour SQLite
  static Producteur fromMap(Map<String, dynamic> map) {
    return Producteur(
      id: map['id'],
      nom: map['nom'],
      prenom: map['prenom'],
      sexe: map['sexe'],
      telephone: map['telephone'],
      isSynced: map['isSynced'] == 1,
    );
  }
}