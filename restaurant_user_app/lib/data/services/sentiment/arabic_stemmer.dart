class ArabicStemmer {
  static final List<String> prefixes = ["ال", "و", "ف", "ب", "ك", "ل"];

  static final List<String> suffixes = [
    "ه",
    "ها",
    "ك",
    "ي",
    "ات",
    "ون",
    "ين",
    "ان",
    "ة",
  ];

  static String stem(String word) {
    String w = word;

    // Remove Arabic tashkeel (diacritics)
    w = w.replaceAll(RegExp(r'[\u0610-\u061A\u064B-\u065F]'), "");

    // Remove prefixes
    for (var p in prefixes) {
      if (w.startsWith(p) && w.length > p.length + 2) {
        w = w.substring(p.length);
        break;
      }
    }

    // Remove suffixes
    for (var s in suffixes) {
      if (w.endsWith(s) && w.length > s.length + 2) {
        w = w.substring(0, w.length - s.length);
        break;
      }
    }

    return w;
  }
}
