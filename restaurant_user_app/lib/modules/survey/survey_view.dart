import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:restaurant_user_app/data/models/meal_model.dart';
import 'package:restaurant_user_app/main.dart';
import 'package:restaurant_user_app/modules/survey/survey_controller.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class SurveyView extends GetView<SurveyController> {
  const SurveyView({super.key});

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
          "meal_review".tr,
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
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(flex: 1, child: buildMealCard(controller.meal)),
            const SizedBox(width: 24),
            Expanded(flex: 2, child: Obx(() => buildSurveyCard())),
          ],
        ),
      ),
    );
  }

  Widget buildMealCard(Meal meal) {
    // Determine which language to show based on current locale
    final isArabic = Get.locale?.languageCode == 'ar';
    final name = isArabic ? meal.nameAr : meal.nameEn;
    final description = isArabic ? meal.descriptionAr : meal.descriptionEn;

    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Column(
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(16),
              topRight: Radius.circular(16),
            ),
            child: Image.network(
              meal.imageUrl,
              width: double.infinity,
              height: 300,
              fit: BoxFit.cover,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  name,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  description,
                  maxLines: 3,
                  style: const TextStyle(fontSize: 18, color: Colors.black54),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget buildSurveyCard() {
    return SizedBox(
      width: double.infinity,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            buildRating("service".tr, controller.serviceRating),
            const Divider(height: 32),
            buildRating("food_quality".tr, controller.foodRating),
            const Divider(height: 32),
            buildRating("overall_experience".tr, controller.overallRating),
            const SizedBox(height: 20),
            buildComments(),
            const SizedBox(height: 20),
            buildRecommendDropdown(),
            const SizedBox(height: 20),
            buildSubmitButton(),
            const SizedBox(height: 20),
            buildIngredientPageButton(),
          ],
        ),
      ),
    );
  }

  Widget buildRating(String label, RxDouble rating) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        RatingBar.builder(
          initialRating: rating.value,
          itemCount: 5,
          itemSize: 32,
          onRatingUpdate: rating,
          itemBuilder: (_, __) => const Icon(Icons.star, color: Colors.orange),
        ),
      ],
    );
  }

  Widget buildComments() {
    return TextSelectionTheme(
      data: TextSelectionThemeData(
        selectionColor: Color(0xF1F3B571),
        cursorColor: Colors.orange,
      ),
      child: TextField(
        controller: controller.commentsController.value,
        maxLines: 5,
        decoration: InputDecoration(
          labelText: "comments".tr,
          labelStyle: TextStyle(fontSize: 24),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
          suffixIcon: Obx(() {
            return IconButton(
              onPressed: () {
                controller.isListening.value
                    ? controller.stopListening()
                    : controller.startListening();
              },
              icon: Icon(
                Icons.mic,
                color: controller.isListening.value ? Colors.red : Colors.grey,
                size: 32,
              ),
            );
          }),
        ),
        onChanged: (val) => controller.comments(val),
      ),
    );
  }

  Widget buildRecommendDropdown() {
    return Obx(
      () => DropdownButtonFormField(
        decoration: InputDecoration(
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
          labelText: "recommend_us".tr,
          labelStyle: TextStyle(fontSize: 24),
        ),
        iconSize: 32,
        value: controller.recommend.value.isEmpty
            ? null
            : controller.recommend.value,
        items: ['yes', 'no']
            .map(
              (e) => DropdownMenuItem(
                value: e,
                child: Text(e.tr, style: TextStyle(fontSize: 18)),
              ),
            )
            .toList(),
        onChanged: (v) => controller.recommend(v.toString()),
      ),
    );
  }

  Widget buildSubmitButton() {
    return Obx(
      () => ElevatedButton(
        onPressed: controller.isSubmitting.value
            ? null
            : controller.submitReview,
        style: ElevatedButton.styleFrom(
          minimumSize: const Size(double.infinity, 48),
          backgroundColor: Colors.orange,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: controller.isSubmitting.value
            ? const CircularProgressIndicator(color: Colors.white)
            : Text(
                "submit".tr,
                style: const TextStyle(color: Colors.white, fontSize: 24),
              ),
      ),
    );
  }

  Widget buildIngredientPageButton() {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        minimumSize: const Size(double.infinity, 48),
        backgroundColor: Colors.white70,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
      child: Text(
        "rate_ingredients_separately".tr,
        style: const TextStyle(color: Colors.orange, fontSize: 24),
      ),
      onPressed: () {
        Get.toNamed(
          '/ingredient-rating',
          arguments: {
            'meal_id': controller.meal.mealId,
            'user': controller.user,
          },
        );
      },
    );
  }
}
