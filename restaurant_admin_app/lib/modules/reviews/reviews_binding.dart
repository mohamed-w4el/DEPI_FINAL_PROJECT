import 'package:get/get.dart';
import 'package:restaurant_admin_app/modules/reviews/reviews_controller.dart';

class ReviewsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ReviewsController>(() => ReviewsController());
  }
}
