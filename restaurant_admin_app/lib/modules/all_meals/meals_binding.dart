import 'package:get/get.dart';
import 'package:restaurant_admin_app/modules/all_meals/meals_controller.dart';

class MealsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<MealsController>(() => MealsController());
  }
}
