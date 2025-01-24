class MobileData {
  final int? id;
  final String? nom;
  final String? prenom;
  final String? sexe;
  final String? telephone;
  final String? dateNaissance;
  final String? lieuNaissance;
  final String? photo;
  final String? fonction;
  final String? localite;
  final int? tailleDuFoyer;
  final int? nombreDependants;
  final String? culturesPrecedentes;
  final String? anneeCulturesPrecedentes;
  final String? evenementsClimatiques;
  final String? commentaires;
  final String? nomParcelle;
  final double? dimensionHa;
  final double? longitude;
  final double? latitude;
  final String? category;
  final String? typeCulture;
  final String? nomCulture;
  final String? description;
  final String? pratiquesCulturales;
  final int? utiliseFertilisants;
  final String? typeFertilisants;
  final int? analyseSol;
  final String? autreCulture;
  final String? autreCultureNom;
  final int? autreCultureVolumeHa;
  final String? nomCooperative;
  final String? ville;
  final String? specialites;
  final int? isPresident;
  final String? projet;
  final String? horodateur;

  MobileData({
    this.id,
    this.nom,
    this.prenom,
    this.sexe,
    this.telephone,
    this.dateNaissance,
    this.lieuNaissance,
    this.photo,
    this.fonction,
    this.localite,
    this.tailleDuFoyer,
    this.nombreDependants,
    this.culturesPrecedentes,
    this.anneeCulturesPrecedentes,
    this.evenementsClimatiques,
    this.commentaires,
    this.nomParcelle,
    this.dimensionHa,
    this.longitude,
    this.latitude,
    this.category,
    this.typeCulture,
    this.nomCulture,
    this.description,
    this.pratiquesCulturales,
    this.utiliseFertilisants,
    this.typeFertilisants,
    this.analyseSol,
    this.autreCulture,
    this.autreCultureNom,
    this.autreCultureVolumeHa,
    this.nomCooperative,
    this.ville,
    this.specialites,
    this.isPresident,
    this.projet,
    this.horodateur,
  });

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "nom": nom,
      "prenom": prenom,
      "sexe": sexe,
      "telephone": telephone,
      "date_naissance": dateNaissance,
      "lieu_naissance": lieuNaissance,
      "photo": photo,
      "fonction": fonction,
      "localite": localite,
      "taille_du_foyer": tailleDuFoyer,
      "nombre_dependants": nombreDependants,
      "cultures_precedentes": culturesPrecedentes,
      "annee_cultures_precedentes": anneeCulturesPrecedentes,
      "evenements_climatiques": evenementsClimatiques,
      "commentaires": commentaires,
      "nom_parcelle": nomParcelle,
      "dimension_ha": dimensionHa,
      "longitude": longitude,
      "latitude": latitude,
      "category": category,
      "type_culture": typeCulture,
      "nom_culture": nomCulture,
      "description": description,
      "pratiques_culturales": pratiquesCulturales,
      "utilise_fertilisants": utiliseFertilisants,
      "type_fertilisants": typeFertilisants,
      "analyse_sol": analyseSol,
      "autre_culture": autreCulture,
      "autre_culture_nom": autreCultureNom,
      "autre_culture_volume_ha": autreCultureVolumeHa,
      "nom_cooperative": nomCooperative,
      "ville": ville,
      "specialites": specialites,
      "is_president": isPresident,
      "projet": projet,
      "horodateur": horodateur,
    };
  }
}