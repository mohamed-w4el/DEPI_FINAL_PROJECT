import 'package:get/get.dart';
import '../../data/models/meal_model.dart';
import '../../data/services/restaurant_service.dart';
import '../../routes/app_pages.dart';
import '../../widgets/thank_you_widget.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter/material.dart';

class SurveyController extends GetxController {
  final RestaurantService _service = RestaurantService();

  late Meal meal;

  // Reactive form fields
  final comments = ''.obs;
  final recommend = ''.obs;

  final serviceRating = 0.0.obs;
  final foodRating = 0.0.obs;
  final overallRating = 0.0.obs;

  final isSubmitting = false.obs;

  // TextEditingController for TextField
  final commentsController = TextEditingController().obs;
  final recommendController = TextEditingController();

  // Speech-to-text
  final RxBool speechEnabled = false.obs;
  final speech = SpeechToText();
  final isListening = false.obs;

  @override
  void onInit() {
    super.onInit();

    // Get the meal object from navigation arguments
    meal = Get.arguments as Meal;

    // Initialize speech

    // Keep TextField in sync with RxString
    ever(comments, (val) {
      if (commentsController.value.text != val) {
        commentsController.value.text = val;
      }
    });
  }

  @override
  void onClose() {
    commentsController.value.dispose();
    super.onClose();
  }

  /// Checks microphone permission and returns true if granted
  Future<bool> _ensurePermission() async {
    await speech.initialize();
    PermissionStatus status = await Permission.microphone.request();

    if (status.isGranted) {
      return true;
    } else if (status.isPermanentlyDenied) {
      openAppSettings();
      return false;
    } else {
      // just denied temporarily
      Get.snackbar("Permission denied", "Microphone access is required.");
      return false;
    }
  }

  Future<void> startListening() async {
    final granted = await _ensurePermission();
    if (!granted) return;

    isListening(true);
    await speech.listen(
      onResult: (result) {
        comments(result.recognizedWords);
        commentsController.value.text = result.recognizedWords;
      },
    );
  }

  Future<void> stopListening() async {
    isListening(false);
    await speech.stop();
  }

  Future<void> submitReview() async {
    // Validation
    if (serviceRating.value == 0 ||
        foodRating.value == 0 ||
        overallRating.value == 0) {
      Get.snackbar('Missing Ratings', 'Please rate all fields');
      return;
    }

    if (recommend.value.isEmpty) {
      Get.snackbar('Missing Answer', 'Please choose recommendation');
      return;
    }

    isSubmitting(true);

    final success = await _service.sendReview(
      mealId: meal.mealId,
      serviceRating: serviceRating.value,
      foodRating: foodRating.value,
      overallRating: overallRating.value,
      comments: comments.value,
      recommend: recommend.value,
    );

    isSubmitting(false);

    if (success) {
      final type = overallRating.value > 2
          ? FeedbackType.good
          : FeedbackType.bad;

      // Show feedback dialog and wait until it's closed
      showFeedbackDialog(Get.context!, type);
      await Future.delayed(Duration(seconds: 3));
      // Navigate back to main screen (preview)
      Get.offAllNamed(Routes.preview);

      // Reset form
      comments('');
      commentsController.value.clear();
      recommend('');
      serviceRating(0);
      foodRating(0);
      overallRating(0);
    } else {
      Get.snackbar('Error', 'Failed to submit review');
    }
  }
}
