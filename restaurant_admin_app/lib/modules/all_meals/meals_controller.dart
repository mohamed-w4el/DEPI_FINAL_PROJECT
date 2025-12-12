import 'package:get/get.dart';
import 'package:restaurant_admin_app/data/models/meals.dart';
import 'package:restaurant_admin_app/data/models/reviews.dart';

class MealsController extends GetxController {
  final meals = <Meals>[].obs;
  final reviews = <Reviews>[].obs;

  final isLoading = true.obs;

  @override
  void onInit() {
    super.onInit();
    loadData();
  }

  void loadData() {
    final mealsData = Get.arguments['meals'] as List<Meals>?;
    final reviewsData = Get.arguments['reviews'] as List<Reviews>?;

    if (mealsData != null) {
      meals.value = mealsData;
    }

    if (reviewsData != null) {
      reviews.value = reviewsData;
    }

    isLoading.value = false;
  }

  @override
  void onClose() {
    meals.close();
    reviews.close();
    isLoading.close();
    super.onClose();
  }
}
