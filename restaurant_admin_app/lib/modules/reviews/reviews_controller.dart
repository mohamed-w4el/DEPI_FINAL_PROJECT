import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:restaurant_admin_app/data/models/meals.dart';
import 'package:restaurant_admin_app/data/models/reviews.dart';
import 'package:restaurant_admin_app/data/services/admin_services.dart';

class ReviewsController extends GetxController {
  final adminService = AdminService();

  final meals = <Meals>[].obs;
  final reviews = <Reviews>[].obs;
  final filteredReviews = <Reviews>[].obs;
  final isLoading = true.obs;

  final selectedFilter = 'All'.obs; // 'All' , 'High' , 'Low'

  @override
  void onInit() {
    super.onInit();
    loadAllMeals();
    loadAllReviews();
  }

  void loadAllMeals() {
    final data = Get.arguments['meals'] as List<Meals>?;
    if (data != null) {
      meals.value = data;
    }
  }

  void loadAllReviews() {
    final data = Get.arguments['reviews'] as List<Reviews>?;
    if (data != null) {
      reviews.value = data;
      filteredReviews.value = reviews;
      isLoading.value = false;
    }
  }

  // Helper method to calculate average rating for a review
  double _calculateAverageRating(Reviews review) {
    return (review.dishRate +
            review.serviceRate +
            review.overallExperienceRate) /
        3.0;
  }

  // Apply filter based on selected option
  void applyFilter(String filterType) {
    selectedFilter.value = filterType;

    switch (filterType) {
      case 'High':
        // Filter for high reviews (average > 2.5, since rating is 1-5)
        filteredReviews.value = reviews.where((review) {
          final average = _calculateAverageRating(review);
          return average > 2.5;
        }).toList();
        break;
      case 'Low':
        // Filter for low reviews (average <= 2.5)
        filteredReviews.value = reviews.where((review) {
          final average = _calculateAverageRating(review);
          return average <= 2.5;
        }).toList();
        break;
      case 'All':
      default:
        // Show all reviews
        filteredReviews.value = reviews;
        break;
    }
  }

  // Get count statistics for each filter
  int getHighReviewsCount() {
    return reviews.where((review) {
      final average = _calculateAverageRating(review);
      return average > 2.5;
    }).length;
  }

  int getLowReviewsCount() {
    return reviews.where((review) {
      final average = _calculateAverageRating(review);
      return average <= 2.5;
    }).length;
  }

  Widget buildRatingStars(int rating) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(5, (index) {
        return Icon(
          index < rating ? Icons.star : Icons.star_border,
          color: Colors.orangeAccent,
          size: 24,
        );
      }),
    );
  }

  Color getRecommendColor(String recommend) {
    return recommend.toLowerCase() == 'yes' ? Colors.green : Colors.red;
  }

  @override
  void onClose() {
    reviews.close();
    filteredReviews.close();
    meals.close();
    isLoading.close();
    selectedFilter.close();
    super.onClose();
  }
}
