import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:restaurant_user_app/data/services/restaurant_service.dart';

class SplashController extends GetxController {
  final RestaurantService _service = RestaurantService();

  final isLoading = false.obs;

  final phoneController = TextEditingController();
  final isPhoneValid = true.obs;
  final phoneError = ''.obs;

  Future<void> startSurvey() async {
    final phoneNumber = phoneController.text.trim();

    // If no phone number entered, set user as null
    if (phoneNumber.isEmpty) {
      Get.toNamed('/preview', arguments: {'user': null});
      return;
    }

    // Check if controller has less than or more than 11 characters
    if (phoneNumber.length != 11) {
      isPhoneValid.value = false;
      phoneError.value = 'phone_validation_error';
      return;
    }

    // Check if controller doesn't have digits
    final phoneRegex = RegExp(r'^[0-9]+$');
    if (!phoneRegex.hasMatch(phoneNumber)) {
      isPhoneValid.value = false;
      phoneError.value = 'phone_number_error';
      return;
    }

    isPhoneValid.value = true;
    phoneError.value = '';

    isLoading.value = true;

    try {
      final user = await _service.upsertUserByPhone(phoneNumber);

      // Navigate to preview screen
      Get.toNamed('/preview', arguments: {'user': user});
    } catch (e) {
      Get.snackbar(
        'error'.tr,
        'failed_to_process'.tr,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onClose() {
    phoneController.dispose();
    super.onClose();
  }
}
