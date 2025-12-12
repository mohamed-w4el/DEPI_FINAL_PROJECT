import 'package:flutter/material.dart';
import '../../main.dart';
import '../models/meal_model.dart';

class RestaurantService {
  /// Load all meals with id, image, name, description
  Future<List<Meal>> loadMeals() async {
    try {
      final response = await cloud
          .from('meals')
          .select('meal_id, name_en, image_url, description_en');

      final list = (response as List<dynamic>)
          .map((e) => Meal.fromMap(e))
          .toList();

      return list;
    } catch (e) {
      debugPrint('Error loading meals: $e');
      return [];
    }
  }

  /// Send review to Supabase
  Future<bool> sendReview({
    required int mealId,
    required double serviceRating,
    required double foodRating,
    required double overallRating,
    required String comments,
    required String recommend,
  }) async {
    try {
      await cloud.from('reviews').insert({
        'meal_id': mealId,
        'dish_rate': foodRating.toInt(),
        'service_rate': serviceRating.toInt(),
        'overall_experience_rate': overallRating.toInt(),
        'comment': comments,
        'recommend us': recommend, // Better column name
        'created_at': DateTime.now().toIso8601String(),
      });

      return true;
    } catch (e) {
      debugPrint('Error sending review: $e');
      return false;
    }
  }
}
