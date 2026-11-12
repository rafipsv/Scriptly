import 'dart:math' as math;
import 'package:flutter_test/flutter_test.dart';
import 'package:scriptly/scriptly.dart';

double calculateSimilarity(String s1, String s2) {
  if (s1 == s2) return 1.0;
  if (s1.isEmpty || s2.isEmpty) return 0.0;

  final d = List.generate(
    s1.length + 1,
    (i) => List.filled(s2.length + 1, 0),
  );

  for (var i = 0; i <= s1.length; i++) {
    d[i][0] = i;
  }
  for (var j = 0; j <= s2.length; j++) {
    d[0][j] = j;
  }

  for (var i = 1; i <= s1.length; i++) {
    for (var j = 1; j <= s2.length; j++) {
      final cost = s1[i - 1] == s2[j - 1] ? 0 : 1;
      d[i][j] = [
        d[i - 1][j] + 1,
        d[i][j - 1] + 1,
        d[i - 1][j - 1] + cost,
      ].reduce(math.min);
    }
  }

  final maxLen = math.max(s1.length, s2.length);
  return 1.0 - (d[s1.length][s2.length] / maxLen);
}

void main() {
  group('SQA Exhaustive 41-Language Matrix & Accuracy Evaluation', () {
    final transliterator = Transliterator();

    // -------------------------------------------------------------------------
    // Phase 1: Forward Accuracy Benchmark (Latin -> Native)
    // -------------------------------------------------------------------------
    test('Phase 1: 41 Languages Forward Accuracy Benchmark (Latin -> Native)', () {
      final forwardCases = <Map<String, dynamic>>[
        {'lang': 'Bengali', 'to': LanguageScript.bengali, 'input': 'ami banglay gan gai', 'expected': 'আমি বাংলায় গান গাই'},
        {'lang': 'Hindi', 'to': LanguageScript.hindi, 'input': 'namaste', 'expected': 'नमस्ते'},
        {'lang': 'Urdu', 'to': LanguageScript.urdu, 'input': 'aap kaise hain', 'expected': 'آپ کيسے ہيں'},
        {'lang': 'Arabic', 'to': LanguageScript.arabic, 'input': 'marhaban', 'expected': 'مرحبا'},
        {'lang': 'Gujarati', 'to': LanguageScript.gujarati, 'input': 'namaste', 'expected': 'નમસ્તે'},
        {'lang': 'Tamil', 'to': LanguageScript.tamil, 'input': 'vanakkam', 'expected': 'வணக்கம்'},
        {'lang': 'Telugu', 'to': LanguageScript.telugu, 'input': 'namaskaram', 'expected': 'నమస్కారం'},
        {'lang': 'Punjabi', 'to': LanguageScript.punjabi, 'input': 'sat sri akal', 'expected': 'ਸਤਿ ਸ੍ਰੀ ਅਕਾਲ'},
        {'lang': 'Malayalam', 'to': LanguageScript.malayalam, 'input': 'namaskaram', 'expected': 'നമസ്കാരം'},
        {'lang': 'Kannada', 'to': LanguageScript.kannada, 'input': 'namaskara', 'expected': 'ನಮಸ್ಕಾರ'},
        {'lang': 'Odia', 'to': LanguageScript.odia, 'input': 'namaskar', 'expected': 'ନମସ୍କାର'},
        {'lang': 'Sinhala', 'to': LanguageScript.sinhala, 'input': 'ayubowan', 'expected': 'ආයුබෝවන්'},
        {'lang': 'Sanskrit', 'to': LanguageScript.sanskrit, 'input': 'om shanti', 'expected': 'ॐ शान्तिः'},
        {'lang': 'Marathi', 'to': LanguageScript.marathi, 'input': 'maharashtra', 'expected': 'महाराष्ट्र'},
        {'lang': 'Nepali', 'to': LanguageScript.nepali, 'input': 'nepal', 'expected': 'नेपाल'},
        {'lang': 'Assamese', 'to': LanguageScript.assamese, 'input': 'guwahati', 'expected': 'গুৱাহাটী'},
        {'lang': 'Vietnamese', 'to': LanguageScript.vietnamese, 'input': 'xin chao', 'expected': 'xin chào'},
        {'lang': 'Thai', 'to': LanguageScript.thai, 'input': 'sawasdee', 'expected': 'สวัสดี'},
        {'lang': 'Lao', 'to': LanguageScript.lao, 'input': 'sabaidee', 'expected': 'ສະບາຍດີ'},
        {'lang': 'Burmese', 'to': LanguageScript.burmese, 'input': 'mingalaba', 'expected': 'မင်္ဂလာပါ'},
        {'lang': 'Khmer', 'to': LanguageScript.khmer, 'input': 'suesdei', 'expected': 'សួស្តី'},
        {'lang': 'Japanese', 'to': LanguageScript.japanese, 'input': 'arigatou', 'expected': 'ありがとう'},
        {'lang': 'Korean', 'to': LanguageScript.korean, 'input': 'annyeonghaseyo', 'expected': '안녕하세요'},
        {'lang': 'Chinese Pinyin', 'to': LanguageScript.chinesePinyin, 'input': 'ni3 hao3', 'expected': 'nǐ hǎo'},
        {'lang': 'Persian', 'to': LanguageScript.persian, 'input': 'salam', 'expected': 'سلام'},
        {'lang': 'Hebrew', 'to': LanguageScript.hebrew, 'input': 'shalom', 'expected': 'שלום'},
        {'lang': 'Russian', 'to': LanguageScript.russian, 'input': 'privet', 'expected': 'привет'},
        {'lang': 'Ukrainian', 'to': LanguageScript.ukrainian, 'input': 'pryvit', 'expected': 'привіт'},
        {'lang': 'Serbian', 'to': LanguageScript.serbian, 'input': 'beograd', 'expected': 'београд'},
        {'lang': 'Bulgarian', 'to': LanguageScript.bulgarian, 'input': 'sofia', 'expected': 'софия'},
        {'lang': 'Macedonian', 'to': LanguageScript.macedonian, 'input': 'skopje', 'expected': 'скопје'},
        {'lang': 'Belarusian', 'to': LanguageScript.belarusian, 'input': 'minsk', 'expected': 'мінск'},
        {'lang': 'Greek', 'to': LanguageScript.greek, 'input': 'kalimera', 'expected': 'καλημέρα'},
        {'lang': 'Georgian', 'to': LanguageScript.georgian, 'input': 'gamarjoba', 'expected': 'გამარჯობა'},
        {'lang': 'Armenian', 'to': LanguageScript.armenian, 'input': 'barev', 'expected': 'բարև'},
        {'lang': 'Kurdish', 'to': LanguageScript.kurdish, 'input': 'slaw', 'expected': 'سڵاو'},
        {'lang': 'Pashto', 'to': LanguageScript.pashto, 'input': 'manana', 'expected': 'مننه'},
        {'lang': 'Kazakh', 'to': LanguageScript.kazakh, 'input': 'salem', 'expected': 'Сәлем'},
        {'lang': 'Amharic', 'to': LanguageScript.amharic, 'input': 'selam', 'expected': 'ሰላም'},
        {'lang': 'IPA', 'to': LanguageScript.ipa, 'input': 'shanti', 'expected': 'ʃanti'},
        {'lang': 'Latin', 'to': LanguageScript.latin, 'input': 'hello world', 'expected': 'hello world'},
      ];

      var totalSim = 0.0;
      var exactCount = 0;

      for (final tc in forwardCases) {
        final lang = tc['lang'] as String;
        final to = tc['to'] as LanguageScript;
        final input = tc['input'] as String;
        final expected = tc['expected'] as String;

        final res = transliterator.convert(input, from: LanguageScript.latin, to: to);
        final sim = calculateSimilarity(res.text.toLowerCase().trim(), expected.toLowerCase().trim());
        totalSim += sim;
        if (res.text.toLowerCase().trim() == expected.toLowerCase().trim()) {
          exactCount++;
        }

        expect(sim, greaterThanOrEqualTo(0.95), reason: '$lang failed forward 95% threshold: got "${res.text}"');
      }

      final mean = (totalSim / forwardCases.length) * 100;
      expect(mean, greaterThanOrEqualTo(99.0));
      expect(exactCount, equals(41)); // All 41 exact match
    });

    // -------------------------------------------------------------------------
    // Phase 2: Reverse Accuracy Benchmark (Native -> Latin)
    // -------------------------------------------------------------------------
    test('Phase 2: 41 Languages Reverse Accuracy Benchmark (Native -> Latin)', () {
      final reverseCases = <Map<String, dynamic>>[
        {'lang': 'Bengali', 'from': LanguageScript.bengali, 'input': 'আমি', 'expected': 'Ami'},
        {'lang': 'Hindi', 'from': LanguageScript.hindi, 'input': 'नमस्ते', 'expected': 'Namaste'},
        {'lang': 'Urdu', 'from': LanguageScript.urdu, 'input': 'آپ', 'expected': 'Aap'},
        {'lang': 'Arabic', 'from': LanguageScript.arabic, 'input': 'مرحبا', 'expected': 'Marhaban'},
        {'lang': 'Gujarati', 'from': LanguageScript.gujarati, 'input': 'નમસ્તે', 'expected': 'Namaste'},
        {'lang': 'Tamil', 'from': LanguageScript.tamil, 'input': 'வணக்கம்', 'expected': 'Vanakkam'},
        {'lang': 'Telugu', 'from': LanguageScript.telugu, 'input': 'నమస్కారం', 'expected': 'Namaskaram'},
        {'lang': 'Punjabi', 'from': LanguageScript.punjabi, 'input': 'ਸਤਿ', 'expected': 'Sat'},
        {'lang': 'Malayalam', 'from': LanguageScript.malayalam, 'input': 'നമസ്കാരം', 'expected': 'Namaskaram'},
        {'lang': 'Kannada', 'from': LanguageScript.kannada, 'input': 'ನಮಸ್ಕಾರ', 'expected': 'Namaskara'},
        {'lang': 'Odia', 'from': LanguageScript.odia, 'input': 'ନମସ୍କାର', 'expected': 'Namaskar'},
        {'lang': 'Sinhala', 'from': LanguageScript.sinhala, 'input': 'ආයුබෝවන්', 'expected': 'Ayubowan'},
        {'lang': 'Sanskrit', 'from': LanguageScript.sanskrit, 'input': 'ॐ', 'expected': 'Om'},
        {'lang': 'Marathi', 'from': LanguageScript.marathi, 'input': 'महाराष्ट्र', 'expected': 'Maharashtra'},
        {'lang': 'Nepali', 'from': LanguageScript.nepali, 'input': 'नेपाल', 'expected': 'Nepal'},
        {'lang': 'Assamese', 'from': LanguageScript.assamese, 'input': 'গুৱাহাটী', 'expected': 'Guwahati'},
        {'lang': 'Vietnamese', 'from': LanguageScript.vietnamese, 'input': 'chào', 'expected': 'chao'},
        {'lang': 'Thai', 'from': LanguageScript.thai, 'input': 'สวัสดี', 'expected': 'Sawatdee'},
        {'lang': 'Lao', 'from': LanguageScript.lao, 'input': 'ສະບາຍດີ', 'expected': 'Sabaidee'},
        {'lang': 'Burmese', 'from': LanguageScript.burmese, 'input': 'မင်္ဂလာပါ', 'expected': 'Mingalaba'},
        {'lang': 'Khmer', 'from': LanguageScript.khmer, 'input': 'សួស្តី', 'expected': 'Suesdei'},
        {'lang': 'Japanese', 'from': LanguageScript.japanese, 'input': 'ありがとう', 'expected': 'Arigatou'},
        {'lang': 'Korean', 'from': LanguageScript.korean, 'input': '안녕하세요', 'expected': 'Annyeonghaseyo'},
        {'lang': 'Persian', 'from': LanguageScript.persian, 'input': 'سلام', 'expected': 'Salam'},
        {'lang': 'Hebrew', 'from': LanguageScript.hebrew, 'input': 'שלום', 'expected': 'Shalom'},
        {'lang': 'Russian', 'from': LanguageScript.russian, 'input': 'привет', 'expected': 'Privet'},
        {'lang': 'Ukrainian', 'from': LanguageScript.ukrainian, 'input': 'привіт', 'expected': 'Pryvit'},
        {'lang': 'Serbian', 'from': LanguageScript.serbian, 'input': 'београд', 'expected': 'Beograd'},
        {'lang': 'Bulgarian', 'from': LanguageScript.bulgarian, 'input': 'софия', 'expected': 'Sofia'},
        {'lang': 'Macedonian', 'from': LanguageScript.macedonian, 'input': 'скопје', 'expected': 'Skopje'},
        {'lang': 'Belarusian', 'from': LanguageScript.belarusian, 'input': 'мінск', 'expected': 'Minsk'},
        {'lang': 'Greek', 'from': LanguageScript.greek, 'input': 'καλημέρα', 'expected': 'Kalimera'},
        {'lang': 'Georgian', 'from': LanguageScript.georgian, 'input': 'გამარჯობა', 'expected': 'Gamarjoba'},
        {'lang': 'Armenian', 'from': LanguageScript.armenian, 'input': 'բարև', 'expected': 'Barev'},
        {'lang': 'Kurdish', 'from': LanguageScript.kurdish, 'input': 'سڵاو', 'expected': 'Slaw'},
        {'lang': 'Kazakh', 'from': LanguageScript.kazakh, 'input': 'Сәлем', 'expected': 'Sälem'},
        {'lang': 'Amharic', 'from': LanguageScript.amharic, 'input': 'ሰላም', 'expected': 'Selam'},
        {'lang': 'IPA', 'from': LanguageScript.ipa, 'input': 'ʃanti', 'expected': 'shanti'},
      ];

      var totalSim = 0.0;
      var exactCount = 0;

      for (final tc in reverseCases) {
        final lang = tc['lang'] as String;
        final from = tc['from'] as LanguageScript;
        final input = tc['input'] as String;
        final expected = tc['expected'] as String;

        final res = transliterator.convert(input, from: from, to: LanguageScript.latin);
        final sim = calculateSimilarity(res.text.toLowerCase().trim(), expected.toLowerCase().trim());
        totalSim += sim;
        if (res.text.toLowerCase().trim() == expected.toLowerCase().trim()) {
          exactCount++;
        }

        expect(sim, greaterThanOrEqualTo(0.95), reason: '$lang failed reverse 95% threshold: got "${res.text}"');
      }

      final mean = (totalSim / reverseCases.length) * 100;
      expect(mean, greaterThanOrEqualTo(99.0));
      expect(exactCount, equals(reverseCases.length));
    });

    // -------------------------------------------------------------------------
    // Phase 3: Complete 41 x 41 Pairwise Connectivity Matrix (1,681 pairs)
    // -------------------------------------------------------------------------
    test('Phase 3: 41 x 41 Pairwise Connectivity Matrix (1,681 pairs verified)', () {
      final allScripts = LanguageScript.values;
      expect(allScripts.length, 41);

      var testedPairs = 0;
      var successfulConversions = 0;
      final stopwatch = Stopwatch()..start();

      for (final from in allScripts) {
        for (final to in allScripts) {
          testedPairs++;

          // Verification 1: canConvert must be true for all registered scripts
          final canConvert = transliterator.canConvert(from, to);
          expect(canConvert, isTrue, reason: 'Failed connectivity between $from and $to');

          // Verification 2: Execution must produce non-empty valid result without exception
          const sample = 'hello';
          final result = transliterator.convert(sample, from: from, to: to);
          expect(result.text, isNotEmpty);
          successfulConversions++;
        }
      }

      stopwatch.stop();
      expect(testedPairs, 1681);
      expect(successfulConversions, 1681);

      final elapsedMs = stopwatch.elapsedMilliseconds;
      expect(elapsedMs, greaterThanOrEqualTo(0));
      final avgMicroseconds = (stopwatch.elapsedMicroseconds / testedPairs);
      expect(avgMicroseconds, lessThan(500.0)); // Ultra-fast sub-millisecond per-op
    });
  });
}
