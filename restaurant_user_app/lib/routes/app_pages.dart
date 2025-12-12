import 'package:get/get.dart';
import '../modules/ingredient_rating/ingredient_rating_binding.dart';
import '../modules/ingredient_rating/ingredient_rating_view.dart';
import '../modules/preview/preview_view.dart';
import '../modules/preview/preview_binding.dart';
import '../modules/splash/splash_binding.dart';
import '../modules/splash/splash_view.dart';
import '../modules/survey/survey_view.dart';
import '../modules/survey/survey_binding.dart';

class AppPages {
  static const initial = Routes.splash;

  static final routes = [
    GetPage(
      name: Routes.splash,
      page: () => SplashView(),
      binding: SplashBinding(),
    ),
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
    GetPage(
      name: Routes.ingredientRating,
      page: () => IngredientRatingView(),
      binding: IngredientRatingBinding(),
    ),
  ];
}

class Routes {
  static const splash = '/';
  static const preview = '/preview';
  static const survey = '/survey';
  static const ingredientRating = '/ingredient-rating';
}
