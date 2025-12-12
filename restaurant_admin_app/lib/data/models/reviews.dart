// To parse this JSON data, do
//
//     final reviews = reviewsFromJson(jsonString);

import 'package:meta/meta.dart';
import 'dart:convert';

List<Reviews> reviewsFromJson(String str) =>
    List<Reviews>.from(json.decode(str).map((x) => Reviews.fromJson(x)));

String reviewsToJson(List<Reviews> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Reviews {
  final int revId;
  final int mealId;
  final int dishRate;
  final int serviceRate;
  final int overallExperienceRate;
  final String comment;
  final String recommendUs;
  final DateTime createdAt;

  Reviews({
    required this.revId,
    required this.mealId,
    required this.dishRate,
    required this.serviceRate,
    required this.overallExperienceRate,
    required this.comment,
    required this.recommendUs,
    required this.createdAt,
  });

  factory Reviews.fromJson(Map<String, dynamic> json) => Reviews(
    revId: json["rev_id"],
    mealId: json["meal_id"],
    dishRate: json["dish_rate"],
    serviceRate: json["service_rate"],
    overallExperienceRate: json["overall_experience_rate"],
    comment: json["comment"],
    recommendUs: json["recommend_us"],
    createdAt: DateTime.parse(json["created_at"]),
  );

  Map<String, dynamic> toJson() => {
    "rev_id": revId,
    "meal_id": mealId,
    "dish_rate": dishRate,
    "service_rate": serviceRate,
    "overall_experience_rate": overallExperienceRate,
    "comment": comment,
    "recommend_us": recommendUs,
    "created_at": createdAt.toIso8601String(),
  };
}
