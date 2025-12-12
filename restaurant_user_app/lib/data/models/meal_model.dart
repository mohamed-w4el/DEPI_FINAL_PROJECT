// To parse this JSON data, do
//
//     final meals = mealsFromJson(jsonString);

import 'package:meta/meta.dart';
import 'dart:convert';

List<Meal> mealsFromJson(String str) =>
    List<Meal>.from(json.decode(str).map((x) => Meal.fromJson(x)));

String mealsToJson(List<Meal> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Meal {
  final int mealId;
  final String nameAr;
  final String nameEn;
  final String descriptionAr;
  final String descriptionEn;
  final String imageUrl;

  Meal({
    required this.mealId,
    required this.nameAr,
    required this.nameEn,
    required this.descriptionAr,
    required this.descriptionEn,
    required this.imageUrl,
  });

  factory Meal.fromJson(Map<String, dynamic> json) => Meal(
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
