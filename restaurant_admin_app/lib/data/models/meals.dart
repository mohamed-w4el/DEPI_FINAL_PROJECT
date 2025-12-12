// To parse this JSON data, do
//
//     final meals = mealsFromJson(jsonString);

import 'dart:convert';

List<Meals> mealsFromJson(String str) =>
    List<Meals>.from(json.decode(str).map((x) => Meals.fromJson(x)));

String mealsToJson(List<Meals> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Meals {
  final int mealId;
  final String nameAr;
  final String nameEn;
  final String descriptionAr;
  final String descriptionEn;
  final String imageUrl;

  Meals({
    required this.mealId,
    required this.nameAr,
    required this.nameEn,
    required this.descriptionAr,
    required this.descriptionEn,
    required this.imageUrl,
  });

  factory Meals.fromJson(Map<String, dynamic> json) => Meals(
    mealId: json["meal_id"],
    nameAr: json["name_ar"],
    nameEn: json["name_en"],
    descriptionAr: json["description_ar"],
    descriptionEn: json["description_en"],
    imageUrl: json["image_url"],
  );

  Map<String, dynamic> toJson() => {
    "meal_id": mealId,
    "name_ar": nameAr,
    "name_en": nameEn,
    "description_ar": descriptionAr,
    "description_en": descriptionEn,
    "image_url": imageUrl,
  };
}
