import '../../core/conversion_options.dart';
import '../../unicode/unicode_utils.dart';
import 'bengali_constants.dart';
import 'bengali_phonetic_rules.dart';

/// Engine responsible for transliterating Latin/Banglish input into Bengali script.
class BanglishToBengaliConverter {
  /// Converts [input] text from Latin/Banglish to Bengali script.
  String convert(
    String input, {
    ConversionOptions options = ConversionOptions.standard,
  }) {
    if (input.isEmpty) return input;

    final buffer = StringBuffer();
    final length = input.length;
    var i = 0;

    while (i < length) {
      final codeUnit = input.codeUnitAt(i);

      // Check for whitespace
      if (codeUnit == 0x20 ||
          codeUnit == 0x09 ||
          codeUnit == 0x0A ||
          codeUnit == 0x0D) {
        buffer.writeCharCode(codeUnit);
        i++;
        continue;
      }

      // Check for existing Bengali characters
      if (UnicodeUtils.isBengaliCodePoint(codeUnit)) {
        buffer.writeCharCode(codeUnit);
        i++;
        continue;
      }

      // Check for punctuation / non-alphanumeric (except phonetic triggers ` and ^)
      if (_isPunctuation(codeUnit)) {
        buffer.writeCharCode(codeUnit);
        i++;
        continue;
      }

      // Consume word token (letters, numbers, modifiers ` and ^)
      final wordStart = i;
      while (i < length && !_isDelimiter(input.codeUnitAt(i))) {
        i++;
      }
      final word = input.substring(wordStart, i);
      buffer.write(_convertWord(word, options));
    }

    var result = buffer.toString();
    if (options.digitPolicy == DigitPolicy.convertToTarget) {
      result = UnicodeUtils.convertAsciiDigitsToBengali(result);
    }
    return result;
  }

  bool _isDelimiter(int codeUnit) {
    if (codeUnit == 0x20 ||
        codeUnit == 0x09 ||
        codeUnit == 0x0A ||
        codeUnit == 0x0D) {
      return true;
    }
    return _isPunctuation(codeUnit);
  }

  bool _isPunctuation(int codeUnit) {
    // Keep grave accent (`) and caret (^) as phonetic modifiers inside words
    if (codeUnit == 0x60 || codeUnit == 0x5E) return false;

    // ASCII punctuation
    if ((codeUnit >= 0x21 && codeUnit <= 0x2F) ||
        (codeUnit >= 0x3A && codeUnit <= 0x40) ||
        (codeUnit >= 0x5B && codeUnit <= 0x5D) ||
        (codeUnit >= 0x7B && codeUnit <= 0x7E)) {
      return true;
    }
    return false;
  }

  String _convertWord(String word, ConversionOptions options) {
    if (word.isEmpty) return '';

    // If word is pure digits
    if (RegExp(r'^\d+$').hasMatch(word)) {
      return options.digitPolicy == DigitPolicy.convertToTarget
          ? UnicodeUtils.convertAsciiDigitsToBengali(word)
          : word;
    }

    final lower = word.toLowerCase();

    // 1. Direct dictionary match
    if (BengaliPhoneticRules.commonWords.containsKey(lower)) {
      return BengaliPhoneticRules.commonWords[lower]!;
    }

    // 2. Morphological suffix check with common base words
    // Suffixes: -e (ে), -y (য়), -er (ের), -te (তে), -ke (কে), -ra (রা), -der (দের), -o (ও)
    final suffixResult = _matchCommonWordWithSuffix(lower);
    if (suffixResult != null) {
      return suffixResult;
    }

    // 3. Phonetic parsing
    return _parsePhoneticWord(word);
  }

  String? _matchCommonWordWithSuffix(String lowerWord) {
    const suffixes = <String, String>{
      'e': BengaliConstants.karE,
      'y': BengaliConstants.conY,
      'er': '${BengaliConstants.karE}${BengaliConstants.conR}',
      'te': '${BengaliConstants.conT}${BengaliConstants.karE}',
      'ke': '${BengaliConstants.conK}${BengaliConstants.karE}',
      'ra': '${BengaliConstants.conR}${BengaliConstants.karAa}',
      'der':
          '${BengaliConstants.conD}${BengaliConstants.karE}${BengaliConstants.conR}',
      'ta': '${BengaliConstants.conTT}${BengaliConstants.karAa}',
      'to': '${BengaliConstants.conT}${BengaliConstants.karO}',
    };

    for (final entry in suffixes.entries) {
      if (lowerWord.endsWith(entry.key)) {
        final base = lowerWord.substring(
          0,
          lowerWord.length - entry.key.length,
        );
        if (BengaliPhoneticRules.commonWords.containsKey(base)) {
          return '${BengaliPhoneticRules.commonWords[base]}${entry.value}';
        }
      }
    }
    return null;
  }

  String _parsePhoneticWord(String word) {
    final buffer = StringBuffer();
    final len = word.length;
    var index = 0;
    var previousWasConsonant = false;

    while (index < len) {
      // 1. Try matching longest consonant / conjunct
      final matchedConsonant = _matchLongest(
        word,
        index,
        BengaliPhoneticRules.consonants,
      );

      // 2. Try matching vowel (signs if after consonant, independent otherwise)
      final vowelMap = previousWasConsonant
          ? BengaliPhoneticRules.vowelSigns
          : BengaliPhoneticRules.independentVowels;

      final matchedVowel = _matchLongest(word, index, vowelMap);

      // Prioritize the longer match
      final consLen = matchedConsonant?.key.length ?? 0;
      final vowelLen = matchedVowel?.key.length ?? 0;

      if (consLen > 0 && consLen >= vowelLen) {
        buffer.write(matchedConsonant!.value);
        index += consLen;
        previousWasConsonant = true;
      } else if (vowelLen > 0) {
        buffer.write(matchedVowel!.value);
        index += vowelLen;
        previousWasConsonant = false;
      } else {
        // Fallback: character not in tables, preserve as is
        buffer.write(word[index]);
        index++;
        previousWasConsonant = false;
      }
    }

    return buffer.toString();
  }

  MapEntry<String, String>? _matchLongest(
    String text,
    int startIndex,
    Map<String, String> table,
  ) {
    final remaining = text.substring(startIndex);
    // Find matching keys, sorted by length descending
    for (var len = 5; len >= 1; len--) {
      if (remaining.length >= len) {
        final candidate = remaining.substring(0, len);
        // Exact match
        if (table.containsKey(candidate)) {
          return MapEntry(candidate, table[candidate]!);
        }
        // Case-insensitive match for consonants if exact match fails
        final lower = candidate.toLowerCase();
        if (table.containsKey(lower)) {
          return MapEntry(candidate, table[lower]!);
        }
      }
    }
    return null;
  }
}
