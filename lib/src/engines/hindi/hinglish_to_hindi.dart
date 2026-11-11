import '../../core/conversion_options.dart';
import 'hindi_constants.dart';

/// Converts Latin/Hinglish text to Devanagari (Hindi) script.
class HinglishToHindiConverter {
  static final Map<String, String> commonWords = {
    'namaste':
        '${DevanagariConstants.conN}${DevanagariConstants.conM}${DevanagariConstants.conS}${DevanagariConstants.virama}${DevanagariConstants.conT}${DevanagariConstants.matraE}',
    'namaskar':
        '${DevanagariConstants.conN}${DevanagariConstants.conM}${DevanagariConstants.conS}${DevanagariConstants.virama}${DevanagariConstants.conK}${DevanagariConstants.matraAa}${DevanagariConstants.conR}',
    'aap': '${DevanagariConstants.vowelAa}${DevanagariConstants.conP}',
    'kaise':
        '${DevanagariConstants.conK}${DevanagariConstants.matraAi}${DevanagariConstants.conS}${DevanagariConstants.matraE}',
    'kaisa':
        '${DevanagariConstants.conK}${DevanagariConstants.matraAi}${DevanagariConstants.conS}${DevanagariConstants.matraAa}',
    'kya':
        '${DevanagariConstants.conK}${DevanagariConstants.virama}${DevanagariConstants.conY}${DevanagariConstants.matraAa}',
    'haal':
        '${DevanagariConstants.conH}${DevanagariConstants.matraAa}${DevanagariConstants.conL}',
    'hai': '${DevanagariConstants.conH}${DevanagariConstants.matraAi}',
    'hain':
        '${DevanagariConstants.conH}${DevanagariConstants.matraAi}${DevanagariConstants.anusvara}',
    'shukriya':
        '${DevanagariConstants.conSh}${DevanagariConstants.matraU}${DevanagariConstants.conK}${DevanagariConstants.virama}${DevanagariConstants.conR}${DevanagariConstants.matraI}${DevanagariConstants.conY}${DevanagariConstants.matraAa}',
    'dhanyawad':
        '${DevanagariConstants.conDh}${DevanagariConstants.conN}${DevanagariConstants.virama}${DevanagariConstants.conY}${DevanagariConstants.conV}${DevanagariConstants.matraAa}${DevanagariConstants.conD}',
    'dhanyavad':
        '${DevanagariConstants.conDh}${DevanagariConstants.conN}${DevanagariConstants.virama}${DevanagariConstants.conY}${DevanagariConstants.conV}${DevanagariConstants.matraAa}${DevanagariConstants.conD}',
    'bharat':
        '${DevanagariConstants.conBh}${DevanagariConstants.matraAa}${DevanagariConstants.conR}${DevanagariConstants.conT}',
    'mera':
        '${DevanagariConstants.conM}${DevanagariConstants.matraE}${DevanagariConstants.conR}${DevanagariConstants.matraAa}',
    'naam':
        '${DevanagariConstants.conN}${DevanagariConstants.matraAa}${DevanagariConstants.conM}',
  };

  static const Map<String, String> independentVowels = {
    'aa': DevanagariConstants.vowelAa,
    'ee': DevanagariConstants.vowelEe,
    'oo': DevanagariConstants.vowelOo,
    'ai': DevanagariConstants.vowelAi,
    'au': DevanagariConstants.vowelAu,
    'ri': DevanagariConstants.vowelRi,
    'a': DevanagariConstants.vowelA,
    'A': DevanagariConstants.vowelAa,
    'i': DevanagariConstants.vowelI,
    'u': DevanagariConstants.vowelU,
    'e': DevanagariConstants.vowelE,
    'o': DevanagariConstants.vowelO,
  };

  static const Map<String, String> matras = {
    'aa': DevanagariConstants.matraAa,
    'ee': DevanagariConstants.matraEe,
    'oo': DevanagariConstants.matraOo,
    'ai': DevanagariConstants.matraAi,
    'au': DevanagariConstants.matraAu,
    'ri': DevanagariConstants.matraRi,
    'a': DevanagariConstants.matraAa,
    'A': DevanagariConstants.matraAa,
    'i': DevanagariConstants.matraI,
    'u': DevanagariConstants.matraU,
    'e': DevanagariConstants.matraE,
    'o': DevanagariConstants.matraO,
  };

  static const Map<String, String> consonants = {
    'kkh':
        '${DevanagariConstants.conK}${DevanagariConstants.virama}${DevanagariConstants.conSSh}',
    'kya':
        '${DevanagariConstants.conK}${DevanagariConstants.virama}${DevanagariConstants.conY}${DevanagariConstants.matraAa}',
    'kh': DevanagariConstants.conKh,
    'gh': DevanagariConstants.conGh,
    'ch': DevanagariConstants.conCh,
    'chh': DevanagariConstants.conChh,
    'jh': DevanagariConstants.conJh,
    'Th': DevanagariConstants.conTTh,
    'Dh': DevanagariConstants.conDDh,
    'th': DevanagariConstants.conTh,
    'dh': DevanagariConstants.conDh,
    'ph': DevanagariConstants.conPh,
    'bh': DevanagariConstants.conBh,
    'sh': DevanagariConstants.conSh,
    'Sh': DevanagariConstants.conSSh,
    'k': DevanagariConstants.conK,
    'g': DevanagariConstants.conG,
    'c': DevanagariConstants.conCh,
    'j': DevanagariConstants.conJ,
    'T': DevanagariConstants.conTT,
    'D': DevanagariConstants.conDD,
    'N': DevanagariConstants.conNN,
    't': DevanagariConstants.conT,
    'd': DevanagariConstants.conD,
    'n': DevanagariConstants.conN,
    'p': DevanagariConstants.conP,
    'f': DevanagariConstants.conPh,
    'b': DevanagariConstants.conB,
    'v': DevanagariConstants.conV,
    'w': DevanagariConstants.conV,
    'm': DevanagariConstants.conM,
    'y': DevanagariConstants.conY,
    'r': DevanagariConstants.conR,
    'l': DevanagariConstants.conL,
    's': DevanagariConstants.conS,
    'h': DevanagariConstants.conH,
  };

  String convert(
    String input, {
    ConversionOptions options = ConversionOptions.standard,
  }) {
    if (input.isEmpty) return input;
    final buffer = StringBuffer();
    final len = input.length;
    var i = 0;

    while (i < len) {
      final codeUnit = input.codeUnitAt(i);
      if (codeUnit == 0x20 ||
          codeUnit == 0x09 ||
          codeUnit == 0x0A ||
          codeUnit == 0x0D) {
        buffer.writeCharCode(codeUnit);
        i++;
        continue;
      }
      if (_isPunctuation(codeUnit)) {
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

  bool _isDelimiter(int codeUnit) =>
      codeUnit == 0x20 ||
      codeUnit == 0x09 ||
      codeUnit == 0x0A ||
      codeUnit == 0x0D ||
      _isPunctuation(codeUnit);

  bool _isPunctuation(int codeUnit) =>
      ((codeUnit >= 0x21 && codeUnit <= 0x2F) ||
      (codeUnit >= 0x3A && codeUnit <= 0x40) ||
      (codeUnit >= 0x5B && codeUnit <= 0x5D) ||
      (codeUnit >= 0x7B && codeUnit <= 0x7E));

  String _convertWord(String word) {
    final lower = word.toLowerCase();
    if (commonWords.containsKey(lower)) {
      return commonWords[lower]!;
    }

    final buffer = StringBuffer();
    final len = word.length;
    var index = 0;
    var previousWasConsonant = false;

    while (index < len) {
      final matchedCons = _matchLongest(word, index, consonants);
      final vowelMap = previousWasConsonant ? matras : independentVowels;
      final matchedVowel = _matchLongest(word, index, vowelMap);

      final cLen = matchedCons?.key.length ?? 0;
      final vLen = matchedVowel?.key.length ?? 0;

      if (cLen > 0 && cLen >= vLen) {
        buffer.write(matchedCons!.value);
        index += cLen;
        previousWasConsonant = true;
      } else if (vLen > 0) {
        buffer.write(matchedVowel!.value);
        index += vLen;
        previousWasConsonant = false;
      } else {
        buffer.write(word[index]);
        index++;
        previousWasConsonant = false;
      }
    }

    return buffer.toString();
  }

  MapEntry<String, String>? _matchLongest(
    String text,
    int start,
    Map<String, String> table,
  ) {
    final rem = text.substring(start);
    for (var len = 4; len >= 1; len--) {
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
