

class Parcelle {
  final String nom;
  final String localiteName;
  final String dimensionHa;
  final String producteurName;
  final String image;

  Parcelle({
    required this.nom,
    required this.localiteName,
    required this.dimensionHa,
    required this.producteurName,
    required this.image,
  });

  factory Parcelle.fromJson(Map<String, dynamic> json) {
    return Parcelle(
      nom: json['nom'] ?? 'Nom inconnu',
      localiteName: json['localite_name'] ?? 'Localité inconnue',
      dimensionHa: json['dimension_ha'] ?? '0.0',
      producteurName: json['producteur_name'] ?? 'Producteur inconnu',
      image: json['images'] ?? '',
    );
  }
}