import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:get/get.dart';
import 'package:restaurant_user_app/data/models/ingredient.dart';
import 'package:restaurant_user_app/main.dart';
import 'package:restaurant_user_app/modules/ingredient_rating/ingredient_rating_controller.dart';

class IngredientRatingView extends GetView<IngredientRatingController> {
  const IngredientRatingView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xfffafafa),

      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 3,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new_rounded,
            color: Colors.black,
          ),
          onPressed: () => Get.back(),
        ),
        centerTitle: true,
        title: Text(
          "rate_ingredients".tr,
          style: const TextStyle(
            color: Colors.black,
            fontSize: 32,
            fontWeight: FontWeight.w600,
          ),
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
              await LocaleManager.toggleLocale();
            },
          ),
        ],
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(
            child: CircularProgressIndicator(color: Colors.orangeAccent),
          );
        }

        return SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Wrap(
                spacing: 16,
                runSpacing: 16,
                children: controller.ingredients
                    .map(
                      (ing) => SizedBox(
                        width: (Get.width / 2) - 24,
                        child: buildIngredientCard(ing),
                      ),
                    )
                    .toList(),
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () async {
                  await controller.submitRatings();
                  await Future.delayed(const Duration(seconds: 5));
                  Get.back();
                },
                style: ElevatedButton.styleFrom(
                  minimumSize: Size(Get.width, 48),
                  backgroundColor: Colors.orange,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text(
                  "submit_ingredient_ratings".tr,
                  style: const TextStyle(color: Colors.white, fontSize: 24),
                ),
              ),
            ],
          ),
        );
      }),
    );
  }

  Widget buildIngredientCard(Ingredient ing) {
    // Determine which language to show based on current locale
    final isArabic = Get.locale?.languageCode == 'ar';
    final name = isArabic ? ing.nameAr : ing.nameEn;

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              name,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Obx(() {
              return RatingBar.builder(
                initialRating: controller.ratings[ing.id]!.toDouble(),
                minRating: 1,
                direction: Axis.horizontal,
                allowHalfRating: false,
                itemCount: 5,
                itemSize: 32,
                itemPadding: const EdgeInsets.symmetric(horizontal: 2),
                itemBuilder: (context, _) =>
                    const Icon(Icons.star, color: Colors.orange),
                onRatingUpdate: (rating) {
                  controller.updateRating(ing.id, rating.toInt());
                },
              );
            }),
          ],
        ),
      ),
    );
  }
}
