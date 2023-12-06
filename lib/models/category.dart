class TCategory {
  int? id;
  String? name;

  TCategory({
    this.id,
    this.name,
  });

  // Convertir un objet Category en Map
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
    };
  }

  // Créer un objet Category à partir d'un Map
  static TCategory fromMap(Map<String, dynamic> map) {
    return TCategory(
      id: map['id'],
      name: map['name'],
    );
  }

  @override
  String toString() {
    return name!;
  }
}
