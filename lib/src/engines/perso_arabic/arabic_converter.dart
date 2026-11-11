import 'perso_arabic_constants.dart';

/// Bidirectional transliteration between Latin (Arabizi) and Arabic script.
class ArabicConverter {
  static const Map<String, String> commonWords = {
    'marhaban':
        '${PersoArabicConstants.meem}${PersoArabicConstants.ra}${PersoArabicConstants.hha}${PersoArabicConstants.ba}${PersoArabicConstants.alif}',
    'shukran':
        '${PersoArabicConstants.sheen}${PersoArabicConstants.kaf}${PersoArabicConstants.ra}${PersoArabicConstants.alif}',
    'salam':
        '${PersoArabicConstants.seen}${PersoArabicConstants.lam}${PersoArabicConstants.alif}${PersoArabicConstants.meem}',
    'ahlan':
        '${PersoArabicConstants.alifWithHamzaAbove}${PersoArabicConstants.ha}${PersoArabicConstants.lam}${PersoArabicConstants.alif}',
    'kayfa':
        '${PersoArabicConstants.kaf}${PersoArabicConstants.ya}${PersoArabicConstants.fa}',
    'haluka':
        '${PersoArabicConstants.hha}${PersoArabicConstants.alif}${PersoArabicConstants.lam}${PersoArabicConstants.kaf}',
    'naam':
        '${PersoArabicConstants.noon}${PersoArabicConstants.ain}${PersoArabicConstants.meem}',
    'la': '${PersoArabicConstants.lam}${PersoArabicConstants.alif}',
  };

  static const Map<String, String> charMap = {
    'sh': PersoArabicConstants.sheen,
    'th': PersoArabicConstants.tha,
    'kh': PersoArabicConstants.kha,
    'dh': PersoArabicConstants.thal,
    'gh': PersoArabicConstants.ghain,
    'ch': PersoArabicConstants.sheen,
    'aa': PersoArabicConstants.alif,
    'ee': PersoArabicConstants.ya,
    'oo': PersoArabicConstants.waw,
    'a': PersoArabicConstants.alif,
    'b': PersoArabicConstants.ba,
    't': PersoArabicConstants.ta,
    'j': PersoArabicConstants.jeem,
    'h': PersoArabicConstants.ha,
    'd': PersoArabicConstants.dal,
    'r': PersoArabicConstants.ra,
    'z': PersoArabicConstants.zain,
    's': PersoArabicConstants.seen,
    'f': PersoArabicConstants.fa,
    'q': PersoArabicConstants.qaf,
    'k': PersoArabicConstants.kaf,
    'l': PersoArabicConstants.lam,
    'm': PersoArabicConstants.meem,
    'n': PersoArabicConstants.noon,
    'w': PersoArabicConstants.waw,
    'y': PersoArabicConstants.ya,
    'i': PersoArabicConstants.ya,
    'u': PersoArabicConstants.waw,
    'o': PersoArabicConstants.waw,
    'e': PersoArabicConstants.ya,
  };

  String toArabic(String input) {
    if (input.isEmpty) return input;
    final buffer = StringBuffer();
    final len = input.length;
    var i = 0;

    while (i < len) {
      final codeUnit = input.codeUnitAt(i);
      if (codeUnit == 0x20 ||
          codeUnit == 0x09 ||
          codeUnit == 0x0A ||
          codeUnit == 0x0D ||
          _isPunctuation(codeUnit)) {
        buffer.writeCharCode(codeUnit);
        i++;
        continue;
      }

      final start = i;
      while (i < len && !_isDelimiter(input.codeUnitAt(i))) {
        i++;
      }
      final word = input.substring(start, i);
      buffer.write(_convertWord(word));
    }

    return buffer.toString();
  }

  bool _isDelimiter(int c) =>
      c == 0x20 || c == 0x09 || c == 0x0A || c == 0x0D || _isPunctuation(c);

  bool _isPunctuation(int c) =>
      ((c >= 0x21 && c <= 0x2F) ||
      (c >= 0x3A && c <= 0x40) ||
      (c >= 0x5B && c <= 0x5D) ||
      (c >= 0x7B && c <= 0x7E));

  String _convertWord(String word) {
    final lower = word.toLowerCase();
    if (commonWords.containsKey(lower)) {
      return commonWords[lower]!;
    }

    final buffer = StringBuffer();
    final len = word.length;
    var index = 0;

    while (index < len) {
      final matched = _matchLongest(word, index, charMap);
      if (matched != null) {
        buffer.write(matched.value);
        index += matched.key.length;
      } else {
        buffer.write(word[index]);
        index++;
      }
    }
    return buffer.toString();
  }

  String toLatin(String input) {
    if (input.isEmpty) return input;
    for (final entry in commonWords.entries) {
      if (input == entry.value) {
        return entry.key[0].toUpperCase() + entry.key.substring(1);
      }
    }

    final buffer = StringBuffer();
    for (final rune in input.runes) {
      final ch = String.fromCharCode(rune);
      buffer.write(_arabicCharToLatin(ch));
    }
    return buffer.toString();
  }

  String _arabicCharToLatin(String ch) {
    switch (ch) {
      case PersoArabicConstants.alif:
      case PersoArabicConstants.alifWithHamzaAbove:
      case PersoArabicConstants.alifWithMadda:
        return 'a';
      case PersoArabicConstants.ba:
        return 'b';
      case PersoArabicConstants.ta:
        return 't';
      case PersoArabicConstants.tha:
        return 'th';
      case PersoArabicConstants.jeem:
        return 'j';
      case PersoArabicConstants.hha:
      case PersoArabicConstants.ha:
        return 'h';
      case PersoArabicConstants.kha:
        return 'kh';
      case PersoArabicConstants.dal:
        return 'd';
      case PersoArabicConstants.thal:
        return 'dh';
      case PersoArabicConstants.ra:
        return 'r';
      case PersoArabicConstants.zain:
        return 'z';
      case PersoArabicConstants.seen:
        return 's';
      case PersoArabicConstants.sheen:
        return 'sh';
      case PersoArabicConstants.sad:
        return 's';
      case PersoArabicConstants.dad:
        return 'd';
      case PersoArabicConstants.tah:
        return 't';
      case PersoArabicConstants.zah:
        return 'z';
      case PersoArabicConstants.ain:
        return 'a';
      case PersoArabicConstants.ghain:
        return 'gh';
      case PersoArabicConstants.fa:
        return 'f';
      case PersoArabicConstants.qaf:
        return 'q';
      case PersoArabicConstants.kaf:
        return 'k';
      case PersoArabicConstants.lam:
        return 'l';
      case PersoArabicConstants.meem:
        return 'm';
      case PersoArabicConstants.noon:
        return 'n';
      case PersoArabicConstants.waw:
        return 'w';
      case PersoArabicConstants.ya:
        return 'y';
      default:
        return ch;
    }
  }

  MapEntry<String, String>? _matchLongest(
    String text,
    int start,
    Map<String, String> table,
  ) {
    final rem = text.substring(start);
    for (var len = 2; len >= 1; len--) {
      if (rem.length >= len) {
        final sub = rem.substring(0, len).toLowerCase();
        if (table.containsKey(sub)) return MapEntry(sub, table[sub]!);
      }
    }
    return null;
  }
}
