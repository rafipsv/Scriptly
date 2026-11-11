import '../../core/conversion_options.dart';
import '../../unicode/unicode_utils.dart';
import 'bengali_constants.dart';
import 'bengali_phonetic_rules.dart';

/// Engine responsible for romanizing Bengali script to Latin text.
class BengaliToLatinConverter {
  /// Reverse lookup dictionary built from common words.
  static final Map<String, String> _reverseCommonWords = () {
    final map = <String, String>{};
    for (final entry in BengaliPhoneticRules.commonWords.entries) {
      // Map Bengali text to properly formatted Banglish representation
      final key = entry.value;
      if (!map.containsKey(key)) {
        map[key] = _formatWord(entry.key);
      }
    }
    return map;
  }();

  static String _formatWord(String word) {
    if (word.isEmpty) return word;
    // Common proper nouns to capitalize
    const properNouns = {
      'dhaka',
      'bangladesh',
      'bangla',
      'ami',
      'bhalo',
      'kemon',
    };
    if (properNouns.contains(word)) {
      return word[0].toUpperCase() + word.substring(1);
    }
    return word;
  }

  /// Converts Bengali script [input] to Latin romanization.
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

      // Check for Bengali Danda
      if (codeUnit == 0x0964) {
        buffer.write('.');
        i++;
        continue;
      }

      // Check for non-Bengali characters & standard punctuation
      if (!UnicodeUtils.isBengaliCodePoint(codeUnit)) {
        buffer.writeCharCode(codeUnit);
        i++;
        continue;
      }

      // Consume full Bengali word
      final wordStart = i;
      while (i < length &&
          UnicodeUtils.isBengaliCodePoint(input.codeUnitAt(i))) {
        i++;
      }
      final word = input.substring(wordStart, i);
      buffer.write(_romanizeWord(word, options));
    }

    var result = buffer.toString();

    // Sentence casing if requested
    if (options.capitalizationPolicy ==
        CapitalizationPolicy.matchSentenceCase) {
      result = _applySentenceCase(result);
    }

    return result;
  }

  String _romanizeWord(String word, ConversionOptions options) {
    if (word.isEmpty) return '';

    // 1. Direct reverse dictionary lookup
    if (_reverseCommonWords.containsKey(word)) {
      return _reverseCommonWords[word]!;
    }

    // 2. Check suffix match (e.g. word ending in \u09C7 for -e, \u09DF for -y)
    for (final entry in _reverseCommonWords.entries) {
      if (word.startsWith(entry.key)) {
        final remainder = word.substring(entry.key.length);
        final suffix = _romanizePhoneticSegment(remainder);
        return '${entry.value}$suffix';
      }
    }

    // 3. Rule-based romanization
    return _romanizePhoneticSegment(word);
  }

  String _romanizePhoneticSegment(String word) {
    final buffer = StringBuffer();
    final runes = word.runes.toList();
    final len = runes.length;
    var index = 0;

    while (index < len) {
      final rune = runes[index];
      final char = String.fromCharCode(rune);

      // Check for conjunct: Consonant + Hasanta + Consonant
      if (index + 2 < len && runes[index + 1] == 0x09CD) {
        final conjunct =
            char +
            String.fromCharCode(runes[index + 1]) +
            String.fromCharCode(runes[index + 2]);
        final romanConjunct = _conjunctToLatin(conjunct);
        if (romanConjunct != null) {
          buffer.write(romanConjunct);
          index += 3;
          continue;
        }
      }

      // Consonant + Hasanta (explicit virama)
      if (index + 1 < len && runes[index + 1] == 0x09CD) {
        buffer.write(_consonantToLatin(char));
        index += 2;
        continue;
      }

      // Vowel signs (Kar)
      final kar = _karToLatin(char);
      if (kar != null) {
        buffer.write(kar);
        index++;
        continue;
      }

      // Independent vowels
      final vowel = _vowelToLatin(char);
      if (vowel != null) {
        buffer.write(vowel);
        index++;
        continue;
      }

      // Modifiers
      if (char == BengaliConstants.anusvara) {
        buffer.write('ng');
        index++;
        continue;
      }
      if (char == BengaliConstants.khandaTa) {
        buffer.write('t');
        index++;
        continue;
      }
      if (char == BengaliConstants.visarga) {
        buffer.write('h');
        index++;
        continue;
      }
      if (char == BengaliConstants.candrabindu) {
        buffer.write('n');
        index++;
        continue;
      }

      // Consonants
      final cons = _consonantToLatin(char);
      if (cons != null) {
        buffer.write(cons);
        // Check if next character is a vowel sign or hasanta
        final hasNextKarOrVirama =
            (index + 1 < len) &&
            (_isKar(runes[index + 1]) || runes[index + 1] == 0x09CD);

        // If at word end or next is another consonant, add inherent vowel in certain contexts
        if (!hasNextKarOrVirama && index + 1 < len) {
          final nextRune = runes[index + 1];
          if (_isConsonant(nextRune)) {
            // Optional inherent vowel o/a
            buffer.write('o');
          }
        }
        index++;
        continue;
      }

      // Fallback
      buffer.write(char);
      index++;
    }

    return buffer.toString();
  }

  String? _conjunctToLatin(String conjunct) {
    const table = <String, String>{
      '${BengaliConstants.conK}${BengaliConstants.hasanta}${BengaliConstants.conSSh}':
          'kkh',
      '${BengaliConstants.conJ}${BengaliConstants.hasanta}${BengaliConstants.conNy}':
          'gg',
      '${BengaliConstants.conCh}${BengaliConstants.hasanta}${BengaliConstants.conChh}':
          'cch',
      '${BengaliConstants.conSh}${BengaliConstants.hasanta}${BengaliConstants.conCh}':
          'shch',
      '${BengaliConstants.conSSh}${BengaliConstants.hasanta}${BengaliConstants.conTT}':
          'st',
      '${BengaliConstants.conSSh}${BengaliConstants.hasanta}${BengaliConstants.conTTh}':
          'shth',
      '${BengaliConstants.conT}${BengaliConstants.hasanta}${BengaliConstants.conR}':
          'tr',
      '${BengaliConstants.conS}${BengaliConstants.hasanta}${BengaliConstants.conT}':
          'st',
      '${BengaliConstants.conN}${BengaliConstants.hasanta}${BengaliConstants.conT}':
          'nt',
      '${BengaliConstants.conN}${BengaliConstants.hasanta}${BengaliConstants.conD}':
          'nd',
      '${BengaliConstants.conM}${BengaliConstants.hasanta}${BengaliConstants.conP}':
          'mp',
      '${BengaliConstants.conM}${BengaliConstants.hasanta}${BengaliConstants.conB}':
          'mb',
      '${BengaliConstants.conM}${BengaliConstants.hasanta}${BengaliConstants.conBh}':
          'mbh',
      '${BengaliConstants.conD}${BengaliConstants.hasanta}${BengaliConstants.conR}':
          'dr',
    };
    return table[conjunct];
  }

  bool _isKar(int rune) {
    return rune >= 0x09BE && rune <= 0x09CC;
  }

  bool _isConsonant(int rune) {
    return (rune >= 0x0995 && rune <= 0x09B9) ||
        (rune >= 0x09DC && rune <= 0x09DF);
  }

  String? _karToLatin(String char) {
    switch (char) {
      case BengaliConstants.karAa:
        return 'a';
      case BengaliConstants.karI:
        return 'i';
      case BengaliConstants.karEe:
        return 'i';
      case BengaliConstants.karU:
        return 'u';
      case BengaliConstants.karOo:
        return 'u';
      case BengaliConstants.karRri:
        return 'ri';
      case BengaliConstants.karE:
        return 'e';
      case BengaliConstants.karOi:
        return 'oi';
      case BengaliConstants.karO:
        return 'o';
      case BengaliConstants.karOu:
        return 'ou';
      default:
        return null;
    }
  }

  String? _vowelToLatin(String char) {
    switch (char) {
      case BengaliConstants.vowelA:
        return 'a';
      case BengaliConstants.vowelAa:
        return 'A';
      case BengaliConstants.vowelI:
        return 'i';
      case BengaliConstants.vowelEe:
        return 'i';
      case BengaliConstants.vowelU:
        return 'u';
      case BengaliConstants.vowelOo:
        return 'u';
      case BengaliConstants.vowelRri:
        return 'ri';
      case BengaliConstants.vowelE:
        return 'e';
      case BengaliConstants.vowelOi:
        return 'oi';
      case BengaliConstants.vowelO:
        return 'o';
      case BengaliConstants.vowelOu:
        return 'ou';
      default:
        return null;
    }
  }

  String? _consonantToLatin(String char) {
    switch (char) {
      case BengaliConstants.conK:
        return 'k';
      case BengaliConstants.conKh:
        return 'kh';
      case BengaliConstants.conG:
        return 'g';
      case BengaliConstants.conGh:
        return 'gh';
      case BengaliConstants.conNg:
        return 'ng';
      case BengaliConstants.conCh:
        return 'ch';
      case BengaliConstants.conChh:
        return 'chh';
      case BengaliConstants.conJ:
        return 'j';
      case BengaliConstants.conJh:
        return 'jh';
      case BengaliConstants.conNy:
        return 'ny';
      case BengaliConstants.conTT:
        return 't';
      case BengaliConstants.conTTh:
        return 'th';
      case BengaliConstants.conDD:
        return 'd';
      case BengaliConstants.conDDh:
        return 'dh';
      case BengaliConstants.conNN:
        return 'n';
      case BengaliConstants.conT:
        return 't';
      case BengaliConstants.conTh:
        return 'th';
      case BengaliConstants.conD:
        return 'd';
      case BengaliConstants.conDh:
        return 'dh';
      case BengaliConstants.conN:
        return 'n';
      case BengaliConstants.conP:
        return 'p';
      case BengaliConstants.conPh:
        return 'ph';
      case BengaliConstants.conB:
        return 'b';
      case BengaliConstants.conBh:
        return 'bh';
      case BengaliConstants.conM:
        return 'm';
      case BengaliConstants.conZ:
        return 'z';
      case BengaliConstants.conR:
        return 'r';
      case BengaliConstants.conL:
        return 'l';
      case BengaliConstants.conSh:
        return 'sh';
      case BengaliConstants.conSSh:
        return 'sh';
      case BengaliConstants.conS:
        return 's';
      case BengaliConstants.conH:
        return 'h';
      case BengaliConstants.conRrh:
        return 'r';
      case BengaliConstants.conRrhh:
        return 'rh';
      case BengaliConstants.conY:
        return 'y';
      default:
        return null;
    }
  }

  String _applySentenceCase(String input) {
    if (input.isEmpty) return input;
    final regex = RegExp(r'(^|[.!?]\s+)([a-z])');
    return input.replaceAllMapped(regex, (match) {
      final prefix = match.group(1) ?? '';
      final char = match.group(2) ?? '';
      return '$prefix${char.toUpperCase()}';
    });
  }
}
