import 'package:get/get.dart';
import '../modules/preview/preview_view.dart';
import '../modules/preview/preview_binding.dart';
import '../modules/survey/survey_view.dart';
import '../modules/survey/survey_binding.dart';

class AppPages {
  static const initial = Routes.preview;

  static final routes = [
    GetPage(
      name: Routes.preview,
      page: () => PreviewView(),
      binding: PreviewBinding(),
    ),
    GetPage(
      name: Routes.survey,
      page: () => SurveyView(),
      binding: SurveyBinding(),
    ),
  ];
}

class Routes {
  static const preview = '/preview';
  static const survey = '/survey';
}
