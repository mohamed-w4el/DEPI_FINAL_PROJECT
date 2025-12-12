// lib/data/services/sentiment/english_stemmer.dart

import 'package:porter_2_stemmer/porter_2_stemmer.dart';

class EnglishStemmer {
  static final stemmer = Porter2Stemmer();

  /// Stem a single english word.
  /// Returns the stemmed form, or the original if empty.
  static String stem(String word) {
    if (word.isEmpty) return word;

    // The porter package expects lower-case input
    final lower = word.toLowerCase();

    // Remove non-letter characters around the token before stemming
    final cleaned = lower.replaceAll(RegExp(r'[^a-z]'), '');

    if (cleaned.isEmpty) return cleaned;

    return stemmer.stem(cleaned);
  }
}
