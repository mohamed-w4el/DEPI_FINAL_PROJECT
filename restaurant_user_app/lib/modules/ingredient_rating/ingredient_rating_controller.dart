import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:restaurant_user_app/data/models/ingredient.dart';
import 'package:restaurant_user_app/data/models/user.dart';
import 'package:restaurant_user_app/data/services/restaurant_service.dart';

class IngredientRatingController extends GetxController {
  final RestaurantService service = RestaurantService();

  late int mealId;

  final user = Get.arguments['user'] as User?;

  final ingredients = <Ingredient>[].obs;
  final ratings = <int, int>{}.obs; // Map of ingredient id and rate

  final isLoading = true.obs;

  @override
  void onInit() {
    loadIngredients();
    super.onInit();
  }

  Future<void> loadIngredients() async {
    try {
      mealId = Get.arguments['meal_id'] as int;

      isLoading.value = true;

      final ingList = await service.getIngredientsForMeal(mealId);
      ingredients.assignAll(ingList);

      // Initialize all ratings to 0
      for (final ing in ingList) {
        ratings[ing.id] = 0;
      }
    } finally {
      isLoading.value = false;
    }
  }

  void updateRating(int ingredientId, int value) {
    ratings[ingredientId] = value;
  }

  Future<void> submitRatings() async {
    // Check if all ingredients are rated (rating > 0)
    for (var ingredient in ingredients) {
      final rating = ratings[ingredient.id];
      if (rating == null || rating == 0) {
        Get.snackbar(
          'missing_ratings'.tr,
          '',
          backgroundColor: Colors.orange,
          colorText: Colors.white,
        );
        return;
      }
    }

    // Calculate average rating before submitting
    double totalRating = 0.0;
    for (var ingredient in ingredients) {
      totalRating += ratings[ingredient.id]!;
    }
    final averageRating = totalRating / ingredients.length;

    bool allSuccess = true;
    for (var ingredient in ingredients) {
      allSuccess = await service.submitIngredientRating(
        ingredientId: ingredient.id,
        mealId: mealId,
        userId: user?.id,
        rating: ratings[ingredient.id]!,
      );
      // if (!success) allSuccess = false;
    }

    if (allSuccess) {
      // If user exists add 10 points to him.
      if (user != null) {
        await service.updateUserPoints(user!.id);
      }

      if (averageRating > 2.5) {
        Get.snackbar(
          'thank_you'.tr,
          'positive_feedback'.tr,
          colorText: Colors.white,
          backgroundColor: Colors.green,
          duration: const Duration(seconds: 2),
        );
      } else {
        Get.snackbar(
          'we_apologize'.tr,
          'negative_feedback'.tr,
          colorText: Colors.white,
          backgroundColor: Colors.orange.shade900,
          duration: const Duration(seconds: 2),
        );
      }
    } else {
      // Show error message if submission failed
      Get.snackbar(
        'error'.tr,
        'failed_submission'.tr,
        colorText: Colors.white,
        backgroundColor: Colors.red,
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 2),
      );
    }
  }

  @override
  void onClose() {
    ingredients.close();
    ratings.close();
    isLoading.close();
    super.onClose();
  }
}
