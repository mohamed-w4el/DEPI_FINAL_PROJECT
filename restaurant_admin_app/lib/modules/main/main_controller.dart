import 'package:get/get.dart';
import 'package:restaurant_admin_app/data/localization/app_localization.dart';
import 'package:restaurant_admin_app/data/models/meals.dart';
import 'package:restaurant_admin_app/data/models/reviews.dart';
import 'package:restaurant_admin_app/data/services/admin_services.dart';

class MainController extends GetxController {
  final adminService = AdminService();

  final meals = <Meals>[].obs;
  final reviews = <Reviews>[].obs;
  final currentLocale = 'en'.obs;

  @override
  void onInit() {
    super.onInit();
    loadMeals();
    loadReviews();
    loadLocale();
  }

  Future<void> loadLocale() async {
    currentLocale.value = Get.locale?.languageCode ?? 'en';
  }

  void updateLocale() {
    currentLocale.value = Get.locale?.languageCode ?? 'en';
  }

  Future<void> loadMeals() async {
    final data = await adminService.loadMeals();
    if (data != null) {
      meals.value = data;
    }
  }

  Future<void> loadReviews() async {
    final data = await adminService.loadReviews();
    if (data != null) {
      reviews.value = data;
    }
  }

  @override
  void onClose() {
    meals.close();
    reviews.close();
    currentLocale.close();
    super.onClose();
  }
}
