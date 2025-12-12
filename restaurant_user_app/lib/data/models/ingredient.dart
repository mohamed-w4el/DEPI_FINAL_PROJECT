class Ingredient {
  final int id;
  final String nameEn;
  final String nameAr;

  Ingredient({required this.id, required this.nameEn, required this.nameAr});

  factory Ingredient.fromJson(Map<String, dynamic> json) {
    return Ingredient(
      id: json['ing_id'],
      nameEn: json['name_en'],
      nameAr: json['name_ar'],
    );
  }
}
