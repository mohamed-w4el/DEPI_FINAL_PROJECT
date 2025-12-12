import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:restaurant_user_app/main.dart';
import 'package:restaurant_user_app/modules/splash/splash_controller.dart';

class SplashView extends GetView<SplashController> {
  const SplashView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F8F8),

      appBar: AppBar(
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
              await LocaleManager.toggleLocale();
            },
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Logo/Icon Container
                Container(
                  width: 104,
                  height: 104,
                  decoration: BoxDecoration(
                    color: const Color(0xFFF9A825), // Primary orange/yellow
                    borderRadius: BorderRadius.circular(24),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 8,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.restaurant,
                    color: Colors.white,
                    size: 64,
                  ),
                ),

                const SizedBox(height: 32),

                // Title
                Text(
                  'welcome'.tr,
                  style: const TextStyle(
                    fontSize: 36,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),

                const SizedBox(height: 16),

                // Subtitle
                Text(
                  'enter_phone'.tr,
                  style: const TextStyle(fontSize: 24, color: Colors.black54),
                  textAlign: TextAlign.center,
                ),

                const SizedBox(height: 48),

                // Phone Number Input
                Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Obx(() {
                      return Container(
                        height: 56,
                        decoration: BoxDecoration(
                          color: const Color(0xFFF0F0F0),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: controller.isPhoneValid.value
                                ? Colors.transparent
                                : Color(0xEFFF505F),
                            width: 2,
                          ),
                        ),
                        child: Row(
                          children: [
                            const Padding(
                              padding: EdgeInsets.symmetric(horizontal: 16),
                              child: Icon(
                                Icons.phone,
                                color: Colors.grey,
                                size: 32,
                              ),
                            ),
                            Expanded(
                              child: TextSelectionTheme(
                                data: TextSelectionThemeData(
                                  selectionColor: Color(0xF1F3B571),
                                  cursorColor: Colors.orange,
                                  selectionHandleColor: Colors.blue,
                                ),
                                child: TextField(
                                  controller: controller.phoneController,
                                  keyboardType: TextInputType.phone,
                                  decoration: InputDecoration(
                                    hintText: 'phone_hint'.tr,
                                    border: InputBorder.none,
                                    hintStyle: const TextStyle(
                                      color: Colors.grey,
                                      fontSize: 24,
                                    ),
                                    contentPadding: EdgeInsets.zero,
                                    counterText: '', // Hide character counter
                                    errorBorder: InputBorder.none,
                                    focusedBorder: InputBorder.none,
                                    focusedErrorBorder: InputBorder.none,
                                    enabledBorder: InputBorder.none,
                                    disabledBorder: InputBorder.none,
                                  ),
                                  style: const TextStyle(
                                    fontSize: 24,
                                    color: Colors.black,
                                  ),
                                  maxLength: 11,
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    }),

                    Obx(() {
                      if (!controller.isPhoneValid.value) {
                        return Padding(
                          padding: const EdgeInsets.only(top: 4),
                          child: Text(
                            controller.phoneError.value.tr,
                            style: TextStyle(
                              fontSize: 18,
                              color: Color(0xEFFF505F),
                            ),
                          ),
                        );
                      }
                      return SizedBox.shrink();
                    }),
                  ],
                ),

                const SizedBox(height: 24),

                // Start Button
                Obx(
                  () => ElevatedButton(
                    onPressed: controller.startSurvey,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFF9A825),
                      minimumSize: const Size(double.infinity, 56),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      elevation: 4,
                    ),
                    child: controller.isLoading.value
                        ? const SizedBox(
                            width: 24,
                            height: 24,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2,
                            ),
                          )
                        : Text(
                            'start'.tr,
                            style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
