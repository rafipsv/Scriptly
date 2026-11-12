import 'dart:math' as math;

import 'language_script.dart';
import 'script_detector.dart';
import 'transliterator.dart';

/// Provides cross-script phonetic similarity, fuzzy matching, and Soundex hashing.
///
/// Enables searching native script records (e.g., Bengali, Hindi, Arabic)
/// using Latin/Phonetic queries, and vice-versa.
class PhoneticMatcher {
  PhoneticMatcher._();

  static final Transliterator _transliterator = Transliterator();

  /// Computes a cross-script phonetic similarity score between 0.0 (no match) and 1.0 (identical).
  static double similarity(
    String textA,
    String textB, {
    LanguageScript? scriptA,
    LanguageScript? scriptB,
  }) {
    final cleanA = textA.trim().toLowerCase();
    final cleanB = textB.trim().toLowerCase();

    if (cleanA.isEmpty && cleanB.isEmpty) return 1.0;
    if (cleanA.isEmpty || cleanB.isEmpty) return 0.0;
    if (cleanA == cleanB) return 1.0;

    final latinA = _normalizeToPhoneticLatin(cleanA, scriptA);
    final latinB = _normalizeToPhoneticLatin(cleanB, scriptB);

    if (latinA == latinB) return 1.0;

    // Check substring containment
    if (latinA.contains(latinB) || latinB.contains(latinA)) {
      final ratio =
          math.min(latinA.length, latinB.length) /
          math.max(latinA.length, latinB.length);
      return math.max(0.85, ratio);
    }

    final distance = _levenshteinDistance(latinA, latinB);
    final maxLen = math.max(latinA.length, latinB.length);
    if (maxLen == 0) return 1.0;

    return (1.0 - (distance / maxLen)).clamp(0.0, 1.0);
  }

  /// Determines if [query] matches [candidate] within the given [threshold] (default: 0.70).
  static bool isMatch(
    String query,
    String candidate, {
    double threshold = 0.70,
    LanguageScript? queryScript,
    LanguageScript? candidateScript,
  }) {
    final score = similarity(
      query,
      candidate,
      scriptA: queryScript,
      scriptB: candidateScript,
    );
    return score >= threshold;
  }

  /// Generates a standardized 4-character phonetic Soundex code for cross-script indexing.
  static String soundex(String text, {LanguageScript? script}) {
    final latin = _normalizeToPhoneticLatin(text.trim().toLowerCase(), script);
    if (latin.isEmpty) return '0000';

    final firstChar = latin[0].toUpperCase();
    final buffer = StringBuffer(firstChar);

    String? lastCode = _soundexChar(firstChar);

    for (var i = 1; i < latin.length && buffer.length < 4; i++) {
      final code = _soundexChar(latin[i]);
      if (code != null && code != '0' && code != lastCode) {
        buffer.write(code);
        lastCode = code;
      } else if (code == '0') {
        lastCode = null; // Vowels separate identical consecutive consonants
      }
    }

    while (buffer.length < 4) {
      buffer.write('0');
    }

    return buffer.toString();
  }

  static String _normalizeToPhoneticLatin(String text, LanguageScript? script) {
    var detectedScript = script;
    if (detectedScript == null) {
      final detection = ScriptDetector.detect(text);
      detectedScript = detection.script;
    }

    String latin;
    if (detectedScript == LanguageScript.latin) {
      latin = text;
    } else {
      try {
        final result = _transliterator.convert(
          text,
          from: detectedScript,
          to: LanguageScript.latin,
        );
        latin = result.text.toLowerCase();
      } catch (_) {
        latin = text;
      }
    }

    // Phonetic normalization for cross-script acoustic matching
    var norm = latin
        .replaceAll('sh', 's')
        .replaceAll('ch', 'c')
        .replaceAll('ph', 'f')
        .replaceAll('bh', 'b')
        .replaceAll('dh', 'd')
        .replaceAll('th', 't')
        .replaceAll('kh', 'k')
        .replaceAll('gh', 'g')
        .replaceAll('jh', 'j')
        .replaceAll('v', 'b')
        .replaceAll('z', 's')
        .replaceAll('c', 'k')
        .replaceAll('q', 'k')
        .replaceAll('y', 'i')
        .replaceAll('ee', 'i')
        .replaceAll('oo', 'u')
        .replaceAll('w', 'o')
        .replaceAllMapped(
          RegExp(r'(.)\1+'),
          (m) => m[1]!,
        ); // deduplicate repeated letters (e.g. kk -> k, aa -> a)

    return norm;
  }

  static String? _soundexChar(String char) {
    switch (char.toUpperCase()) {
      case 'B':
      case 'F':
      case 'P':
      case 'V':
        return '1';
      case 'C':
      case 'G':
      case 'J':
      case 'K':
      case 'Q':
      case 'S':
      case 'X':
      case 'Z':
        return '2';
      case 'D':
      case 'T':
        return '3';
      case 'L':
        return '4';
      case 'M':
      case 'N':
        return '5';
      case 'R':
        return '6';
      case 'A':
      case 'E':
      case 'I':
      case 'O':
      case 'U':
      case 'Y':
      case 'H':
      case 'W':
        return '0';
      default:
        return null;
    }
  }

  static int _levenshteinDistance(String s, String t) {
    if (s == t) return 0;
    if (s.isEmpty) return t.length;
    if (t.isEmpty) return s.length;

    List<int> v0 = List<int>.generate(t.length + 1, (i) => i);
    List<int> v1 = List<int>.filled(t.length + 1, 0);

    for (var i = 0; i < s.length; i++) {
      v1[0] = i + 1;
      for (var j = 0; j < t.length; j++) {
        final cost = (s[i] == t[j]) ? 0 : 1;
        v1[j + 1] = math.min(v1[j] + 1, math.min(v0[j + 1] + 1, v0[j] + cost));
      }
      final temp = v0;
      v0 = v1;
      v1 = temp;
    }

    return v0[t.length];
  }
}
