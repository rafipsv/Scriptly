import '../../core/conversion_request.dart';
import '../../core/conversion_result.dart';
import '../../core/errors.dart';
import '../../core/language_script.dart';
import '../../core/transliterator_engine.dart';

/// Transliterator engine for Amharic / Ge'ez Fidel script (`am-Ethi`).
class AmharicEngine implements TransliteratorEngine {
  @override
  String get id => 'amharic-fidel-engine';

  @override
  String get scheme => 'bgn-pcgn-ethiopic';

  @override
  String get version => '0.5.0';

  static const Map<String, String> commonPhrases = {
    'selam': '\u1230\u120B\u121D', // ሰላም
    'ameseginalehu': '\u12A0\u1218\u1230\u130D\u1293\u1208\u1201', // አመሰግናለሁ
    'addis ababa': '\u12A0\u12F2\u1235 \u12A0\u1260\u1263', // አዲስ አበባ
    'ethiopia': '\u12A2\u1275\u12EE\u1335\u12EB', // ኢትዮጵያ
    'tadias': '\u1273\u12F2\u12EB\u1235', // ታዲያስ
  };

  static const Map<String, String> fidelTable = {
    // 2-character / 3-character syllables
    'haa': '\u1203', 'hu': '\u1201', 'hi': '\u1202', 'he': '\u1204', 'ho': '\u1206', 'ha': '\u1200',
    'laa': '\u120B', 'lu': '\u1209', 'li': '\u120A', 'le': '\u120C', 'lo': '\u120E', 'la': '\u1208',
    'maa': '\u1213', 'mu': '\u1211', 'mi': '\u1212', 'me': '\u1214', 'mo': '\u1216', 'ma': '\u1210',
    'saa': '\u1233', 'su': '\u1231', 'si': '\u1232', 'se': '\u1234', 'so': '\u1236', 'sa': '\u1230',
    'raa': '\u122B', 'ru': '\u1229', 'ri': '\u122A', 're': '\u122C', 'ro': '\u122E', 'ra': '\u1228',
    'baa': '\u1263', 'bu': '\u1261', 'bi': '\u1262', 'be': '\u1264', 'bo': '\u1266', 'ba': '\u1260',
    'taa': '\u1273', 'tu': '\u1271', 'ti': '\u1272', 'te': '\u1274', 'to': '\u1276', 'ta': '\u1270',
    'naa': '\u1293', 'nu': '\u1291', 'ni': '\u1292', 'ne': '\u1294', 'no': '\u1296', 'na': '\u1290',
    // 6th order consonants (alone / sadəs)
    'h': '\u1205', 'l': '\u120D', 'm': '\u1215', 's': '\u1235',
    'r': '\u122D', 'b': '\u1265', 't': '\u1275', 'n': '\u1295',
  };

  @override
  bool supports(LanguageScript from, LanguageScript to) {
    final f = from.normalizedLanguage;
    final t = to.normalizedLanguage;
    final fS = from.normalizedScript;
    final tS = to.normalizedScript;

    return (fS == 'Latn' && t == 'am' && tS == 'Ethi') ||
        (f == 'am' && fS == 'Ethi' && tS == 'Latn');
  }

  @override
  ConversionResult convert(ConversionRequest request) {
    if (!supports(request.from, request.to)) {
      throw UnsupportedConversionException(request.from, request.to);
    }

    final isFromLatin = request.from.normalizedScript == 'Latn';
    final text = request.text;

    final output = isFromLatin ? _toFidel(text) : _toLatin(text);

    return ConversionResult(
      text: output,
      sourceText: text,
      from: request.from,
      to: request.to,
      scheme: isFromLatin ? 'latin-to-amharic' : 'amharic-to-latin',
    );
  }

  String _toFidel(String input) {
    final lower = input.toLowerCase().trim();
    if (commonPhrases.containsKey(lower)) {
      return commonPhrases[lower]!;
    }

    final buffer = StringBuffer();
    final len = input.length;
    var index = 0;

    while (index < len) {
      String? matchedKey;
      String? matchedVal;

      for (var k = 3; k >= 1; k--) {
        if (index + k <= len) {
          final sub = input.substring(index, index + k).toLowerCase();
          if (fidelTable.containsKey(sub)) {
            matchedKey = sub;
            matchedVal = fidelTable[sub];
            break;
          }
        }
      }

      if (matchedKey != null && matchedVal != null) {
        buffer.write(matchedVal);
        index += matchedKey.length;
      } else {
        buffer.write(input[index]);
        index++;
      }
    }
    return buffer.toString();
  }

  String _toLatin(String input) {
    for (final entry in commonPhrases.entries) {
      if (input.trim() == entry.value) {
        final k = entry.key;
        return k[0].toUpperCase() + k.substring(1);
      }
    }

    final inverted = <String, String>{};
    for (final e in fidelTable.entries) {
      inverted.putIfAbsent(e.value, () => e.key);
    }

    final buffer = StringBuffer();
    for (var i = 0; i < input.length; i++) {
      final ch = input[i];
      buffer.write(inverted[ch] ?? ch);
    }
    return buffer.toString();
  }
}
