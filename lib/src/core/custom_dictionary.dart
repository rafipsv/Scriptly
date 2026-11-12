/// Manages custom word overrides and domain-specific terminology for transliteration.
///
/// Custom entries take highest priority, replacing matching source tokens
/// before the phonetic transliteration engine processes the remaining text.
class CustomDictionary {
  CustomDictionary._();

  static final Map<String, String> _globalEntries = <String, String>{};

  /// Sets or replaces the global custom dictionary.
  static void setGlobal(Map<String, String> entries) {
    _globalEntries
      ..clear()
      ..addAll(entries);
  }

  /// Registers a single key-value custom mapping.
  static void register(String sourceWord, String targetWord) {
    _globalEntries[sourceWord] = targetWord;
  }

  /// Removes a custom mapping.
  static void unregister(String sourceWord) {
    _globalEntries.remove(sourceWord);
  }

  /// Clears all global dictionary entries.
  static void clear() {
    _globalEntries.clear();
  }

  /// Returns an unmodifiable snapshot of global entries.
  static Map<String, String> get entries => Map.unmodifiable(_globalEntries);

  /// Applies custom dictionary substitutions on [text].
  ///
  /// Merges [localOverrides] over global entries. Longest keys match first.
  static String apply(String text, {Map<String, String>? localOverrides}) {
    if (text.isEmpty) return text;

    final combined = <String, String>{
      ..._globalEntries,
      ...?localOverrides,
    };

    if (combined.isEmpty) return text;

    // Sort keys by descending length to match longest compound phrases first
    final sortedKeys = combined.keys.toList()
      ..sort((a, b) => b.length.compareTo(a.length));

    var result = text;
    for (final key in sortedKeys) {
      final target = combined[key]!;
      // Escape for regex and match on word boundaries if key is alphanumeric
      final isAlphanumeric = RegExp(r'^\w+$').hasMatch(key);
      final pattern = isAlphanumeric ? '\\b${RegExp.escape(key)}\\b' : RegExp.escape(key);
      result = result.replaceAll(RegExp(pattern, caseSensitive: false), target);
    }

    return result;
  }
}
