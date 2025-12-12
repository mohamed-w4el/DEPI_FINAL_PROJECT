import 'package:get/get.dart';
import 'package:restaurant_admin_app/modules/meal_analytics/meal_analytics_controller.dart';

class MealAnalyticsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<MealAnalyticsController>(() => MealAnalyticsController());
  }
}
