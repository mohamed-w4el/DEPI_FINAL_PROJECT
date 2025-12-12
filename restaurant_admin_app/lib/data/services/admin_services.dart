import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:restaurant_admin_app/data/models/meals.dart';
import 'package:restaurant_admin_app/data/models/reviews.dart';
import 'package:restaurant_admin_app/main.dart';

class AdminService {
  Future<List<Meals>?> loadMeals() async {
    try {
      final response = await supabase.from('meals').select();

      // print(json.encode(response));
      final meals = mealsFromJson(json.encode(response));

      return meals;
    } catch (e) {
      debugPrint('Error loading meals: $e');
      return null;
    }
  }

  Future<List<Reviews>?> loadReviews() async {
    try {
      final response = await supabase
          .from('reviews')
          .select(
            'rev_id, meal_id, dish_rate, service_rate, overall_experience_rate, comment, recommend_us, created_at',
          )
          .order('created_at', ascending: false);
      // print('json reviews: ${json.encode(response)}');

      final reviews = reviewsFromJson(json.encode(response));

      // print('reviews: ${reviews}');
      return reviews;
    } catch (e) {
      debugPrint('Error loading reviews: $e');
      return null;
    }
  }
}
