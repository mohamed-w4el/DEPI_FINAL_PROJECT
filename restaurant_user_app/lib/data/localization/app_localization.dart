import 'package:get/get.dart';

class AppLocalization extends Translations {
  @override
  Map<String, Map<String, String>> get keys => {
    'en': {
      // App Titles
      'app_title': 'Restaurant Review',
      'welcome': 'Welcome',
      'enter_phone': 'Enter your phone number to get points.',
      'phone_hint': 'Phone Number (Optional)',
      'start': 'Start',
      'meals': 'Meals',
      'meal_review': 'Meal Review',
      'rate_ingredients': 'Rate Ingredients',
      'submit_ingredient_ratings': 'Submit Ingredient Ratings',
      'service': 'Service',
      'food_quality': 'Food Quality',
      'overall_experience': 'Overall Experience',
      'comments': 'Comments',
      'recommend_us': 'Would you recommend us?',
      'submit': 'Submit',
      'rate_ingredients_separately': 'Rate Ingredients Separately',
      'yes': 'Yes',
      'no': 'No',

      // Messages
      'phone_validation_error':
      'Please enter exactly 11 digits, Example: 01234567890',
      'phone_number_error': 'Phone number must contain only numbers (0-9)',
      'missing_ratings': 'Please rate all fields',
      'missing_answer': 'Please choose recommendation',
      'inconsistent_feedback': 'Inconsistent Feedback',
      'error': 'Error',
      'thank_you': 'Thank You!',
      'positive_feedback': 'We appreciate your positive feedback!',
      'we_apologize': 'We Apologize',
      'negative_feedback':
      'We\'re sorry the ingredients didn\'t meet your expectations. We\'ll work to improve!',
      'failed_submission': 'Failed to submit ratings. Please try again.',
      'permission_denied': 'Permission denied',
      'microphone_required': 'Microphone access is required.',
      'failed_to_process': 'Failed to process your request. Please try again.',

      // Good/Bad feedback
      'good_feedback': 'We\'re glad you enjoyed!',
      'bad_feedback': 'We\'re sorry for the experience!',

      // Validation messages
      'high_ratings_negative_comments':
      'You gave high ratings but your comments seem negative. Please recheck your survey.',
      'high_ratings_no_recommend':
      'You gave high ratings, but you wouldn\'t recommend us. Please recheck your survey',
      'low_ratings_positive_comments':
      'You gave low ratings but your comments seem positive. Please recheck your survey.',
      'low_ratings_yes_recommend':
      'You gave low ratings, but you would recommend us. Please recheck your survey',
    },
    'ar': {
      // App Titles
      'app_title': 'مراجعة المطعم',
      'welcome': 'مرحباً',
      'enter_phone': 'أدخل رقم هاتفك للحصول على نقاط.',
      'phone_hint': 'رقم الهاتف (اختياري)',
      'start': 'ابدأ',
      'meals': 'الوجبات',
      'meal_review': 'مراجعة الوجبة',
      'rate_ingredients': 'تقييم المكونات',
      'submit_ingredient_ratings': 'إرسال تقييمات المكونات',
      'service': 'الخدمة',
      'food_quality': 'جودة الطعام',
      'overall_experience': 'التجربة العامة',
      'comments': 'تعليقات',
      'recommend_us': 'هل تنصح بنا؟',
      'submit': 'إرسال',
      'rate_ingredients_separately': 'تقييم المكونات بشكل منفصل',
      'yes': 'نعم',
      'no': 'لا',

      // Messages
      'phone_validation_error': 'يرجى إدخال 11 رقمًا بالضبط، مثال: 01234567890',
      'phone_number_error': 'يجب أن يحتوي رقم الهاتف على أرقام فقط (0-9)',
      'missing_ratings': 'الرجاء تقييم جميع الحقول',
      'missing_answer': 'الرجاء اختيار التوصية',
      'inconsistent_feedback': 'ملاحظات غير متسقة',
      'error': 'خطأ',
      'thank_you': 'شكراً لك!',
      'positive_feedback': 'نقدر ملاحظاتك الإيجابية!',
      'we_apologize': 'نعتذر',
      'negative_feedback':
      'نأسف لأن المكونات لم تكن كما تتوقع. سنعمل على التحسين!',
      'failed_submission': 'فشل في إرسال التقييمات. يرجى المحاولة مرة أخرى.',
      'permission_denied': 'تم رفض الإذن',
      'microphone_required': 'يُطلب الوصول إلى الميكروفون.',
      'failed_to_process': 'فشل في معالجة طلبك. يرجى المحاولة مرة أخرى.',

      // Good/Bad feedback
      'good_feedback': 'نحن سعداء لأنك استمتعت!',
      'bad_feedback': 'نأسف للتجربة!',

      // Validation messages
      'high_ratings_negative_comments':
      'لقد أعطيت تقييمات عالية ولكن تعليقاتك تبدو سلبية. يرجى إعادة التحقق من استطلاعك.',
      'high_ratings_no_recommend':
      'لقد أعطيت تقييمات عالية، لكنك لن تنصح بنا. يرجى إعادة التحقق من استطلاعك',
      'low_ratings_positive_comments':
      'لقد أعطيت تقييمات منخفضة ولكن تعليقاتك تبدو إيجابية. يرجى إعادة التحقق من استطلاعك.',
      'low_ratings_yes_recommend':
      'لقد أعطيت تقييمات منخفضة، لكنك تنصح بنا. يرجى إعادة التحقق من استطلاعك',
    },
  };
}
