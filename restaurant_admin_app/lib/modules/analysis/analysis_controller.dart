import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:restaurant_admin_app/data/models/meal_review_stats.dart';
import 'package:restaurant_admin_app/data/models/meals.dart';
import 'package:restaurant_admin_app/data/models/rating_stats.dart';
import 'package:restaurant_admin_app/data/models/recommend_stats.dart';
import 'package:restaurant_admin_app/data/models/reviews.dart';
import 'package:restaurant_admin_app/data/services/admin_services.dart';

class AnalysisController extends GetxController {
  final adminService = AdminService();

  final reviews = <Reviews>[].obs;
  final meals = <Meals>[].obs;
  final isLoading = true.obs;
  final ratingStats = <RatingStats>[].obs;
  final recommendStats = <RecommendStats>[].obs;
  final mealStats = <MealReviewStats>[].obs;

  @override
  void onInit() {
    super.onInit();
    loadReviewData();
  }

  void loadReviewData() {
    try {
      isLoading.value = true;

      // Load meals data
      final mealsResponse = Get.arguments['meals'] as List<Meals>?;
      if (mealsResponse != null) {
        meals.value = mealsResponse;
      }

      // Load reviews data
      final reviewsResponse = Get.arguments['reviews'] as List<Reviews>?;
      if (reviewsResponse != null) {
        reviews.value = reviewsResponse;
      }

      _calculateStats();
    } catch (e) {
      debugPrint('Error loading review data: $e');
      Get.snackbar(
        'Error',
        'Failed to load analytics data',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
  }

  void _calculateStats() {
    if (reviews.isEmpty) return;

    // Calculate average ratings
    final foodRatings = reviews.map((r) => r.dishRate.toDouble()).toList();
    final serviceRatings = reviews
        .map((r) => r.serviceRate.toDouble())
        .toList();
    final overallRatings = reviews
        .map((r) => r.overallExperienceRate.toDouble())
        .toList();

    ratingStats.value = [
      RatingStats(
        category: 'Food',
        averageRating: _calculateAverage(foodRatings),
        totalReviews: reviews.length,
      ),
      RatingStats(
        category: 'Service',
        averageRating: _calculateAverage(serviceRatings),
        totalReviews: reviews.length,
      ),
      RatingStats(
        category: 'Overall Experience',
        averageRating: _calculateAverage(overallRatings),
        totalReviews: reviews.length,
      ),
    ];

    // Calculate recommendation stats
    final yesCount = reviews
        .where((r) => (r.recommendUs.toLowerCase()) == 'yes')
        .length;
    final noCount = reviews.length - yesCount;

    recommendStats.value = [
      RecommendStats(
        answer: 'Yes',
        count: yesCount,
        percentage: reviews.isEmpty ? 0 : (yesCount / reviews.length * 100),
      ),
      RecommendStats(
        answer: 'No',
        count: noCount,
        percentage: reviews.isEmpty ? 0 : (noCount / reviews.length * 100),
      ),
    ];

    // Calculate meal stats (associating by index)
    _calculateMealStats();
  }

  void _calculateMealStats() {
    final mealStatsList = <MealReviewStats>[];

    for (final meal in meals) {
      // Find all reviews for this specific meal using mealId
      final mealReviews = reviews
          .where((r) => r.mealId == meal.mealId)
          .toList();

      if (mealReviews.isNotEmpty) {
        final averageRating =
            mealReviews
                .map((r) => r.dishRate.toDouble())
                .reduce((a, b) => a + b) /
            mealReviews.length;

        mealStatsList.add(
          MealReviewStats(
            mealNameEn: meal.nameEn,
            mealNameAr: meal.nameAr,
            reviewCount: mealReviews.length,
            averageRating: double.parse(averageRating.toStringAsFixed(1)),
          ),
        );
      }
    }

    // Sort by review count descending
    mealStatsList.sort((a, b) => b.reviewCount.compareTo(a.reviewCount));
    mealStats.value = mealStatsList;
  }

  double _calculateAverage(List<double> ratings) {
    if (ratings.isEmpty) return 0;
    return double.parse(
      (ratings.reduce((a, b) => a + b) / ratings.length).toStringAsFixed(1),
    );
  }

  @override
  void onClose() {
    reviews.close();
    meals.close();
    isLoading.close();
    ratingStats.close();
    recommendStats.close();
    mealStats.close();
    super.onClose();
  }
}
