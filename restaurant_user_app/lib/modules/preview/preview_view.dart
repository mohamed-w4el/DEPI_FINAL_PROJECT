import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:restaurant_user_app/main.dart';
import 'package:restaurant_user_app/modules/preview/preview_controller.dart';
import 'package:restaurant_user_app/routes/app_pages.dart';

class PreviewView extends GetView<PreviewController> {
  const PreviewView({super.key});

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
          "meals".tr,
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

  Widget buildMealCard(meal) {
    // Determine which language to show based on current locale
    final isArabic = Get.locale?.languageCode == 'ar';
    final name = isArabic ? meal.nameAr : meal.nameEn;
    final description = isArabic ? meal.descriptionAr : meal.descriptionEn;

    return InkWell(
      onTap: () => Get.toNamed(
        Routes.survey,
        arguments: {'meal': meal, 'user': controller.user},
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
                      name,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 32,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      description,
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
                width: 500,
                height: 300,
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
