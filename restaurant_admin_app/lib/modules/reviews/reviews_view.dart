import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:restaurant_admin_app/modules/reviews/reviews_controller.dart';
import 'package:restaurant_admin_app/main.dart' as app;

class ReviewsView extends GetView<ReviewsController> {
  const ReviewsView({super.key});

  @override
  Widget build(BuildContext context) {
    final filteredReviews = controller.filteredReviews;
    final meals = controller.meals;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 4,
        toolbarHeight: 80,
        leading: IconButton(
          onPressed: () {
            Get.back();
          },
          icon: Icon(Icons.arrow_back_ios, color: Colors.grey, size: 30),
        ),
        title: Row(
          spacing: 16,
          children: [
            const Icon(Icons.reviews, color: Colors.orangeAccent, size: 40),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  "all_reviews".tr,
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1,
                  ),
                ),
              ],
            ),
          ],
        ),
        actions: [
          // Language switcher
          IconButton(
            icon: Text(
              Get.locale?.languageCode == 'en' ? 'AR' : 'EN',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 24,
                color: Colors.orangeAccent,
              ),
            ),
            onPressed: () async {
              await app.LocaleManager.toggleLocale();
            },
          ),

          // Filter Button in App Bar
          Obx(() => buildFilterDropdown()),
        ],
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(
            child: CircularProgressIndicator(color: Colors.orangeAccent),
          );
        }

        if (controller.reviews.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.reviews_outlined,
                  size: 80,
                  color: Colors.grey,
                ),
                const SizedBox(height: 16),
                Text(
                  'no_reviews_yet'.tr,
                  style: const TextStyle(fontSize: 30, color: Colors.grey),
                ),
                const SizedBox(height: 8),
                ElevatedButton(
                  onPressed: () {
                    controller.loadAllMeals();
                    controller.loadAllReviews();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orangeAccent,
                  ),
                  child: Text('refresh'.tr),
                ),
              ],
            ),
          );
        }

        return SafeArea(
          child: Column(
            children: [
              // Summary Cards
              Card(
                elevation: 6,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                margin: const EdgeInsets.all(16),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Column(
                        children: [
                          Text(
                            controller.reviews.length.toString(),
                            style: const TextStyle(
                              fontSize: 30,
                              fontWeight: FontWeight.bold,
                              color: Colors.orangeAccent,
                            ),
                          ),
                          Text(
                            'total_reviews'.tr,
                            style: const TextStyle(
                              color: Colors.grey,
                              fontSize: 24,
                            ),
                          ),
                        ],
                      ),
                      Column(
                        children: [
                          Text(
                            controller.getHighReviewsCount().toString(),
                            style: const TextStyle(
                              fontSize: 30,
                              fontWeight: FontWeight.bold,
                              color: Colors.green,
                            ),
                          ),
                          Text(
                            'high_reviews'.tr,
                            style: const TextStyle(
                              color: Colors.grey,
                              fontSize: 24,
                            ),
                          ),
                        ],
                      ),
                      Column(
                        children: [
                          Text(
                            controller.getLowReviewsCount().toString(),
                            style: const TextStyle(
                              fontSize: 30,
                              fontWeight: FontWeight.bold,
                              color: Colors.red,
                            ),
                          ),
                          Text(
                            'low_reviews'.tr,
                            style: const TextStyle(
                              color: Colors.grey,
                              fontSize: 24,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),

              // Filter Status Indicator
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'showing_reviews'.trParams({
                        'count': filteredReviews.length.toString(),
                      }),
                      style: const TextStyle(color: Colors.grey, fontSize: 24),
                    ),
                    Row(
                      children: [
                        Icon(
                          Icons.filter_alt,
                          size: 35,
                          color: getFilterColor(
                            controller.selectedFilter.value,
                          ),
                        ),
                        const SizedBox(width: 4),
                        Text(
                          '${controller.selectedFilter.value.toLowerCase().tr} ${'reviews'.tr}',
                          style: TextStyle(
                            color: getFilterColor(
                              controller.selectedFilter.value,
                            ),
                            fontWeight: FontWeight.bold,
                            fontSize: 24,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 8),

              // Reviews List
              Expanded(
                child: Card(
                  elevation: 6,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  margin: const EdgeInsets.symmetric(horizontal: 16),
                  child: filteredReviews.isEmpty
                      ? Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.filter_list_off,
                                size: 64,
                                color: Colors.grey[400],
                              ),
                              const SizedBox(height: 16),
                              Text(
                                'no_filtered_reviews'.trParams({
                                  'filter': controller.selectedFilter.value,
                                }),
                                style: const TextStyle(
                                  fontSize: 30,
                                  color: Colors.grey,
                                ),
                              ),
                              const SizedBox(height: 8),
                              TextButton(
                                onPressed: () => controller.applyFilter('All'),
                                child: Text(
                                  'show_all_reviews'.tr,
                                  style: const TextStyle(
                                    color: Colors.orangeAccent,
                                    fontSize: 24,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        )
                      : ListView.separated(
                          padding: const EdgeInsets.all(16),
                          itemCount: filteredReviews.length,
                          itemBuilder: (ctx, index) {
                            final review = filteredReviews[index];
                            final meal = meals.firstWhere(
                              (i) => i.mealId == review.mealId,
                            );

                            final averageRating =
                                (review.dishRate +
                                    review.serviceRate +
                                    review.overallExperienceRate) /
                                3.0;

                            return Card(
                              elevation: 2,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    // Meal Information
                                    buildMealInfo(
                                      meal.nameEn,
                                      meal.nameAr,
                                      meal.imageUrl,
                                    ),
                                    const SizedBox(height: 12),

                                    // Review Header
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          'review'.trParams({
                                            'number': (review.revId).toString(),
                                          }),
                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 24,
                                          ),
                                        ),
                                        Row(
                                          children: [
                                            // Average Rating Badge
                                            Container(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                    horizontal: 8,
                                                    vertical: 4,
                                                  ),
                                              decoration: BoxDecoration(
                                                color: averageRating > 2.5
                                                    ? Color(0xFFE5EAE8)
                                                    : Color(0xFFF5DFE5),
                                                borderRadius:
                                                    BorderRadius.circular(30),
                                                border: Border.all(
                                                  color: averageRating > 2.5
                                                      ? Colors.green
                                                      : Colors.red,
                                                  width: 1,
                                                ),
                                              ),
                                              child: Row(
                                                children: [
                                                  Icon(
                                                    averageRating > 2.5
                                                        ? Icons.trending_up
                                                        : Icons.trending_down,
                                                    size: 24,
                                                    color: averageRating > 2.5
                                                        ? Colors.green
                                                        : Colors.red,
                                                  ),
                                                  const SizedBox(width: 4),
                                                  Text(
                                                    averageRating
                                                        .toStringAsFixed(1),
                                                    style: TextStyle(
                                                      color: averageRating > 2.5
                                                          ? Colors.green
                                                          : Colors.red,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 24,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            const SizedBox(width: 16),
                                            Container(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                    horizontal: 12,
                                                    vertical: 4,
                                                  ),
                                              decoration: BoxDecoration(
                                                color: controller
                                                    .getRecommendColor(
                                                      review.recommendUs,
                                                    )
                                                    .withOpacity(0.1),
                                                borderRadius:
                                                    BorderRadius.circular(30),
                                                border: Border.all(
                                                  color: controller
                                                      .getRecommendColor(
                                                        review.recommendUs,
                                                      ),
                                                ),
                                              ),
                                              child: Text(
                                                review.recommendUs
                                                    .toLowerCase()
                                                    .tr,
                                                style: TextStyle(
                                                  fontSize: 24,
                                                  color: controller
                                                      .getRecommendColor(
                                                        review.recommendUs,
                                                      ),
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 12),

                                    // Ratings
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              'food'.tr,
                                              style: const TextStyle(
                                                fontSize: 24,
                                                color: Colors.grey,
                                              ),
                                            ),
                                            controller.buildRatingStars(
                                              review.dishRate,
                                            ),
                                          ],
                                        ),
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              'service'.tr,
                                              style: const TextStyle(
                                                fontSize: 24,
                                                color: Colors.grey,
                                              ),
                                            ),
                                            controller.buildRatingStars(
                                              review.serviceRate,
                                            ),
                                          ],
                                        ),
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              'overall'.tr,
                                              style: const TextStyle(
                                                fontSize: 24,
                                                color: Colors.grey,
                                              ),
                                            ),
                                            controller.buildRatingStars(
                                              review.overallExperienceRate,
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),

                                    // Comments
                                    if (review.comment.isNotEmpty) ...[
                                      const SizedBox(height: 12),
                                      Text(
                                        'comments'.tr,
                                        style: const TextStyle(
                                          fontSize: 24,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      Text(
                                        review.comment,
                                        style: TextStyle(fontSize: 30),
                                      ),
                                    ],

                                    // Date
                                    const SizedBox(height: 8),
                                    Text(
                                      '${'submitted'.tr} ${review.createdAt.toString().split(' ')[0]}',
                                      style: const TextStyle(
                                        fontSize: 20,
                                        color: Colors.grey,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                          separatorBuilder: (BuildContext context, int index) =>
                              const SizedBox(height: 12),
                        ),
                ),
              ),
            ],
          ),
        );
      }),
    );
  }

  // Build filter dropdown for app bar
  Widget buildFilterDropdown() {
    return PopupMenuButton<String>(
      icon: Row(
        children: [
          Icon(
            Icons.filter_list,
            color: getFilterColor(controller.selectedFilter.value),
            size: 30,
          ),
          const SizedBox(width: 4),
          Icon(
            Icons.arrow_drop_down,
            color: getFilterColor(controller.selectedFilter.value),
            size: 30,
          ),
        ],
      ),

      onSelected: (value) => controller.applyFilter(value),
      itemBuilder: (BuildContext context) {
        return [
          buildFilterMenuItem('All', Icons.list, Colors.orangeAccent),
          buildFilterMenuItem('High', Icons.trending_up, Colors.green),
          buildFilterMenuItem('Low', Icons.trending_down, Colors.red),
        ];
      },
      offset: const Offset(0, 50),
    );
  }

  PopupMenuItem<String> buildFilterMenuItem(
    String filter,
    IconData icon,
    Color color,
  ) {
    final count = filter == 'All'
        ? controller.reviews.length
        : filter == 'High'
        ? controller.getHighReviewsCount()
        : controller.getLowReviewsCount();

    final isSelected = controller.selectedFilter.value == filter;

    return PopupMenuItem<String>(
      value: filter,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Icon(icon, color: color, size: 30),
              const SizedBox(width: 12),
              Text(
                filter.toLowerCase().tr,
                style: TextStyle(
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                  color: isSelected ? color : Colors.black,
                  fontSize: 18,
                ),
              ),
            ],
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              count.toString(),
              style: TextStyle(
                color: color,
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Color getFilterColor(String filter) {
    switch (filter) {
      case 'High':
        return Colors.green;
      case 'Low':
        return Colors.red;
      case 'All':
      default:
        return Colors.orangeAccent;
    }
  }

  Widget buildMealInfo(
    String? mealNameEn,
    String? mealNameAr,
    String? mealImageUrl,
  ) {
    if (mealNameEn == null) return const SizedBox();

    final mealName = Get.locale?.languageCode == 'ar'
        ? (mealNameAr ?? mealNameEn)
        : mealNameEn;

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: [
            if (mealImageUrl != null && mealImageUrl.isNotEmpty)
              Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  image: DecorationImage(
                    image: NetworkImage(mealImageUrl),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            if (mealImageUrl != null && mealImageUrl.isNotEmpty)
              const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'meal_reviewed'.tr,
                    style: TextStyle(fontSize: 20, color: Colors.grey[600]),
                  ),
                  Text(
                    mealName,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.orangeAccent,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
