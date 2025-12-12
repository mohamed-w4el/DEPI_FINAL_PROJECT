import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:restaurant_admin_app/modules/main/main_controller.dart';
import 'package:restaurant_admin_app/routes/app_pages.dart';
import 'package:restaurant_admin_app/main.dart' as app;

class MainView extends GetView<MainController> {
  const MainView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 4,
        toolbarHeight: 80,
        title: Row(
          spacing: 16,
          children: [
            const Icon(
              Icons.admin_panel_settings,
              color: Colors.orangeAccent,
              size: 40,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  "admin_dashboard".tr,
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1,
                  ),
                ),
                Text(
                  "manage_reviews_analytics".tr,
                  style: const TextStyle(color: Colors.grey, fontSize: 24),
                ),
              ],
            ),
          ],
        ),
        actions: [
          // Language switcher
          IconButton(
            icon: Text(
              Get.locale?.languageCode == 'en' ? 'AR' : 'EN',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 24,
                color: Colors.orangeAccent,
              ),
            ),
            onPressed: () async {
              await app.LocaleManager.toggleLocale();
              controller.updateLocale();
            },
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              const SizedBox(height: 32),
              buildNavigationCard(
                icon: Icons.reviews,
                text: "view_all_reviews".tr,
                subtext: "browse_manage_reviews".tr,
                route: Routes.reviewsPage,
              ),

              const SizedBox(height: 32),

              buildNavigationCard(
                icon: Icons.analytics,
                text: "analytics_charts".tr,
                subtext: "view_ratings_statistics".tr,
                route: Routes.analysisPage,
              ),

              const SizedBox(height: 32),

              Obx(
                () => buildNavigationCard(
                  icon: Icons.restaurant,
                  text: "meals_analytics".tr,
                  subtext:
                      "${controller.meals.length} ${'meals'.tr} • ${controller.reviews.length} ${'reviews'.tr}",
                  route: Routes.mealsPage,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildNavigationCard({
    required IconData icon,
    required String text,
    required String subtext,
    required String route,
    dynamic arguments,
  }) {
    return Card(
      elevation: 6,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: InkWell(
        splashColor: Colors.orangeAccent.withOpacity(0.4),
        borderRadius: BorderRadius.circular(16),
        onTap: () {
          Get.toNamed(
            route,
            arguments: {
              'meals': controller.meals,
              'reviews': controller.reviews,
            },
          );
        },
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Row(
            children: [
              Icon(icon, size: 40, color: Colors.orangeAccent),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      text,
                      style: const TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      subtext,
                      style: const TextStyle(color: Colors.grey, fontSize: 24),
                    ),
                  ],
                ),
              ),
              const Icon(Icons.arrow_forward_ios, color: Colors.grey, size: 40),
            ],
          ),
        ),
      ),
    );
  }
}
