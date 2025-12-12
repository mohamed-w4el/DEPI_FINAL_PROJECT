import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:restaurant_admin_app/data/models/meals.dart';
import 'package:restaurant_admin_app/modules/all_meals/meals_controller.dart';
import 'package:restaurant_admin_app/routes/app_pages.dart';
import 'package:restaurant_admin_app/main.dart' as app;

class MealsView extends GetView<MealsController> {
  const MealsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xfffafafa),

      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 3,
        leading: IconButton(
          onPressed: () {
            Get.back();
          },
          icon: Icon(Icons.arrow_back_ios, color: Colors.grey, size: 30),
        ),
        centerTitle: true,
        title: Row(
          spacing: 16,
          children: [
            Icon(Icons.restaurant, color: Colors.orange, size: 40),
            Text(
              "meals".tr,
              style: const TextStyle(
                color: Colors.black,
                fontSize: 32,
                fontWeight: FontWeight.w600,
              ),
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
        ],
      ),
      body: SafeArea(
        child: Obx(() {
          if (controller.isLoading.value) {
            return const Center(
              child: CircularProgressIndicator(color: Colors.orangeAccent),
            );
          }

          return ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: controller.meals.length,
            separatorBuilder: (_, __) => const SizedBox(height: 16),
            itemBuilder: (_, index) {
              final meal = controller.meals[index];
              return buildMealCard(meal);
            },
          );
        }),
      ),
    );
  }

  Widget buildMealCard(Meals meal) {
    final isArabic = Get.locale?.languageCode == 'ar';
    final mealName = isArabic ? (meal.nameAr) : meal.nameEn;
    final mealDescription = isArabic
        ? (meal.descriptionAr)
        : meal.descriptionEn;
    return InkWell(
      onTap: () => Get.toNamed(
        Routes.mealAnalyticsPage,
        arguments: {'meal': meal, 'reviews': controller.reviews},
      ),
      borderRadius: BorderRadius.circular(16),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
        ),
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(right: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      mealName,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 32,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      mealDescription,
                      maxLines: 4,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 24,
                        color: Colors.black87,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Container(
                width: 300,
                height: 200,
                color: Colors.grey[200],
                child: Image.network(meal.imageUrl, fit: BoxFit.cover),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
