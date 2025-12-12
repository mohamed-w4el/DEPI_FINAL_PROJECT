import 'package:get/get.dart';
import 'ingredient_rating_controller.dart';

class IngredientRatingBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<IngredientRatingController>(() => IngredientRatingController());
  }
}
