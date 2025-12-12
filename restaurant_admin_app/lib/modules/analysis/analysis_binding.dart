import 'package:get/get.dart';
import 'package:restaurant_admin_app/modules/analysis/analysis_controller.dart';

class AnalysisBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AnalysisController>(() => AnalysisController());
  }
}
