import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:restaurant_user_app/data/models/ingredient.dart';
import 'package:restaurant_user_app/data/models/meal_model.dart';
import 'package:restaurant_user_app/data/models/user.dart';
import 'package:restaurant_user_app/main.dart';

class RestaurantService {
  Future<User> upsertUserByPhone(String phoneNo) async {
    try {
      final response = await supabase
          .from('user')
          .select('id, phone_no, points')
          .eq('phone_no', phoneNo)
          .maybeSingle();

      var newUser;

      if (response == null) {
        // User does not exist. Add as a new one.
        newUser = await supabase
            .from('user')
            .insert({
              'phone_no': phoneNo,
              'points': 10,
              'created_at': DateTime.now().toIso8601String(),
            })
            .select('id, phone_no, points')
            .maybeSingle();
      }
      final user = response == null
          ? userFromJson(json.encode(newUser))
          : userFromJson(json.encode(response));

      return user;
    } catch (e) {
      debugPrint('Error in upsertUserByPhone: $e');
      rethrow;
    }
  }

  Future<void> updateUserPoints(int userId) async {
    try {
      print('userId: ${userId}');
      final response = await supabase
          .from('user')
          .select('points')
          .eq('id', userId)
          .single();

      final points = response['points'] as int;

      await supabase
          .from('user')
          .update({'points': points + 10})
          .eq('id', userId);
    } catch (e) {
      debugPrint('Error updating user points: $e');
    }
  }

  /// Load all meals with id, image, name, description
  Future<List<Meal>> loadMeals() async {
    try {
      final response = await supabase.from('meals').select();

      final meals = mealsFromJson(json.encode(response));

      return meals;
    } catch (e) {
      debugPrint('Error loading meals: $e');
      return [];
    }
  }

  /// Send review to Supabase
  Future<bool> sendReview({
    required int? userId,
    required int mealId,
    required double serviceRating,
    required double foodRating,
    required double overallRating,
    required String comments,
    required String recommend,
  }) async {
    try {
      await supabase.from('reviews').insert({
        'user_id': userId,
        'meal_id': mealId,
        'dish_rate': foodRating.toInt(),
        'service_rate': serviceRating.toInt(),
        'overall_experience_rate': overallRating.toInt(),
        'comment': comments,
        'recommend_us': recommend, // Better column name
        'created_at': DateTime.now().toIso8601String(),
      });

      return true;
    } catch (e) {
      debugPrint('Error sending review: $e');
      return false;
    }
  }

  Future<List<Ingredient>> getIngredientsForMeal(int mealId) async {
    try {
      final response = await supabase.rpc(
        'get_ingredients_for_meal',
        params: {'mealid': mealId},
      );

      final ingredients = (response as List<dynamic>)
          .map((e) => Ingredient.fromJson(e))
          .toList();

      return ingredients;
    } catch (e) {
      debugPrint('Error loading meals: $e');
      return [];
    }
  }

  Future<bool> submitIngredientRating({
    required int ingredientId,
    required int mealId,
    required int? userId,
    required int rating,
  }) async {
    try {
      await supabase.from('ingredient_reviews').insert({
        'ingredient_id': ingredientId,
        'meal_id': mealId,
        'user_id': userId,
        'rating': rating,
        'created_at': DateTime.now().toIso8601String(),
      });
      return true;
    } catch (e) {
      print(e);
      return false;
    }
  }
}
