import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:restaurant_admin_app/data/models/meals.dart';
import 'package:restaurant_admin_app/data/models/reviews.dart';

class MealAnalyticsController extends GetxController {
  final meal = Rx<Meals?>(null);
  final mealReviews = <Reviews>[].obs;
  final allReviews = <Reviews>[].obs;
  final isLoading = true.obs;

  // Statistics
  final averageDishRating = 0.0.obs;
  final averageServiceRating = 0.0.obs;
  final averageOverallRating = 0.0.obs;
  final recommendPercentage = 0.0.obs;
  final reviewsCount = 0.obs;
  final averageTotalRating = 0.0.obs;

  // Rating distributions
  final dishRatingDistribution = <int, int>{1: 0, 2: 0, 3: 0, 4: 0, 5: 0}.obs;
  final serviceRatingDistribution = <int, int>{
    1: 0,
    2: 0,
    3: 0,
    4: 0,
    5: 0,
  }.obs;
  final overallRatingDistribution = <int, int>{
    1: 0,
    2: 0,
    3: 0,
    4: 0,
    5: 0,
  }.obs;

  @override
  void onInit() {
    super.onInit();
    loadData();
  }

  void loadData() {
    final mealData = Get.arguments['meal'] as Meals?;
    final reviewsData = Get.arguments['reviews'] as List<Reviews>?;

    if (mealData != null) {
      meal.value = mealData;
    }

    if (reviewsData != null) {
      allReviews.value = reviewsData;
      mealReviews.value = allReviews
          .where((r) => r.mealId == meal.value!.mealId)
          .toList();
      calculateStatistics();
    }

    isLoading.value = false;
  }

  void calculateStatistics() {
    reviewsCount.value = mealReviews.length;

    if (mealReviews.isEmpty) return;

    // Calculate average ratings
    double dishTotal = 0;
    double serviceTotal = 0;
    double overallTotal = 0;
    int recommendCount = 0;

    // Reset distributions
    dishRatingDistribution.value = {1: 0, 2: 0, 3: 0, 4: 0, 5: 0};
    serviceRatingDistribution.value = {1: 0, 2: 0, 3: 0, 4: 0, 5: 0};
    overallRatingDistribution.value = {1: 0, 2: 0, 3: 0, 4: 0, 5: 0};

    for (final review in mealReviews) {
      // Dish rating
      dishTotal += review.dishRate;
      dishRatingDistribution.update(
        review.dishRate,
        (value) => value + 1,
        ifAbsent: () => 1,
      );

      // Service rating
      serviceTotal += review.serviceRate;
      serviceRatingDistribution.update(
        review.serviceRate,
        (value) => value + 1,
        ifAbsent: () => 1,
      );

      // Overall rating
      overallTotal += review.overallExperienceRate;
      overallRatingDistribution.update(
        review.overallExperienceRate,
        (value) => value + 1,
        ifAbsent: () => 1,
      );

      // Recommendation
      if (review.recommendUs.toLowerCase() == 'yes') {
        recommendCount++;
      }
    }

    averageDishRating.value = dishTotal / mealReviews.length;
    averageServiceRating.value = serviceTotal / mealReviews.length;
    averageOverallRating.value = overallTotal / mealReviews.length;
    averageTotalRating.value =
        (averageDishRating.value +
            averageServiceRating.value +
            averageOverallRating.value) /
        3.0;
    recommendPercentage.value = (recommendCount / mealReviews.length) * 100;
  }

  // Get rating percentage for pie charts
  List<Map<String, dynamic>> getRatingDistributionForChart() {
    final List<Map<String, dynamic>> data = [];

    for (int i = 1; i <= 5; i++) {
      final dishCount = dishRatingDistribution[i] ?? 0;
      final serviceCount = serviceRatingDistribution[i] ?? 0;
      final overallCount = overallRatingDistribution[i] ?? 0;

      // Total count for this star rating across all categories
      final totalCount = dishCount + serviceCount + overallCount;

      data.add({
        'rating': i,
        'count': totalCount,
        'dishCount': dishCount,
        'serviceCount': serviceCount,
        'overallCount': overallCount,
        'label': '$i ${'star${i > 1 ? 's' : ''}'.tr}',
        'color': _getRatingColor(i),
      });
    }

    return data;
  }

  // Get comparison data with all meals
  Map<String, dynamic> getComparisonData() {
    if (mealReviews.isEmpty) return {};

    // Calculate averages for all meals
    double allDishTotal = 0;
    double allServiceTotal = 0;
    double allOverallTotal = 0;
    int allReviewsCount = 0;
    int allRecommendCount = 0;

    for (final review in allReviews) {
      allDishTotal += review.dishRate;
      allServiceTotal += review.serviceRate;
      allOverallTotal += review.overallExperienceRate;
      allReviewsCount++;

      if (review.recommendUs.toLowerCase() == 'yes') {
        allRecommendCount++;
      }
    }

    final double allDishAvg = allReviewsCount > 0
        ? allDishTotal / allReviewsCount
        : 0;
    final double allServiceAvg = allReviewsCount > 0
        ? allServiceTotal / allReviewsCount
        : 0;
    final double allOverallAvg = allReviewsCount > 0
        ? allOverallTotal / allReviewsCount
        : 0;
    final double allRecommendPercent = allReviewsCount > 0
        ? (allRecommendCount / allReviewsCount) * 100
        : 0;

    return {
      'dishComparison': averageDishRating.value - allDishAvg,
      'serviceComparison': averageServiceRating.value - allServiceAvg,
      'overallComparison': averageOverallRating.value - allOverallAvg,
      'recommendComparison': recommendPercentage.value - allRecommendPercent,
    };
  }

  Color _getRatingColor(int rating) {
    switch (rating) {
      case 1:
        return Colors.red;
      case 2:
        return Colors.orange;
      case 3:
        return Colors.yellow[700]!;
      case 4:
        return Colors.lightGreen;
      case 5:
        return Colors.green;
      default:
        return Colors.grey;
    }
  }

  // Get performance indicator
  String getPerformanceIndicator() {
    if (averageTotalRating.value >= 4.0) return 'Excellent';
    if (averageTotalRating.value >= 3.0) return 'Good';
    if (averageTotalRating.value >= 2.0) return 'Average';
    return 'Needs Improvement';
  }

  Color getPerformanceColor() {
    if (averageTotalRating.value >= 4.0) return Colors.green;
    if (averageTotalRating.value >= 3.0) return Colors.lightGreen;
    if (averageTotalRating.value >= 2.0) return Colors.orange;
    return Colors.red;
  }

  @override
  void onClose() {
    meal.close();
    mealReviews.close();
    allReviews.close();
    isLoading.close();
    averageDishRating.close();
    averageServiceRating.close();
    averageOverallRating.close();
    recommendPercentage.close();
    reviewsCount.close();
    averageTotalRating.close();
    super.onClose();
  }
}
