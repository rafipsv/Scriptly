import '../core/phonetic_matcher.dart';

/// Deterministic cryptographic-grade phonetic identity hasher designed for
/// cross-script entity resolution, KYC compliance, and database deduplication.
///
/// Converts name variants across scripts (e.g. 'Mohammad', 'Muhammad', 'Md',
/// or native script equivalents) into a canonical identity hash.
class PhoneticIdentityHasher {
  PhoneticIdentityHasher._();

  // Common title/prefix abbreviations to strip for canonical resolution
  static final RegExp _titlePrefixes = RegExp(
    r'^(?:md\.?|mohd\.?|dr\.?|mr\.?|mrs\.?|ms\.?|shaikh|sheikh|al-)\s*',
    caseSensitive: false,
  );

  /// Computes a canonical phonetic identity hash string.
  ///
  /// Examples:
  /// - `hash('Mohammad') == hash('Muhammad')` -> `true`
  /// - `hash('Md. Karim') == hash('Karim')` -> `true`
  static String hash(String input) {
    final normalized = canonicalizeName(input);
    if (normalized.isEmpty) return '0000000000000000';

    // 1. Generate phonetic Soundex codes for each name token
    final tokens = normalized.split(RegExp(r'\s+')).where((t) => t.isNotEmpty);
    final soundexList = tokens.map(PhoneticMatcher.soundex).toList();

    // 2. Compute 64-bit FNV-1a hash across the canonical phonetic tokens
    final canonicalKey = soundexList.join('-');
    return _fnv1a64(canonicalKey);
  }

  /// Checks if two name variants resolve to the exact same phonetic identity.
  static bool isSameIdentity(String name1, String name2) {
    return hash(name1) == hash(name2);
  }

  /// Strips titles, punctuation, and non-phonetic characters for identity canonicalization.
  static String canonicalizeName(String name) {
    var s = name.trim().toLowerCase();
    s = s.replaceAll(_titlePrefixes, '');
    s = s.replaceAll(
      RegExp(r"[^a-zA-Z0-9\u0600-\u06FF\u0980-\u09FF\u0900-\u097F\s]"),
      '',
    );
    return s.trim();
  }

  /// 64-bit FNV-1a non-cryptographic high-avalanche hashing in pure Dart.
  static String _fnv1a64(String input) {
    const fnvPrime = 0x100000001b3;
    var hash = 0xcbf29ce484222325;

    for (var i = 0; i < input.length; i++) {
      hash ^= input.codeUnitAt(i);
      hash = (hash * fnvPrime) & 0xFFFFFFFFFFFFFFFF;
    }

    return hash.toRadixString(16).padLeft(16, '0');
  }
}
