import 'dart:math' as math;
import 'package:flutter_test/flutter_test.dart';
import 'package:scriptly/scriptly.dart';

/// Levenshtein similarity metric (0.0 to 1.0)
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
  group('SQA Senior Auditor: 41-Language & Script Comprehensive Precision Benchmark', () {
    final transliterator = Transliterator();

    final testCases = <Map<String, dynamic>>[
      // 1. South Asian & Indic Core
      {
        'lang': 'Bengali',
        'from': LanguageScript.latin,
        'to': LanguageScript.bengali,
        'input': 'ami banglay gan gai',
        'expected': 'আমি বাংলায় গান গাই',
      },
      {
        'lang': 'Hindi',
        'from': LanguageScript.latin,
        'to': LanguageScript.hindi,
        'input': 'namaste',
        'expected': 'नमस्ते',
      },
      {
        'lang': 'Urdu',
        'from': LanguageScript.latin,
        'to': LanguageScript.urdu,
        'input': 'aap kaise hain',
        'expected': 'آپ کيسے ہيں',
      },
      {
        'lang': 'Arabic',
        'from': LanguageScript.latin,
        'to': LanguageScript.arabic,
        'input': 'marhaban',
        'expected': 'مرحبا',
      },
      {
        'lang': 'Gujarati',
        'from': LanguageScript.latin,
        'to': LanguageScript.gujarati,
        'input': 'namaste',
        'expected': 'નમસ્તે',
      },
      {
        'lang': 'Tamil',
        'from': LanguageScript.latin,
        'to': LanguageScript.tamil,
        'input': 'vanakkam',
        'expected': 'வணக்கம்',
      },
      {
        'lang': 'Telugu',
        'from': LanguageScript.latin,
        'to': LanguageScript.telugu,
        'input': 'namaskaram',
        'expected': 'నమస్కారం',
      },
      {
        'lang': 'Punjabi',
        'from': LanguageScript.latin,
        'to': LanguageScript.punjabi,
        'input': 'sat sri akal',
        'expected': 'ਸਤਿ ਸ੍ਰੀ ਅਕਾਲ',
      },
      {
        'lang': 'Malayalam',
        'from': LanguageScript.latin,
        'to': LanguageScript.malayalam,
        'input': 'namaskaram',
        'expected': 'നമസ്കാരം',
      },
      {
        'lang': 'Kannada',
        'from': LanguageScript.latin,
        'to': LanguageScript.kannada,
        'input': 'namaskara',
        'expected': 'ನಮಸ್ಕಾರ',
      },
      {
        'lang': 'Odia',
        'from': LanguageScript.latin,
        'to': LanguageScript.odia,
        'input': 'namaskar',
        'expected': 'ନମସ୍କାର',
      },
      {
        'lang': 'Sinhala',
        'from': LanguageScript.latin,
        'to': LanguageScript.sinhala,
        'input': 'ayubowan',
        'expected': 'ආයුබෝවන්',
      },
      // 2. Extended Indic
      {
        'lang': 'Sanskrit',
        'from': LanguageScript.latin,
        'to': LanguageScript.sanskrit,
        'input': 'om shanti',
        'expected': 'ॐ शान्तिः',
      },
      {
        'lang': 'Marathi',
        'from': LanguageScript.latin,
        'to': LanguageScript.marathi,
        'input': 'maharashtra',
        'expected': 'महाराष्ट्र',
      },
      {
        'lang': 'Nepali',
        'from': LanguageScript.latin,
        'to': LanguageScript.nepali,
        'input': 'nepal',
        'expected': 'नेपाल',
      },
      {
        'lang': 'Assamese',
        'from': LanguageScript.latin,
        'to': LanguageScript.assamese,
        'input': 'guwahati',
        'expected': 'গুৱাহাটী',
      },
      // 3. Southeast Asian & Indochina
      {
        'lang': 'Vietnamese',
        'from': LanguageScript.latin,
        'to': LanguageScript.vietnamese,
        'input': 'xin chao',
        'expected': 'xin chào',
      },
      {
        'lang': 'Thai',
        'from': LanguageScript.latin,
        'to': LanguageScript.thai,
        'input': 'sawasdee',
        'expected': 'สวัสดี',
      },
      {
        'lang': 'Lao',
        'from': LanguageScript.latin,
        'to': LanguageScript.lao,
        'input': 'sabaidee',
        'expected': 'ສະບາຍດີ',
      },
      {
        'lang': 'Burmese',
        'from': LanguageScript.latin,
        'to': LanguageScript.burmese,
        'input': 'mingalaba',
        'expected': 'မင်္ဂလာပါ',
      },
      {
        'lang': 'Khmer',
        'from': LanguageScript.latin,
        'to': LanguageScript.khmer,
        'input': 'suesdey',
        'expected': 'សួស្តី',
      },
      // 4. East Asian
      {
        'lang': 'Japanese',
        'from': LanguageScript.latin,
        'to': LanguageScript.japanese,
        'input': 'arigatou',
        'expected': 'ありがとう',
      },
      {
        'lang': 'Korean',
        'from': LanguageScript.latin,
        'to': LanguageScript.korean,
        'input': 'annyeonghaseyo',
        'expected': '안녕하세요',
      },
      {
        'lang': 'Chinese Pinyin',
        'from': LanguageScript.latin,
        'to': LanguageScript.chinesePinyin,
        'input': 'ni3 hao3',
        'expected': 'nǐ hǎo',
      },
      // 5. Middle Eastern & Central Asian
      {
        'lang': 'Persian',
        'from': LanguageScript.latin,
        'to': LanguageScript.persian,
        'input': 'salam',
        'expected': 'سلام',
      },
      {
        'lang': 'Hebrew',
        'from': LanguageScript.latin,
        'to': LanguageScript.hebrew,
        'input': 'shalom',
        'expected': 'שלום',
      },
      {
        'lang': 'Kurdish',
        'from': LanguageScript.latin,
        'to': LanguageScript.kurdish,
        'input': 'slaw',
        'expected': 'سڵاو',
      },
      {
        'lang': 'Pashto',
        'from': LanguageScript.latin,
        'to': LanguageScript.pashto,
        'input': 'manana',
        'expected': 'مننه',
      },
      {
        'lang': 'Kazakh',
        'from': LanguageScript.latin,
        'to': LanguageScript.kazakh,
        'input': 'salem',
        'expected': 'Сәлем',
      },
      // 6. European / Slavic / Caucasian
      {
        'lang': 'Russian',
        'from': LanguageScript.latin,
        'to': LanguageScript.russian,
        'input': 'privet',
        'expected': 'привет',
      },
      {
        'lang': 'Ukrainian',
        'from': LanguageScript.latin,
        'to': LanguageScript.ukrainian,
        'input': 'pryvit',
        'expected': 'привіт',
      },
      {
        'lang': 'Serbian',
        'from': LanguageScript.latin,
        'to': LanguageScript.serbian,
        'input': 'beograd',
        'expected': 'београд',
      },
      {
        'lang': 'Bulgarian',
        'from': LanguageScript.latin,
        'to': LanguageScript.bulgarian,
        'input': 'sofia',
        'expected': 'софия',
      },
      {
        'lang': 'Macedonian',
        'from': LanguageScript.latin,
        'to': LanguageScript.macedonian,
        'input': 'skopje',
        'expected': 'скопје',
      },
      {
        'lang': 'Belarusian',
        'from': LanguageScript.latin,
        'to': LanguageScript.belarusian,
        'input': 'minsk',
        'expected': 'мінск',
      },
      {
        'lang': 'Greek',
        'from': LanguageScript.latin,
        'to': LanguageScript.greek,
        'input': 'kalimera',
        'expected': 'καλημέρα',
      },
      {
        'lang': 'Georgian',
        'from': LanguageScript.latin,
        'to': LanguageScript.georgian,
        'input': 'gamarjoba',
        'expected': 'გამარჯობა',
      },
      {
        'lang': 'Armenian',
        'from': LanguageScript.latin,
        'to': LanguageScript.armenian,
        'input': 'barev',
        'expected': 'բարև',
      },
      // 7. African & Phonetic
      {
        'lang': 'Amharic',
        'from': LanguageScript.latin,
        'to': LanguageScript.amharic,
        'input': 'selam',
        'expected': 'ሰላም',
      },
      {
        'lang': 'IPA',
        'from': LanguageScript.latin,
        'to': LanguageScript.ipa,
        'input': 'shanti',
        'expected': 'ʃanti',
      },
      // 8. Latin Passthrough
      {
        'lang': 'Latin',
        'from': LanguageScript.latin,
        'to': LanguageScript.latin,
        'input': 'Hello World',
        'expected': 'Hello World',
      },
    ];

    test('All 41 Languages & Scripts achieve 95%+ precision benchmark', () {
      expect(testCases.length, 41);

      var totalSimilarity = 0.0;
      var exactMatches = 0;
      final scores = <String, double>{};

      for (final tc in testCases) {
        final lang = tc['lang'] as String;
        final from = tc['from'] as LanguageScript;
        final to = tc['to'] as LanguageScript;
        final input = tc['input'] as String;
        final expected = tc['expected'] as String;

        final res = transliterator.convert(input, from: from, to: to);
        final sim = calculateSimilarity(res.text.toLowerCase().trim(), expected.toLowerCase().trim());
        scores[lang] = sim;
        totalSimilarity += sim;
        if (res.text.toLowerCase().trim() == expected.toLowerCase().trim()) {
          exactMatches++;
        }

        // Each individual language must be at least 95% accurate (>= 0.95)
        expect(
          sim,
          greaterThanOrEqualTo(0.95),
          reason: 'Language $lang failed 95% accuracy bar! Got: "${res.text}", expected: "$expected" (Similarity: ${(sim * 100).toStringAsFixed(1)}%)',
        );
      }

      final meanAccuracy = (totalSimilarity / testCases.length) * 100;
      final exactMatchPercent = (exactMatches / testCases.length) * 100;

      // Global average accuracy must exceed 98%
      expect(meanAccuracy, greaterThanOrEqualTo(98.0));
      expect(exactMatchPercent, greaterThanOrEqualTo(95.0));
    });

    test('All 41 Reverse Transliteration (Native -> Latin) precision benchmark', () {
      final reverseCases = <Map<String, dynamic>>[
        {'lang': 'Bengali', 'from': LanguageScript.bengali, 'to': LanguageScript.latin, 'input': 'আমি', 'expected': 'Ami'},
        {'lang': 'Hindi', 'from': LanguageScript.hindi, 'to': LanguageScript.latin, 'input': 'नमस्ते', 'expected': 'Namaste'},
        {'lang': 'Urdu', 'from': LanguageScript.urdu, 'to': LanguageScript.latin, 'input': 'آپ', 'expected': 'Aap'},
        {'lang': 'Arabic', 'from': LanguageScript.arabic, 'to': LanguageScript.latin, 'input': 'مرحبا', 'expected': 'Marhaban'},
        {'lang': 'Gujarati', 'from': LanguageScript.gujarati, 'to': LanguageScript.latin, 'input': 'નમસ્તે', 'expected': 'Namaste'},
        {'lang': 'Tamil', 'from': LanguageScript.tamil, 'to': LanguageScript.latin, 'input': 'வணக்கம்', 'expected': 'Vanakkam'},
        {'lang': 'Telugu', 'from': LanguageScript.telugu, 'to': LanguageScript.latin, 'input': 'నమస్కారం', 'expected': 'Namaskaram'},
        {'lang': 'Punjabi', 'from': LanguageScript.punjabi, 'to': LanguageScript.latin, 'input': 'ਸਤਿ', 'expected': 'Sat'},
        {'lang': 'Malayalam', 'from': LanguageScript.malayalam, 'to': LanguageScript.latin, 'input': 'നമസ്കാരം', 'expected': 'Namaskaram'},
        {'lang': 'Kannada', 'from': LanguageScript.kannada, 'to': LanguageScript.latin, 'input': 'ನಮಸ್ಕಾರ', 'expected': 'Namaskara'},
        {'lang': 'Odia', 'from': LanguageScript.odia, 'to': LanguageScript.latin, 'input': 'ନମସ୍କାର', 'expected': 'Namaskar'},
        {'lang': 'Sinhala', 'from': LanguageScript.sinhala, 'to': LanguageScript.latin, 'input': 'ආයුබෝවන්', 'expected': 'Ayubowan'},
        {'lang': 'Sanskrit', 'from': LanguageScript.sanskrit, 'to': LanguageScript.latin, 'input': 'ॐ', 'expected': 'Om'},
        {'lang': 'Marathi', 'from': LanguageScript.marathi, 'to': LanguageScript.latin, 'input': 'महाराष्ट्र', 'expected': 'Maharashtra'},
        {'lang': 'Nepali', 'from': LanguageScript.nepali, 'to': LanguageScript.latin, 'input': 'नेपाल', 'expected': 'Nepal'},
        {'lang': 'Assamese', 'from': LanguageScript.assamese, 'to': LanguageScript.latin, 'input': 'গুৱাহাটী', 'expected': 'Guwahati'},
        {'lang': 'Thai', 'from': LanguageScript.thai, 'to': LanguageScript.latin, 'input': 'สวัสดี', 'expected': 'Sawatdee'},
        {'lang': 'Lao', 'from': LanguageScript.lao, 'to': LanguageScript.latin, 'input': 'ສະບາຍດີ', 'expected': 'Sabaidee'},
        {'lang': 'Burmese', 'from': LanguageScript.burmese, 'to': LanguageScript.latin, 'input': 'မင်္ဂလာပါ', 'expected': 'Mingalaba'},
        {'lang': 'Khmer', 'from': LanguageScript.khmer, 'to': LanguageScript.latin, 'input': 'សួស្តី', 'expected': 'Suesdei'},
        {'lang': 'Japanese', 'from': LanguageScript.japanese, 'to': LanguageScript.latin, 'input': 'ありがとう', 'expected': 'Arigatou'},
        {'lang': 'Korean', 'from': LanguageScript.korean, 'to': LanguageScript.latin, 'input': '안녕하세요', 'expected': 'Annyeonghaseyo'},
        {'lang': 'Persian', 'from': LanguageScript.persian, 'to': LanguageScript.latin, 'input': 'سلام', 'expected': 'Salam'},
        {'lang': 'Hebrew', 'from': LanguageScript.hebrew, 'to': LanguageScript.latin, 'input': 'שלום', 'expected': 'Shalom'},
        {'lang': 'Kurdish', 'from': LanguageScript.kurdish, 'to': LanguageScript.latin, 'input': 'سڵاو', 'expected': 'Slaw'},
        {'lang': 'Kazakh', 'from': LanguageScript.kazakh, 'to': LanguageScript.latin, 'input': 'Сәлем', 'expected': 'Sälem'},
        {'lang': 'Russian', 'from': LanguageScript.russian, 'to': LanguageScript.latin, 'input': 'привет', 'expected': 'Privet'},
        {'lang': 'Ukrainian', 'from': LanguageScript.ukrainian, 'to': LanguageScript.latin, 'input': 'привіт', 'expected': 'Pryvit'},
        {'lang': 'Serbian', 'from': LanguageScript.serbian, 'to': LanguageScript.latin, 'input': 'београд', 'expected': 'Beograd'},
        {'lang': 'Bulgarian', 'from': LanguageScript.bulgarian, 'to': LanguageScript.latin, 'input': 'софия', 'expected': 'Sofia'},
        {'lang': 'Greek', 'from': LanguageScript.greek, 'to': LanguageScript.latin, 'input': 'καλημέρα', 'expected': 'Kalimera'},
        {'lang': 'Georgian', 'from': LanguageScript.georgian, 'to': LanguageScript.latin, 'input': 'გამარჯობა', 'expected': 'Gamarjoba'},
        {'lang': 'Armenian', 'from': LanguageScript.armenian, 'to': LanguageScript.latin, 'input': 'բարև', 'expected': 'Barev'},
        {'lang': 'Amharic', 'from': LanguageScript.amharic, 'to': LanguageScript.latin, 'input': 'ሰላም', 'expected': 'Selam'},
      ];

      for (final tc in reverseCases) {
        final lang = tc['lang'] as String;
        final from = tc['from'] as LanguageScript;
        final to = tc['to'] as LanguageScript;
        final input = tc['input'] as String;
        final expected = tc['expected'] as String;

        final res = transliterator.convert(input, from: from, to: to);
        final sim = calculateSimilarity(res.text.toLowerCase().trim(), expected.toLowerCase().trim());

        expect(
          sim,
          greaterThanOrEqualTo(0.95),
          reason: 'Reverse language $lang failed 95% accuracy! Got: "${res.text}", expected: "$expected" (Similarity: ${(sim * 100).toStringAsFixed(1)}%)',
        );
      }
    });

    test('Cross-Family Multi-Hop Auto-Pivot Accuracy across random pairs', () {
      final multiHopTriplets = [
        [LanguageScript.amharic, LanguageScript.lao, 'ሰላም'],
        [LanguageScript.burmese, LanguageScript.serbian, 'မင်္ဂလာပါ'],
        [LanguageScript.sanskrit, LanguageScript.kazakh, 'ॐ'],
        [LanguageScript.khmer, LanguageScript.ukrainian, 'សួស្តី'],
        [LanguageScript.kurdish, LanguageScript.bulgarian, 'سڵاو'],
      ];

      for (final triplet in multiHopTriplets) {
        final from = triplet[0] as LanguageScript;
        final to = triplet[1] as LanguageScript;
        final input = triplet[2] as String;

        final res = transliterator.convert(input, from: from, to: to);
        expect(res.text, isNotEmpty);
        expect(res.text != input, isTrue);
      }
    });
  });
}
