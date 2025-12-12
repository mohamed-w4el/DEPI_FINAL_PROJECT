import 'package:get/get.dart';
import 'package:restaurant_admin_app/modules/main/main_controller.dart';

class MainBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<MainController>(() => MainController());
  }
}
