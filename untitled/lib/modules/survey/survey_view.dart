import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../data/models/meal_model.dart';
import 'survey_controller.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class SurveyView extends GetView<SurveyController> {
  const SurveyView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xfffafafa),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 1,
        centerTitle: true,
        title: const Text(
          "Meal Review",
          style: TextStyle(
            color: Colors.black,
            fontSize: 24,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            buildMealCard(controller.meal),
            const SizedBox(height: 16),
            const Text(
              "Survey",
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 12),
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    buildRating("Service", controller.serviceRating),
                    const Divider(height: 32),
                    buildRating("Food Quality", controller.foodRating),
                    const Divider(height: 32),
                    buildRating("Overall Experience", controller.overallRating),
                    const SizedBox(height: 20),
                    buildComments(),
                    const SizedBox(height: 20),
                    buildRecommendDropdown(),
                    const SizedBox(height: 20),
                    buildSubmitButton(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildMealCard(Meal meal) {
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
              width: Get.width,
              height: 140,
              fit: BoxFit.cover,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  meal.name,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  meal.description,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontSize: 16, color: Colors.black54),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget buildRating(String label, RxDouble rating) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        RatingBar.builder(
          initialRating: rating.value,
          itemCount: 5,
          itemSize: 28,
          onRatingUpdate: rating,
          itemBuilder: (_, __) => const Icon(Icons.star, color: Colors.orange),
        ),
      ],
    );
  }

  Widget buildComments() {
    return TextField(
      controller: controller.commentsController.value,
      maxLines: 3,
      decoration: InputDecoration(
        labelText: "Comments",
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        suffixIcon: Obx(
          () => IconButton(
            onPressed: () {
              print(
                "Mic button pressed. Listening: ${controller.isListening.value}",
              );
              controller.isListening.value
                  ? controller.stopListening()
                  : controller.startListening();
            },
            icon: Icon(
              Icons.mic,
              color: controller.isListening.value ? Colors.red : Colors.grey,
            ),
          ),
        ),
      ),
      onChanged: (val) => controller.comments(val),
    );
  }

  Widget buildRecommendDropdown() {
    return Obx(
      () => DropdownButtonFormField(
        decoration: InputDecoration(
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          labelText: "Would you recommend us?",
        ),
        value: controller.recommend.value.isEmpty
            ? null
            : controller.recommend.value,
        items: [
          'Yes',
          'No',
        ].map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
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
            : const Text("Submit", style: TextStyle(color: Colors.white)),
      ),
    );
  }
}
