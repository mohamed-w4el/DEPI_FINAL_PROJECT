import 'package:restaurant_user_app/data/services/sentiment/arabic_stemmer.dart';
import 'package:restaurant_user_app/data/services/sentiment/english_stemmer.dart';
import 'package:restaurant_user_app/data/services/sentiment/negative_keywords.dart';
import 'package:restaurant_user_app/data/services/sentiment/positive_keywords.dart';

class SentimentService {
  /// Detect if a text contains Arabic characters
  static bool isArabic(String text) {
    final arabicRegex = RegExp(r'[\u0600-\u06FF]+');
    return arabicRegex.hasMatch(text);
  }

  /// Split into words safely
  static List<String> tokenize(String text, {bool arabic = false}) {
    if (arabic) {
      return text
          .split(RegExp(r'\s+'))
          .map((w) => w.trim())
          .where((w) => w.isNotEmpty)
          .toList();
    } else {
      return text
          .toLowerCase()
          .split(RegExp(r'[^a-z]+'))
          .where((w) => w.isNotEmpty)
          .toList();
    }
  }

  /// Main sentiment checker
  static bool isNegative(String text) {
    if (text.trim().isEmpty) return false;

    final arabic = isArabic(text);
    final words = tokenize(text, arabic: arabic);

    for (var w in words) {
      final stem = arabic ? ArabicStemmer.stem(w) : EnglishStemmer.stem(w);

      final list = arabic ? arabicNegativeKeywords : englishNegativeKeywords;

      if (list.contains(stem)) {
        return true;
      }
    }

    return false;
  }

  static bool isPositive(String text) {
    if (text.trim().isEmpty) return false;

    final arabic = isArabic(text);
    final words = tokenize(text, arabic: arabic);

    for (var w in words) {
      final stem = arabic ? ArabicStemmer.stem(w) : EnglishStemmer.stem(w);

      final list = arabic ? arabicPositiveKeywords : englishPositiveKeywords;

      if (list.contains(stem)) return true;
    }
    return false;
  }
}
