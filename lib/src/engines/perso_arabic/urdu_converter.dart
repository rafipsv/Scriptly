import 'perso_arabic_constants.dart';

/// Bidirectional transliteration between Latin (Roman Urdu) and Urdu script.
class UrduConverter {
  static const Map<String, String> commonWords = {
    'khuda hafiz': '\u062E\u062F\u0627 \u062D\u0627\u0641\u0638',
    'khuda': '\u062E\u062F\u0627',
    'hafiz': '\u062D\u0627\u0641\u0638',
    'dost': '\u062F\u0648\u0633\u062A',
    'subah bakhair': '\u0635\u0628\u062D \u0628\u062E\u06CC\u0631',
    'shab bakhair': '\u0634\u0628 \u0628\u062E\u06CC\u0631',
    'kya':
        '${PersoArabicConstants.urduKeheh}${PersoArabicConstants.ya}${PersoArabicConstants.alif}',
    'haal':
        '${PersoArabicConstants.hha}${PersoArabicConstants.alif}${PersoArabicConstants.lam}',
    'hai':
        '${PersoArabicConstants.urduGolHe}${PersoArabicConstants.urduBariYe}',
    'hain':
        '${PersoArabicConstants.urduGolHe}${PersoArabicConstants.ya}${PersoArabicConstants.urduNoonGhunna}',
    'shukriya':
        '${PersoArabicConstants.sheen}${PersoArabicConstants.urduKeheh}${PersoArabicConstants.ra}${PersoArabicConstants.urduChhotiYe}${PersoArabicConstants.urduGolHe}',
    'aap':
        '${PersoArabicConstants.alifWithMadda}${PersoArabicConstants.urduPe}',
    'kaise':
        '${PersoArabicConstants.urduKeheh}${PersoArabicConstants.ya}${PersoArabicConstants.seen}${PersoArabicConstants.urduBariYe}',
    'theek':
        '${PersoArabicConstants.urduTte}${PersoArabicConstants.urduDoChashmiHe}${PersoArabicConstants.ya}${PersoArabicConstants.urduKeheh}',
    'salam':
        '${PersoArabicConstants.seen}${PersoArabicConstants.lam}${PersoArabicConstants.alif}${PersoArabicConstants.meem}',
    'urdu':
        '${PersoArabicConstants.alif}${PersoArabicConstants.ra}${PersoArabicConstants.dal}${PersoArabicConstants.waw}',
    'bohot': '\u0628\u06C1\u062A',
    'bahut': '\u0628\u06C1\u062A',
    'acha': '\u0627\u0686\u06BE\u0627',
    'kitab': '\u06A9\u062A\u0627\u0628',
    'shukran': '\u0634\u06A9\u0631\u0627',
  };

  static const Map<String, String> charMap = {
    'kh': PersoArabicConstants.kha,
    'gh': PersoArabicConstants.ghain,
    'sh': PersoArabicConstants.sheen,
    'ch': PersoArabicConstants.urduChe,
    'th': '${PersoArabicConstants.ta}${PersoArabicConstants.urduDoChashmiHe}',
    'ph':
        '${PersoArabicConstants.urduPe}${PersoArabicConstants.urduDoChashmiHe}',
    'bh': '${PersoArabicConstants.ba}${PersoArabicConstants.urduDoChashmiHe}',
    'jh': '${PersoArabicConstants.jeem}${PersoArabicConstants.urduDoChashmiHe}',
    'dh': '${PersoArabicConstants.dal}${PersoArabicConstants.urduDoChashmiHe}',
    'aa': PersoArabicConstants.alif,
    'ee': PersoArabicConstants.urduChhotiYe,
    'oo': PersoArabicConstants.waw,
    'a': PersoArabicConstants.alif,
    'b': PersoArabicConstants.ba,
    'p': PersoArabicConstants.urduPe,
    't': PersoArabicConstants.ta,
    'T': PersoArabicConstants.urduTte,
    'j': PersoArabicConstants.jeem,
    'd': PersoArabicConstants.dal,
    'D': PersoArabicConstants.urduDdal,
    'r': PersoArabicConstants.ra,
    'R': PersoArabicConstants.urduRre,
    'z': PersoArabicConstants.zain,
    's': PersoArabicConstants.seen,
    'f': PersoArabicConstants.fa,
    'q': PersoArabicConstants.qaf,
    'k': PersoArabicConstants.urduKeheh,
    'g': PersoArabicConstants.urduGaf,
    'l': PersoArabicConstants.lam,
    'm': PersoArabicConstants.meem,
    'n': PersoArabicConstants.noon,
    'w': PersoArabicConstants.waw,
    'v': PersoArabicConstants.waw,
    'h': PersoArabicConstants.urduGolHe,
    'y': PersoArabicConstants.ya,
    'i': PersoArabicConstants.urduChhotiYe,
    'e': PersoArabicConstants.urduBariYe,
    'u': PersoArabicConstants.waw,
    'o': PersoArabicConstants.waw,
  };

  String toUrdu(String input) {
    if (input.isEmpty) return input;
    final lowerTrimmed = input.toLowerCase().trim();
    if (commonWords.containsKey(lowerTrimmed)) {
      return commonWords[lowerTrimmed]!;
    }

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
      buffer.write(_urduCharToLatin(ch));
    }
    return buffer.toString();
  }

  String _urduCharToLatin(String ch) {
    switch (ch) {
      case PersoArabicConstants.alif:
      case PersoArabicConstants.alifWithMadda:
        return 'a';
      case PersoArabicConstants.ba:
        return 'b';
      case PersoArabicConstants.urduPe:
        return 'p';
      case PersoArabicConstants.ta:
        return 't';
      case PersoArabicConstants.urduTte:
        return 'T';
      case PersoArabicConstants.jeem:
        return 'j';
      case PersoArabicConstants.urduChe:
        return 'ch';
      case PersoArabicConstants.hha:
      case PersoArabicConstants.ha:
      case PersoArabicConstants.urduGolHe:
        return 'h';
      case PersoArabicConstants.kha:
        return 'kh';
      case PersoArabicConstants.dal:
        return 'd';
      case PersoArabicConstants.urduDdal:
        return 'D';
      case PersoArabicConstants.ra:
        return 'r';
      case PersoArabicConstants.urduRre:
        return 'R';
      case PersoArabicConstants.zain:
        return 'z';
      case PersoArabicConstants.seen:
        return 's';
      case PersoArabicConstants.sheen:
        return 'sh';
      case PersoArabicConstants.ghain:
        return 'gh';
      case PersoArabicConstants.fa:
        return 'f';
      case PersoArabicConstants.qaf:
        return 'q';
      case PersoArabicConstants.urduKeheh:
      case PersoArabicConstants.kaf:
        return 'k';
      case PersoArabicConstants.urduGaf:
        return 'g';
      case PersoArabicConstants.lam:
        return 'l';
      case PersoArabicConstants.meem:
        return 'm';
      case PersoArabicConstants.noon:
      case PersoArabicConstants.urduNoonGhunna:
        return 'n';
      case PersoArabicConstants.waw:
        return 'o';
      case PersoArabicConstants.urduChhotiYe:
        return 'i';
      case PersoArabicConstants.urduBariYe:
        return 'e';
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
        final sub = rem.substring(0, len);
        if (table.containsKey(sub)) return MapEntry(sub, table[sub]!);
        final lower = sub.toLowerCase();
        if (table.containsKey(lower)) return MapEntry(sub, table[lower]!);
      }
    }
    return null;
  }
}
