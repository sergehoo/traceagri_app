class Formulaire {
  final int id;
  final String name;
  final String description;

  Formulaire({required this.id, required this.name, required this.description});

  // Convertir les données JSON en objet Formulaire
  factory Formulaire.fromJson(Map<String, dynamic> json) {
    return Formulaire(
      id: json['id'],
      name: json['name'],
      description: json['description'],
    );
  }

  // Convertir l'objet Formulaire en Map pour SQLite
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'description': description,
    };
  }
}