import 'package:get/get.dart';
import 'package:restaurant_admin_app/modules/all_meals/meals_binding.dart';
import 'package:restaurant_admin_app/modules/all_meals/meals_view.dart';
import 'package:restaurant_admin_app/modules/analysis/analysis_binding.dart';
import 'package:restaurant_admin_app/modules/analysis/analysis_view.dart';
import 'package:restaurant_admin_app/modules/main/main_binding.dart';
import 'package:restaurant_admin_app/modules/main/main_view.dart';
import 'package:restaurant_admin_app/modules/meal_analytics/meal_analytics_binding.dart';
import 'package:restaurant_admin_app/modules/meal_analytics/meal_analytics_view.dart';
import 'package:restaurant_admin_app/modules/reviews/reviews_binding.dart';
import 'package:restaurant_admin_app/modules/reviews/reviews_view.dart';

class AppPages {
  static const initial = Routes.mainPage;

  static final routes = [
    GetPage(
      name: Routes.mainPage,
      page: () => MainView(),
      binding: MainBinding(),
    ),
    GetPage(
      name: Routes.reviewsPage,
      page: () => ReviewsView(),
      binding: ReviewsBinding(),
    ),
    GetPage(
      name: Routes.analysisPage,
      page: () => AnalysisView(),
      binding: AnalysisBinding(),
    ),
    GetPage(
      name: Routes.mealsPage,
      page: () => MealsView(),
      binding: MealsBinding(),
    ),
    GetPage(
      name: Routes.mealAnalyticsPage,
      page: () => MealAnalyticsView(),
      binding: MealAnalyticsBinding(),
    ),
  ];
}

class Routes {
  static const mainPage = '/';
  static const reviewsPage = '/reviews';
  static const analysisPage = '/analysis';
  static const mealsPage = '/meals';
  static const mealAnalyticsPage = '/meal-analytics';
}
