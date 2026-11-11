import '../../core/conversion_options.dart';
import 'hindi_constants.dart';
import 'hinglish_to_hindi.dart';

/// Converts Devanagari (Hindi) script text to Latin romanization.
class HindiToLatinConverter {
  static final Map<String, String> _reverseWords = () {
    final map = <String, String>{};
    for (final entry in HinglishToHindiConverter.commonWords.entries) {
      final key = entry.value;
      if (!map.containsKey(key)) {
        final w = entry.key;
        map[key] = w.length > 1 && (w == 'namaste' || w == 'bharat')
            ? w[0].toUpperCase() + w.substring(1)
            : w;
      }
    }
    return map;
  }();

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

      if (!_isDevanagari(codeUnit)) {
        buffer.writeCharCode(codeUnit);
        i++;
        continue;
      }

      final start = i;
      while (i < len && _isDevanagari(input.codeUnitAt(i))) {
        i++;
      }
      final word = input.substring(start, i);
      buffer.write(_romanizeWord(word));
    }

    return buffer.toString();
  }

  bool _isDevanagari(int codeUnit) => codeUnit >= 0x0900 && codeUnit <= 0x097F;

  String _romanizeWord(String word) {
    if (_reverseWords.containsKey(word)) {
      return _reverseWords[word]!;
    }

    final buffer = StringBuffer();
    final runes = word.runes.toList();
    final len = runes.length;
    var index = 0;

    while (index < len) {
      final rune = runes[index];
      final char = String.fromCharCode(rune);

      // Virama handling
      if (index + 1 < len && runes[index + 1] == 0x094D) {
        buffer.write(_consonantToLatin(char));
        index += 2;
        continue;
      }

      final matra = _matraToLatin(char);
      if (matra != null) {
        buffer.write(matra);
        index++;
        continue;
      }

      final vowel = _vowelToLatin(char);
      if (vowel != null) {
        buffer.write(vowel);
        index++;
        continue;
      }

      if (char == DevanagariConstants.anusvara) {
        buffer.write('n');
        index++;
        continue;
      }

      final cons = _consonantToLatin(char);
      if (cons != null) {
        buffer.write(cons);
        final hasNextMatraOrHalant =
            index + 1 < len &&
            ((runes[index + 1] >= 0x093E && runes[index + 1] <= 0x094C) ||
                runes[index + 1] == 0x094D);
        if (!hasNextMatraOrHalant &&
            index + 1 < len &&
            _isConsonantRune(runes[index + 1])) {
          buffer.write('a');
        }
        index++;
        continue;
      }

      buffer.write(char);
      index++;
    }

    return buffer.toString();
  }

  bool _isConsonantRune(int r) => r >= 0x0915 && r <= 0x0939;

  String? _matraToLatin(String c) {
    switch (c) {
      case DevanagariConstants.matraAa:
        return 'a';
      case DevanagariConstants.matraI:
        return 'i';
      case DevanagariConstants.matraEe:
        return 'ee';
      case DevanagariConstants.matraU:
        return 'u';
      case DevanagariConstants.matraOo:
        return 'oo';
      case DevanagariConstants.matraRi:
        return 'ri';
      case DevanagariConstants.matraE:
        return 'e';
      case DevanagariConstants.matraAi:
        return 'ai';
      case DevanagariConstants.matraO:
        return 'o';
      case DevanagariConstants.matraAu:
        return 'au';
      default:
        return null;
    }
  }

  String? _vowelToLatin(String c) {
    switch (c) {
      case DevanagariConstants.vowelA:
        return 'a';
      case DevanagariConstants.vowelAa:
        return 'A';
      case DevanagariConstants.vowelI:
        return 'i';
      case DevanagariConstants.vowelEe:
        return 'ee';
      case DevanagariConstants.vowelU:
        return 'u';
      case DevanagariConstants.vowelOo:
        return 'oo';
      case DevanagariConstants.vowelRi:
        return 'ri';
      case DevanagariConstants.vowelE:
        return 'e';
      case DevanagariConstants.vowelAi:
        return 'ai';
      case DevanagariConstants.vowelO:
        return 'o';
      case DevanagariConstants.vowelAu:
        return 'au';
      default:
        return null;
    }
  }

  String? _consonantToLatin(String c) {
    switch (c) {
      case DevanagariConstants.conK:
        return 'k';
      case DevanagariConstants.conKh:
        return 'kh';
      case DevanagariConstants.conG:
        return 'g';
      case DevanagariConstants.conGh:
        return 'gh';
      case DevanagariConstants.conNg:
        return 'ng';
      case DevanagariConstants.conCh:
        return 'ch';
      case DevanagariConstants.conChh:
        return 'chh';
      case DevanagariConstants.conJ:
        return 'j';
      case DevanagariConstants.conJh:
        return 'jh';
      case DevanagariConstants.conNy:
        return 'ny';
      case DevanagariConstants.conTT:
        return 't';
      case DevanagariConstants.conTTh:
        return 'th';
      case DevanagariConstants.conDD:
        return 'd';
      case DevanagariConstants.conDDh:
        return 'dh';
      case DevanagariConstants.conNN:
        return 'n';
      case DevanagariConstants.conT:
        return 't';
      case DevanagariConstants.conTh:
        return 'th';
      case DevanagariConstants.conD:
        return 'd';
      case DevanagariConstants.conDh:
        return 'dh';
      case DevanagariConstants.conN:
        return 'n';
      case DevanagariConstants.conP:
        return 'p';
      case DevanagariConstants.conPh:
        return 'ph';
      case DevanagariConstants.conB:
        return 'b';
      case DevanagariConstants.conBh:
        return 'bh';
      case DevanagariConstants.conM:
        return 'm';
      case DevanagariConstants.conY:
        return 'y';
      case DevanagariConstants.conR:
        return 'r';
      case DevanagariConstants.conL:
        return 'l';
      case DevanagariConstants.conV:
        return 'v';
      case DevanagariConstants.conSh:
        return 'sh';
      case DevanagariConstants.conSSh:
        return 'sh';
      case DevanagariConstants.conS:
        return 's';
      case DevanagariConstants.conH:
        return 'h';
      default:
        return null;
    }
  }
}
