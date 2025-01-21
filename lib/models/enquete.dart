class MobileData {
  final String? nom;
  final String? prenom;
  final String? sexe;
  final String? telephone;
  final String? dateNaissance;
  final String? lieuNaissance;
  final String? fonction;
  final int? tailleDuFoyer;
  final int? nombreDependants;
  final String? evenementsClimatiques;
  final double? longitude;
  final double? latitude;

  MobileData({
    this.nom,
    this.prenom,
    this.sexe,
    this.telephone,
    this.dateNaissance,
    this.lieuNaissance,
    this.fonction,
    this.tailleDuFoyer,
    this.nombreDependants,
    this.evenementsClimatiques,
    this.longitude,
    this.latitude,
  });

  Map<String, dynamic> toJson() {
    return {
      "nom": nom,
      "prenom": prenom,
      "sexe": sexe,
      "telephone": telephone,
      "date_naissance": dateNaissance,
      "lieu_naissance": lieuNaissance,
      "fonction": fonction,
      "taille_du_foyer": tailleDuFoyer,
      "nombre_dependants": nombreDependants,
      "evenements_climatiques": evenementsClimatiques,
      "longitude": longitude,
      "latitude": latitude,
    };
  }
}