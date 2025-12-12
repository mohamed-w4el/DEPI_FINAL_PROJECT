import 'package:get/get.dart';
import '../../data/models/meal_model.dart';
import '../../data/models/user.dart';
import '../../data/services/restaurant_service.dart';

class PreviewController extends GetxController {
  final RestaurantService _service = RestaurantService();

  var meals = <Meal>[].obs;
  var isLoading = true.obs;
  final user = Get.arguments['user'] as User?;

  @override
  void onInit() {
    super.onInit();
    loadMeals();
  }

  Future<void> loadMeals() async {
    final data = await _service.loadMeals();
    meals.assignAll(data);
    isLoading(false);
  }
}
