// import 'package:get/get.dart';
// import 'package:resturant_review/data/services/sentiment/sentiment_service.dart';
// import '../../data/models/meal_model.dart';
// import '../../data/models/user.dart';
// import '../../data/services/restaurant_service.dart';
// import '../../routes/app_pages.dart';
// import '../../widgets/thank_you_widget.dart';
// import 'package:speech_to_text/speech_to_text.dart';
// import 'package:permission_handler/permission_handler.dart';
// import 'package:flutter/material.dart';
//
// class SurveyController extends GetxController {
//   final RestaurantService _service = RestaurantService();
//
//   late Meal meal;
//
//   final user = Get.arguments['user'] as User?;
//
//   // Reactive form fields
//   final comments = ''.obs;
//   final recommend = ''.obs;
//
//   final serviceRating = 0.0.obs;
//   final foodRating = 0.0.obs;
//   final overallRating = 0.0.obs;
//
//   final isSubmitting = false.obs;
//
//   // TextEditingController for TextField
//   final commentsController = TextEditingController().obs;
//   final recommendController = TextEditingController();
//
//   // Speech-to-text
//   final RxBool speechEnabled = false.obs;
//   final speech = SpeechToText();
//   final isListening = false.obs;
//
//   @override
//   void onInit() {
//     super.onInit();
//
//     // Get the meal object from navigation arguments
//     meal = Get.arguments['meal'] as Meal;
//
//     // Initialize speech
//
//     // Keep TextField in sync with RxString
//     ever(comments, (val) {
//       if (commentsController.value.text != val) {
//         commentsController.value.text = val;
//       }
//     });
//   }
//
//   @override
//   void onClose() {
//     commentsController.value.dispose();
//     super.onClose();
//   }
//
//   /// Checks microphone permission and returns true if granted
//   Future<bool> _ensurePermission() async {
//     await speech.initialize();
//     PermissionStatus status = await Permission.microphone.request();
//
//     if (status.isGranted) {
//       return true;
//     } else if (status.isPermanentlyDenied) {
//       openAppSettings();
//       return false;
//     } else {
//       // just denied temporarily
//       Get.snackbar("Permission denied", "Microphone access is required.");
//       return false;
//     }
//   }
//
//   Future<void> startListening() async {
//     final granted = await _ensurePermission();
//     if (!granted) return;
//
//     isListening(true);
//     await speech.listen(
//       onResult: (result) {
//         comments(result.recognizedWords);
//         commentsController.value.text = result.recognizedWords;
//       },
//     );
//   }
//
//   Future<void> stopListening() async {
//     isListening(false);
//     await speech.stop();
//   }
//
//   Future<void> submitReview() async {
//     // Validation
//     if (serviceRating.value == 0 ||
//         foodRating.value == 0 ||
//         overallRating.value == 0) {
//       Get.snackbar('Missing Ratings', 'Please rate all fields');
//       return;
//     }
//
//     if (recommend.value.isEmpty) {
//       Get.snackbar('Missing Answer', 'Please choose recommendation');
//       return;
//     }
//
//     final avgRating =
//         (serviceRating.value + foodRating.value + overallRating.value) / 3;
//     // min => 1 , max =>5
//
//     // Check if user gave high ratings but wrote negative comments
//     if (avgRating >= 2.5) {
//       // Check for negative sentiment in comments using existing SentimentService
//       if (comments.value.isNotEmpty &&
//           SentimentService.isNegative(comments.value)) {
//         Get.snackbar(
//           'Inconsistent Feedback',
//           'You gave high ratings but your comments seem negative. Please recheck your survey.',
//           backgroundColor: Colors.orange,
//           colorText: Colors.white,
//           duration: Duration(seconds: 5),
//         );
//         return; // Don't proceed with submission
//       }
//
//       // Check for negative recommendation in recommend us dropdown
//       if (recommend.value.toLowerCase() == 'no') {
//         Get.snackbar(
//           'Inconsistent Feedback',
//           'You gave high ratings, but you wouldn\'t recommend us. Please recheck your survey',
//           backgroundColor: Colors.orange,
//           colorText: Colors.white,
//           duration: Duration(seconds: 5),
//         );
//         return; //Don't proceed with submission
//       }
//     }
//
//     // Check if user gave low ratings but wrote positive comments
//     if (avgRating < 2.5) {
//       // Check for positive sentiment in comments using existing SentimentService
//       if (comments.value.isNotEmpty &&
//           SentimentService.isPositive(comments.value)) {
//         Get.snackbar(
//           'Inconsistent Feedback',
//           'You gave low ratings but your comments seem positive. Please recheck your survey.',
//           backgroundColor: Colors.orange,
//           colorText: Colors.white,
//           duration: Duration(seconds: 5),
//         );
//         return; //Don't proceed with submission
//       }
//
//       // Check for positive recommendation in recommend us dropdown
//       if (recommend.value.toLowerCase() == 'yes') {
//         Get.snackbar(
//           'Inconsistent Feedback',
//           'You gave low ratings, but you would recommend us. Please recheck your survey',
//           backgroundColor: Colors.orange,
//           colorText: Colors.white,
//           duration: Duration(seconds: 5),
//         );
//         return; //Don't proceed with submission
//       }
//     }
//
//     isSubmitting(true);
//
//     final success = await _service.sendReview(
//       userId: user?.id,
//       mealId: meal.mealId,
//       serviceRating: serviceRating.value,
//       foodRating: foodRating.value,
//       overallRating: overallRating.value,
//       comments: comments.value,
//       recommend: recommend.value,
//     );
//
//     isSubmitting(false);
//
//     if (success) {
//       if (user != null) {
//         await _service.updateUserPoints(user!.id);
//       }
//
//       final type = overallRating.value > 2
//           ? FeedbackType.good
//           : FeedbackType.bad;
//
//       // Show feedback dialog and wait until it's closed
//       showFeedbackDialog(Get.context!, type);
//       await Future.delayed(Duration(seconds: 3));
//       // Navigate back to main screen (preview)
//       Get.offAllNamed(Routes.preview, arguments: {'user': user});
//
//       // Reset form
//       comments('');
//       commentsController.value.clear();
//       recommend('');
//       serviceRating(0);
//       foodRating(0);
//       overallRating(0);
//     } else {
//       Get.snackbar('Error', 'Failed to submit review');
//     }
//   }
// }

import 'package:get/get.dart';
import 'package:restaurant_user_app/data/services/sentiment/sentiment_service.dart';
import '../../data/models/meal_model.dart';
import '../../data/models/user.dart';
import '../../data/services/restaurant_service.dart';
import '../../routes/app_pages.dart';
import '../../widgets/thank_you_widget.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter/material.dart';

class SurveyController extends GetxController {
  final RestaurantService _service = RestaurantService();

  late Meal meal;

  final user = Get.arguments['user'] as User?;

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
  final speechEnabled = false.obs;
  final speech = stt.SpeechToText();
  final isListening = false.obs;

  @override
  void onInit() {
    super.onInit();

    // Get the meal object from navigation arguments
    meal = Get.arguments['meal'] as Meal;

    // Keep TextField in sync with RxString
    ever(comments, (val) {
      if (commentsController.value.text != val) {
        commentsController.value.text = val;
      }
    });
  }

  Future<void> _initSpeech() async {
    speechEnabled.value = await speech.initialize();
    if (speechEnabled.value) print('speech initialized successfully');
  }

  /// Checks microphone permission and returns true if granted

  Future<bool> _ensurePermission() async {
    PermissionStatus status = await Permission.microphone.request();

    if (status.isGranted) {
      return true;
    } else if (status.isPermanentlyDenied) {
      openAppSettings();
      return false;
    } else {
      // just denied temporarily
      Get.snackbar("permission_denied".tr, "microphone_required".tr);
      return false;
    }
  }

  Future<void> startListening() async {
    // // Check if speech is enabled and initialized
    if (!speechEnabled.value) {
      // Try to initialize if not already done
      await _initSpeech();
      if (!speechEnabled.value) {
        Get.snackbar('speech_not_available'.tr, 'speech_init_failed'.tr);
        return;
      }
    }

    final granted = await _ensurePermission();
    if (!granted) return;

    isListening(true);
    await speech.listen(
      onResult: (result) {
        comments(result.recognizedWords);
        commentsController.value.text = result.recognizedWords;
      },
      localeId: Get.locale?.languageCode,
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
      Get.snackbar('missing_ratings'.tr, '');
      return;
    }

    if (recommend.value.isEmpty) {
      Get.snackbar('missing_answer'.tr, '');
      return;
    }

    final avgRating =
        (serviceRating.value + foodRating.value + overallRating.value) / 3;
    // min => 1 , max =>5

    // Check if user gave high ratings but wrote negative comments
    if (avgRating >= 2.5) {
      // Check for negative sentiment in comments using existing SentimentService
      if (comments.value.isNotEmpty &&
          SentimentService.isNegative(comments.value)) {
        Get.snackbar(
          'inconsistent_feedback'.tr,
          'high_ratings_negative_comments'.tr,
          backgroundColor: Colors.redAccent,
          colorText: Colors.white,
          duration: const Duration(seconds: 5),
        );
        return; // Don't proceed with submission
      }

      // Check for negative recommendation in recommend us dropdown
      if (recommend.value.toLowerCase() == 'no'.tr.toLowerCase()) {
        Get.snackbar(
          'inconsistent_feedback'.tr,
          'high_ratings_no_recommend'.tr,
          backgroundColor: Colors.redAccent,
          colorText: Colors.white,
          duration: const Duration(seconds: 5),
        );
        return; //Don't proceed with submission
      }
    }

    // Check if user gave low ratings but wrote positive comments
    if (avgRating < 2.5) {
      // Check for positive sentiment in comments using existing SentimentService
      if (comments.value.isNotEmpty &&
          SentimentService.isPositive(comments.value)) {
        Get.snackbar(
          'inconsistent_feedback'.tr,
          'low_ratings_positive_comments'.tr,
          backgroundColor: Colors.redAccent,
          colorText: Colors.white,
          duration: const Duration(seconds: 5),
        );
        return; //Don't proceed with submission
      }

      // Check for positive recommendation in recommend us dropdown
      if (recommend.value.toLowerCase() == 'yes'.tr.toLowerCase()) {
        Get.snackbar(
          'inconsistent_feedback'.tr,
          'low_ratings_yes_recommend'.tr,
          backgroundColor: Colors.redAccent,
          colorText: Colors.white,
          duration: const Duration(seconds: 5),
        );
        return; //Don't proceed with submission
      }
    }

    isSubmitting(true);

    final success = await _service.sendReview(
      userId: user?.id,
      mealId: meal.mealId,
      serviceRating: serviceRating.value,
      foodRating: foodRating.value,
      overallRating: overallRating.value,
      comments: comments.value,
      recommend: recommend.value,
    );

    isSubmitting(false);

    if (success) {
      if (user != null) {
        await _service.updateUserPoints(user!.id);
      }

      final type = overallRating.value > 2
          ? FeedbackType.good
          : FeedbackType.bad;

      // Show feedback dialog and wait until it's closed
      showFeedbackDialog(Get.context!, type);
      await Future.delayed(const Duration(seconds: 3));
      // Navigate back to main screen (preview)
      Get.offAllNamed(Routes.preview, arguments: {'user': user});

      // Reset form
      comments('');
      commentsController.value.clear();
      recommend('');
      serviceRating(0);
      foodRating(0);
      overallRating(0);
    } else {
      Get.snackbar('error'.tr, '');
    }
  }

  @override
  void onClose() {
    comments.close();
    recommend.close();

    serviceRating.close();
    foodRating.close();
    overallRating.close();

    isSubmitting.close();

    commentsController.value.dispose();
    recommendController.dispose();

    speechEnabled.close();
    speech.cancel();
    isListening.close();
    super.onClose();
  }
}
